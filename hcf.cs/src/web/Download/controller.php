<?php
use \hcf\core\Utils;
use \hcf\core\log\Internal as IL;
use \hcf\core\remote\Invoker as RI;
// TODO: verschieben in hcf.web.*
trait Controller
{
	private $file = null;
	private $context = null;

	public function onConstruct($file = null, $context = null)
	{
		// if no arguments were passed, hcf.http.Download will try to initialize itself by the $_GET array
		if (!is_string($file) || !is_string($context))
		{
			list($file, $context) = self::readGetArgs();
		}

		$this->file = $file;
		$this->context = $context;
	}

	private function freeSession()
	{
		if (session_status() == PHP_SESSION_ACTIVE)
		{
			session_write_close();
		}
	}

	private function provideDownload()
	{
		$cs = $this->loadContextSection();
		$chunk_size = 8*1024;// default chunk-size is 8kb
		$limit = 0;// default limit is unlimited

		if (isset($cs->challenger))
		{
			$this->doChallenge($cs->challenger);
		}

		if (isset($cs->{'chunk-size'}))
		{
			$chunk_size = Utils::parseByteString($cs->{'chunk-size'});
		}

		if (isset($cs->limit))
		{
			$limit = Utils::parseByteString($cs->limit);

			if ($limit > 0 && $chunk_size > $limit)
			{
				$chunk_size = $limit;// don't send a chunk bigger than the allowed bytes per second (this will exceed the limit by the first chunk sent)
			}
		}

		$file = $this->checkFile($cs->root);

		IL::log()->info(self::FQN.' - providing file "'.$file.'" trough context "'.$this->context.'" in '.$chunk_size.'b chunks and limited by '.$limit.'b/s');

		$file_name = basename($file);
		header(Utils::getHTTPHeader(200));
		header('Content-Description: File Transfer');
		header('Content-Type: '.Utils::getMimeTypeByExtension($file_name));
		header('Content-Disposition: inline; filename="'.$file_name.'"');
		header('Content-Length: '.filesize($file));
    	
		set_time_limit(0);
		$file_handle = @fopen($file, "rb");// rb -> read as binary
		$bytes_per_second = 0;

		$begin = time();
		$delta = 0;

		$this->freeSession();

		while (!feof($file_handle))
		{
			$delta = time() - $begin;

			if ($delta == 0)
			{
				// a second ain't over yet, continue sending
				$bytes_per_second += $chunk_size;
			}
			else
			{
				// second is over, reset
				$begin = time();
				$delta = 0;
				$bytes_per_second = 0;
			}

			if ($bytes_per_second > $limit && $limit > 0)
			{
				// here's the limit
				usleep(10000);// sleep for 10ms
				continue;
			}

			print(@fread($file_handle, $chunk_size));
			ob_flush();
			flush();
		}
	}

	private function checkFile($by_root)
	{
		$by_root = realpath($by_root);// make root absolute
		$file = $this->file;

		if (substr($file, 0, 1) != '/')
		{
			// relative path was used, prepend root
			$file = $by_root.'/'.$file;
		}
		else
		{
			// absolute path was used, check if it begins with our configured root-directory
			if (substr($file, 0, strlen($by_root)) != $by_root)
			{
				$e = new \Exception(self::FQN.' - unable to provide file "'.$this->file.'" from context "'.$this->context.'" - requested path is not part of context-root "'.$by_root.'"');

				IL::log()->error($e);
				IL::log()->error(self::FQN.' - sending HTTP-response 403 and rethrowing exception');
				header(Utils::getHTTPHeader(403));

				throw $e;
			}
		}

		if (!file_exists($file))
		{
			$e = new \Exception(self::FQN.' - unable to provide file "'.$this->file.'" from context "'.$this->context.'" - requested file does not exist');
			IL::log()->error($e);
			header(Utils::getHTTPHeader(404));

			throw $e;
		}

		return $file;
	}

	private function doChallenge($challenger_section)
	{
		if (!isset($challenger_section->name))
		{
			throw new \Exception(self::FQN.' - cannot execute challenger for download-context "'.$this->context.'" - no challenger-name was configured');
		}
		else if (!isset($challenger_section->method))
		{
			throw new \Exception(self::FQN.' - cannot execute challenger for download-context "'.$this->context.'" - no challenger-method was configured');
		}

		RI::implicitConstructor(false);
		$ri = new RI($challenger_section->name);
		$args = [];

		if (isset($challenger_section->args) && (bool)$challenger_section->args === true)
		{
			$args = [$this->file, $this->context];
		}

		try
		{
			$ri->invoke($challenger_section->method, $args);
		}
		catch (\Exception $e)
		{
			IL::log()->error(self::FQN.' - unable to provide file "'.$this->file.'" from context "'.$this->context.'" - challenger "'.$challenger_section->name.'::'.$challenger_section->method.'" failed due exception below: ');
			IL::log()->error($e);
			IL::log()->error(self::FQN.' - sending HTTP-response 403 and rethrowing exception');
			header(Utils::getHTTPHeader(403));

			throw $e; // throw again
		}
	}

	private static function readGetArgs()
	{
		if (!isset(self::config()->arg))
		{
			throw new \Exception(self::FQN.' - missing configuration for initialisation-arguments');
		}
		else if (!isset(self::config()->arg->file))
		{
			throw new \Exception(self::FQN.' - missing configuration for file-argument');
		}
		else if (!isset(self::config()->arg->context))
		{
			throw new \Exception(self::FQN.' - missing configuration for context-argument');
		}

		$file_arg = self::config()->arg->file;
		$context_arg = self::config()->arg->context;

		if (!isset($_GET))
		{
			throw new \Exception(self::FQN.' - cannot initialize by URL-arguments, no arguments were passed');
		}
		else if (!isset($_GET[$file_arg]))
		{
			throw new \Exception(self::FQN.' - cannot initialize by URL-arguments, file-argument was not passed');
		}
		else if (!isset($_GET[$context_arg]))
		{
			throw new \Exception(self::FQN.' - cannot initialize by URL-arguments, context-argument was not passed');
		}

		$file = str_replace('..', '', htmlentities($_GET[$file_arg]));
		$context = htmlentities($_GET[$context_arg]);

		return [$file, $context];
	}

	private function loadContextSection()
	{
		if (!isset(self::config()->{$this->context}))
		{
			throw new \Exception(self::FQN.' - section for download-context "'.$this->context.'" does not exist');
		}

		if (!isset(self::config()->{$this->context}->root))
		{
			throw new \Exception(self::FQN.' - section for download-context "'.$this->context.'" cannot be used - root-directory was not configured');
		}
		else
		{
			$root = self::config()->{$this->context}->root;

			if (!file_exists($root) || !is_dir($root))
			{
				throw new \Exception(self::FQN.' - section for download-context "'.$this->context.'" cannot be used - root directory "'.$root.'" does not exist or is not a directory');
			}
		}

		return self::config()->{$this->context};
	}
}
?>

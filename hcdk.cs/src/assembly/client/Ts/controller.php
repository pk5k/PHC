<?php
use \hcdk\raw\Method as Method;
use \hcf\core\log\Internal as InternalLogger;

trait Controller
{
	public function getType()
	{
		return 'TS';
	}

	protected function sourceIsAttachment()
	{
		return false;
	}

	protected function minifyJS($js_data)
	{
		if(self::config()->jshrink->minify)
		{
			$keep = (self::config()->jshrink->{'keep-doc-blocks'}) ? true : false;

			$flagged_comments = ['flaggedComments' => $keep];

			return \JShrink\Minifier::minify($js_data, $flagged_comments);
		}

		return $js_data;
	}

	public function buildClient()
	{
		$temp_name = basename($this->for_file, '.ts').'.compiled.js';
		$file_path = dirname($this->for_file);
		$temp_file = $file_path.'/'.$temp_name;
		
		$windows = strpos(PHP_OS, 'WIN') === 0;
  		$test = $windows ? 'where' : 'command -v';
  		
  		if (!is_executable(trim(shell_exec("$test tsc"))))
  		{
  			throw new \Exception(self::FQN.' -  typescript compiler (tsc) seems to be missing: https://github.com/microsoft/TypeScript/#installing');
  		}

		$tsc_out = shell_exec('tsc '.$this->for_file.' --outFile '.$temp_file);

		if ($tsc_out != '')
		{
			if (file_exists($temp_file)) 
			{
				unlink($temp_file);
			}

			throw new \Exception('Typescript compilation errors for '. $this->for_file.":\n".$tsc_out);
		}

		if (!file_exists($temp_file))
		{
			throw new \Exception(self::FQN.' - no compiled typescript output found at '.$temp_file);
		}
		
		$raw_input = file_get_contents($temp_file);
		unlink($temp_file);

		$client_data = str_replace('"', '\\"', $this->minifyJS($raw_input));
		$client_data = str_replace('$', '\\$', $client_data);//Escape the $ for e.g. jQuery

		$method = new Method('script', ['public', 'static']);
		$method->setBody($this->buildClientMethod($client_data));

		//$client_data = $this->processPlaceholders($client_data);

		return $method;
	}

	public function getStaticMethods()
	{
		$methods = [];

		$methods['script'] = $this->buildClient();

		return $methods;
	}

	public function defaultInput() { return 'Class Client {}'; }

	public function getTraits()
	{
		return ['Client' => '\\hcf\\core\\dryver\\Client', 'ClientTs' => '\\hcf\\core\\dryver\\Client\\Js'];
	}
}
?>

<?php
use \hcdk\raw\Cellspace as Cellspace;
use \hcf\core\remote\Invoker as RemoteInvoker;
use \hcf\core\log\Internal as InternalLogger;
use \hcf\core\Utils as Utils;

trait Controller
{
	private $name = null;
	private $offset = null;
	private $cellspace = null;
	private $build = null;
	private $assemblies = null;

	private $buildable = false;
	private $executable = false;
	private $abstract = false;

	public function onConstruct($cellspace, $offset)
	{
		$this->init($cellspace, $offset);
	}

	public function getAssemblies()
	{
		return $this->assemblies;
	}

	public function getName()
	{
		return $this->name;
	}

	public function getCellspace()
	{
		return $this->cellspace;
	}

	public function getOffset()
	{
		return $this->offset;
	}

	public function rebuildRequired()
	{
		// if the checksum inside the internal-assembly is different to
		// the live-created checksum of our assemblies, a rebuild is required
		// because one or more assembly-sources have changed.
		$current_checksum = $this->build->checksum;
		$new_checksum = $this->newBuildChecksum();

		return ($current_checksum != $new_checksum);
	}

	public function isBuildable()
	{
		return $this->buildable;
	}

	public function isExecutable()
	{
		return $this->executable;
	}

	public function isAbstract()
	{
		return $this->abstract;
	}

	public function write()
	{
		$settings = $this->cellspace->getSettings();
		$path_raw = $this->cellspace->getRoot().$settings->target;
		$path = realpath($path_raw).'/';

		if (!is_writable($path))
		{
			throw new \Exception('Unable to write Hypercell '.$this->name->long.' to "'.$path_raw.'" - directory is not writeable');
		}

		$file = $path.$this->name->long.'.'.self::config()->extension;

		if (file_exists($file) && !is_writable($file))
		{
			throw new \Exception('Unable to write Hypercell '.$this->name->long.' to "'.$file.'" - file is not writeable');
		}

		$output = $this->toString();
		$output = ltrim($output);// cutoff whitespaces before <?php

		if ($settings->format)
		{
			$formatter = new \PHP_Beautifier();
	    	$formatter->setInputString($output);
	    	$formatter->process();

	    	$output = $formatter->get();
		}

		return file_put_contents($file, $output);
	}

	public function writeBuildInfo($new = true)
	{
		$settings = $this->cellspace->getSettings();
		$path = realpath($this->cellspace->getRoot().$settings->source.'/'.$this->offset).'/';

		if (!is_writable($path))
		{
			throw new \Exception('Cannot write build information to "'.$path.'" - directory is not writeable');
		}

		$file = $path.self::config()->internal->file;

		if (file_exists($file) && !is_writable($file))
		{
			throw new \Exception('Build information file "'.$file.'" is not writeable');
		}

		if ($new)
		{
			$this->newBuildInfo();
		}

		$build_info = $this->build->no.'@'.$this->build->checksum;

		return file_put_contents($file, $build_info);
	}

	public function getBuildInfo()
	{
		return $this->build;
	}

	private function init($cellspace, $offset)
	{
		if (!($cellspace instanceof Cellspace))
		{
			throw new \Exception('Given cellspace is not an hcdk.raw.Cellspace instance');
		}

		$this->cellspace = $cellspace;

		$this->resolveName($offset);
		$this->readBuildInfo();
		$this->collectAssemblies();
		$this->checkBuildable();
		$this->checkExecutable();
		$this->checkAbstract();
	}

	private function readBuildInfo()
	{
		$settings = $this->cellspace->getSettings();
		$file = realpath($this->cellspace->getRoot().$settings->source.'/'.$this->offset.'/'.self::config()->internal->file);

		$this->build = new \stdClass();
		$this->build->no = '?';
		$this->build->checksum = '?';

		if (is_readable($file))
		{
			$lines = file($file);

			if (count($lines) > 0 && strpos($lines[0], '@') !== false)
			{
				// new build-info Notation splitted with @ instead of a new line (which causes some problems)
				$lines = explode('@', $lines[0]);
			}

			// The last build-number of this Hypercell
			if (count($lines) > 0)
			{
				$this->build->no = trim($lines[0]);
			}

			// The checksum of all assemblies
			if (count($lines) > 1)
			{
				$this->build->checksum = trim($lines[1]);
			}
		}
	}

	private function newBuildInfo()
	{
		$this->build->no = $this->newBuildNo();
		$this->build->checksum = $this->newBuildChecksum();
	}

	private function newBuildNo()
	{
		$build_count = 0;
		$parts = explode('#', $this->build->no);

		if (count($parts) > 0)
		{
			$build_count_str = $parts[count($parts) - 1];
			$build_count = (int) $build_count_str;
		}

		$build_count += 1;
		$build_no = date('y.m.d').'#'.$build_count;

		return $build_no;
	}

	private function newBuildChecksum()
	{
		$new_cs = '';

		foreach ($this->assemblies as $assembly)
		{
			$new_cs .= $assembly->getChecksum();
		}

		return md5($new_cs);
	}

	private function collectAssemblies()
	{
		$this->assemblies = [];

		$settings = $this->cellspace->getSettings();
		$path = realpath($this->cellspace->getRoot().$settings->source.'/'.$this->offset);
		$files = glob($path.'/*');

		foreach ($files as $file)
		{
			$assembly_instance = null;

			// Don't try to resolve following paths as assembly: current directory, parent directory, 
			// each name that represents a directory, the internal build-assembly, every assembly starting with _ (use this prefix for e.g. scss-import-files to avoid warnings on compile-time)
			if (basename($file) == '.' || basename($file) == '..' || is_dir($file) || basename($file) == self::config()->internal->file || substr(basename($file), 0, 1) == '_')
			{
				continue;
			}

			try
			{
				$assembly_instance = self::getAssemblyInstance($file);
				$assembly_instance->forHypercell($this);
			}
			catch(\Exception $e)
			{
				InternalLogger::log()->info($this->name->long.' - cannot resolve assembly for file "'.$file.'" due following exception:');
				InternalLogger::log()->info($e);

				continue;
			}

			$assembly_hcfqn = self::resolveAssemblyHCFQN($file);
			$this->assemblies[$assembly_hcfqn] = $assembly_instance;
		}
	}

	public static function resolveAssemblyHCFQN($file)
	{
		$assembly = basename($file);

		if (strpos($assembly, '.') === false)
		{
			$assembly = ucfirst($assembly);
		}
		else
		{
			$split = explode('.', $assembly);
			$assembly = $split[0].'.'.ucfirst($split[1]);
		}

		$base_ns = self::config()->assembly;

		if (substr($base_ns, -1) !== '.')
		{
			$base_ns .= '.';
		}

		return $base_ns.$assembly;
	}

	public static function getAssemblyInstance($file, $check = true)
	{
		$assembly = self::resolveAssemblyHCFQN($file);

		RemoteInvoker::implicitConstructor(true);
		$invoker = new RemoteInvoker($assembly, [file_get_contents($file), $file]);
		$instance = $invoker->getInstance();

		if (!($instance instanceof \hcdk\assembly))
		{
			throw new \Exception('Created instance of assembly '.$assembly.' is not an '.self::FQN.' generalisation and therefore can\'t be used');
		}

		if ($check)
		{
			$instance->checkInput();
		}

		return $instance;
	}

	private function checkBuildable()
	{
		$settings = $this->cellspace->getSettings();

		// a hypercell is buildable if it contains at least one valid assembly,
		// the source-directory must be writable for the internal file
		// and the short name must be at least one char long
		$path = realpath($this->cellspace->getRoot().$settings->source.'/'.$this->offset);

		if (count($this->assemblies) > 0 && is_writable($path) && strlen($this->name->short) > 0)
		{
			$this->buildable = true;
		}
		else
		{
			$this->buildable = false;
		}
	}

	private function checkExecutable()
	{
		$settings = $this->cellspace->getSettings();

		// if a *.hc file exists under the given offset
		// this HC was already built and could be executed
		$file = realpath($this->cellspace->getRoot().$settings->target.'/'.$this->getName()->long.'.'.self::config()->extension);

		$this->executable = file_exists($file);
	}

	private function checkAbstract()
	{
		// if the short-name of this hypercell begins with a lower-case
		// character, this Hypercell is an abstract one (supercell?)
		// Therefore, it should contain children-hypercells with this HCFQN referred
		// inside each base-assembly
		if (!strlen($this->name->short))
		{
			return false;
		}

		$this->abstract = (ctype_lower($this->name->short{0}));
	}

	private function resolveName($offset)
	{
		if (!is_string($offset) || strlen($offset) < 1)
		{
			throw new \Exception('Given offset is not a valid string');
		}

		$this->offset = $offset;

		$settings = $this->cellspace->getSettings();
		$this->name = new \stdClass();

		$this->name->short = '';
		$this->name->long = '';
		$this->name->space = '';

		// Hypercell names will be resolved by their location inside the cellspace
		$ns_root = $settings->nsroot;
		$this->name->long = $ns_root . '.' . Utils::pathToHCName($this->offset);

		$split = explode('.', $this->name->long);
		$this->name->short = array_pop($split);
		$this->name->space = implode('.', $split);
	}

	private function requiredAliases()
	{
		$deps = '';

		foreach ($this->assemblies as $assembly)
		{
			$aliases = $assembly->getAliases() ?: [];

			if (count($aliases) > 0)
			{
				foreach ($aliases as $alias)
				{
					$use = null;
					$as = null;

					foreach ($alias as $token => $content)
					{
						// the T_ constants will be converted to string by the class parser
						switch ($token)
						{
							case 'T_USE':
								$use = $content;
								break;

							case 'T_AS':
								$as = $content;
								break;
						}
					}

					$use = 'use '.$use;
					$as = ((isset($as)) ? ' as '.$as : '');

					$deps .= $use.$as.';'.Utils::newLine();
				}
			}
		}

		return $deps;
	}

	private function constructorRows()
	{
		$rows = [];

		foreach ($this->assemblies as $assembly)
		{
			$row = $assembly->getConstructor();

			if (is_array($row))
			{
				$rows = array_replace($rows, $row);
			}
		}

		if (!ksort($rows))
		{
			throw new \Exception(self::FQN.' - unable to sort constructor-rows by keys');
		}

		return implode(Utils::newLine(), $rows);
	}

	private function requiredTraits()
	{
		$traits = '';

		foreach ($this->assemblies as $assembly)
		{
			$traits .= implode(',', $assembly->getTraits()).',';
		}

		// add internal trait
		$traits .= self::config()->internal->trait;

		return $traits;
	}

	private function assemblyFrames()
	{
		$assemblies = '';

		foreach ($this->assemblies as $assembly)
		{
			$an = $assembly->getName();
			$an .= ($assembly->getType() != '') ? ('.'.$assembly->getType()) : '';

			$frame_begin = $this->assemblyFrame('BEGIN', $an).Utils::newLine();
			$frame_body = '';
			$frame_end = Utils::newLine().$this->assemblyFrame('END', $an).Utils::newLine();

			$methods = $assembly->getMethods() ?: [];
			$props = $assembly->getProperties() ?: [];
			$s_props = $assembly->getStaticProperties() ?: [];
			$s_methods = $assembly->getStaticMethods() ?: [];

			$frame_body .= implode(Utils::newLine(), $props);
			$frame_body .= implode(Utils::newLine(), $methods);
			$frame_body .= implode(Utils::newLine(), $s_props);
			$frame_body .= implode(Utils::newLine(), $s_methods);

			if (strlen($frame_body) > 0)
			{
				$assemblies .= $frame_begin.$frame_body.$frame_end;
			}
		}

		return $assemblies;
	}

	private static function stripPHPTags($input)
	{
		// executable attachments contain php-tags in their raw-input
		// remove them here by removing the first and the last line
		// we can't simply preg_/str_replace here, because controller traits
		// may also container string with tags
		$input = trim($input);
		$lines = explode("\n", $input);
		array_shift($lines);// first line - < ?[php]
		array_pop($lines);// last line - ? >
		return trim(implode("\n", $lines));
	}

	private function executableFrames()
	{
		$execs = '';

		foreach ($this->getAssemblies() as $assembly)
		{
			if ($assembly->isExecutable())
			{
				$an = $assembly->getName();
				$an .= ($assembly->getType() != '') ? ('.'.$assembly->getType()) : '';

				$frame_begin = $this->executableFrame('BEGIN', $an).Utils::newLine();
				$frame_body = self::stripPHPTags($assembly->rawInput());
				$frame_end = Utils::newLine().$this->executableFrame('END', $an).Utils::newLine();

				if (strlen($frame_body) > 0)
				{
					$execs .= $frame_begin.$frame_body.$frame_end;
				}
			}
		}

		return $execs;
	}

	private function attachmentFrames()
	{
		$attachments = '';

		foreach ($this->getAssemblies() as $assembly)
		{
			if ($assembly->isAttachment())
			{
				$an = $assembly->getName();
				$an .= ($assembly->getType() != '') ? ('.'.$assembly->getType()) : '';

				// to match attachments properly, it must match this regex from hcf.core.dryver.Internal: BEGIN\[ASSEMBLYNAME\.ASSEMBLYTYPE\]((?:\s|.)*)END\[ASSEMBLYNAME\.ASSEMBLYTYPE\]
				$frame_begin = $this->attachmentFrame('BEGIN', $an).Utils::newLine();
				$frame_body = $assembly->rawInput();
				$frame_end = Utils::newLine().$this->attachmentFrame('END', $an).Utils::newLine();

				if (strlen($frame_body) > 0)
				{
					$attachments .= $frame_begin.$frame_body.$frame_end;
				}
			}
		}

		return $attachments;
	}

	private function classType()
	{
		return (($this->abstract) ? 'abstract' : '');
	}

	private function classNamespace()
	{
		return Utils::HCFQN2PHPFQN($this->name->space);
	}

	private function executableNamespace()
	{
		// executable assemblies using the HCFQN + an executable offset as their namespace - my.hypercell.Name@controller.php would be my\hypercell\Name\__EO__\Controller
		return Utils::HCFQN2PHPFQN($this->name->long.'.__EO__');
	}


	private function classModifiers()
	{
		$mods_str = '';

		foreach ($this->assemblies as $assembly)
		{
			$mods = $assembly->getClassModifiers() ?: [];

			foreach ($mods as $modifier => $names)
			{
				$mods_str .= ' '.$modifier.' '.implode(', ', $mods[$modifier]);
			}
		}

		return $mods_str;
	}
}
?>

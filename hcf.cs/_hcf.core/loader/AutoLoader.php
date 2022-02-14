<?php
namespace hcf\core\loader
{
	use \hcf\core\log\Internal as InternalLogger;

	/**
	 * AutoLoader
	 * Wrapper class for PHPs spl_autoload_register function to load raw-merges by their FQN automatically
	 *
	 * @category Autoloader
	 * @package hcf.core.loader
	 * @author Philipp Kopf
	 * @see http://php.net/manual/de/function.spl-autoload-register.php
	 */
	class AutoLoader
	{
		private $directory = null;
		private $classes = [];
		private static $instances = [];

		/**
		 * __construct
		 * Sets up an instance and registers the given directory for autoloading raw-merges by the map-file
		 *
		 * @param $for_directory - string - the root-directory, this instance should search files in
		 * @param $map_file - string - the path to a rmbt.map file inside $for_directory
		 *
		 * @throws RuntimeException
		 * @return void
		 */
		public function __construct($for_directory, $map_file)
		{
			if(!file_exists($map_file))
			{
				throw new \RuntimeException('Map file "'.$map_file.'" not found in "'.$for_directory.'".');
			}

			$this->directory = $for_directory;
			$lines = file($map_file);

			foreach($lines as $line)
			{
				list($class, $file) = explode('=', $line);
				$file = trim($file);

				$this->classes[$class] = realpath($for_directory).'/'.$file;
			}

			$this->registerAutoload();
		}

		/**
		 * loadByPattern
		 * Triggers all instances to load by an regex-pattern
		 *
		 * @param $pattern - string - the pattern that files must match that should be load
		 *
		 * @return array - the phpfqn => filename of the loaded classes
		 */
		public static function loadByPattern($pattern)
		{
			$loaded = [];
			$pattern = str_replace('\\.', '\\\\', $pattern);// replace all escaped dots with escaped backslashes -> HCFQN2PHPFQN for regex

			foreach (self::$instances as $instance) 
			{
				$result = $instance->load($pattern);

				if (is_array($result))
				{
					$loaded = array_merge($loaded, $result);
				}
			}

			return $loaded;
		}		

		/**
		 * registerAutoload
		 * This registers the spl_autoload function
		 *
		 * @return void
		 */
		protected function registerAutoload()
		{
			self::$instances[] = $this;

			return spl_autoload_register([$this, 'load']);
		}

		/**
		 * load
		 * The spl_autoload function which gets triggered if a class is used but does not exist
		 *
		 * @param $class_name - string - the name of the class which doesn't exist (wildcards possible, multiple matches will load multiple classes)
		 *
		 * @return boolean - true, if loading succeeded, false if loading failed
		 */
		protected function load($class_name)
		{
			$found_files = [];

			if (substr($class_name, 0, 1) == '/')
			{
				$keys = array_keys($this->classes);

				foreach ($keys as $fqn)
				{
					if (preg_match($class_name, $fqn) > 0)
					{
						$found_files[$fqn] = $this->classes[$fqn];
					}
				}
			}
			else if (isset($this->classes[$class_name]))
			{
				$found_files[$class_name] = $this->classes[$class_name];
			}

			if (!count($found_files))
			{
				// let the next autoloader try its luck

				return false;
			}

			foreach ($found_files as $file) 
			{
				if(!file_exists($file))
				{
					$e = new \FileNotFoundException('Class "'.$class_name.'" is mapped to file "'.$file.'" which does not exist.');

					InternalLogger::log()->error($e);

					throw $e;
				}

				require_once $file;
			}

			//InternalLogger::log()->info(__CLASS__.' class "'.$class_name.'" was mapped to "'.$file.'" and loaded successfully');

			return $found_files;
		}

		public function getDirectory()
		{
			return $this->directory;
		}

		public static function getInstances()
		{
			return self::$instances;
		}
	}
}
?>

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
		private $classes = [];

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
		 * registerAutoload
		 * This registers the spl_autoload function
		 *
		 * @return void
		 */
		protected function registerAutoload()
		{
			return spl_autoload_register([$this, 'load']);
		}

		/**
		 * load
		 * The spl_autoload function which gets triggered if a class is used but does not exist
		 *
		 * @param $class_name - string - the name of the class which doesn't exist
		 *
		 * @return boolean - true, if loading succeeded, false if loading failed
		 */
		protected function load($class_name)
		{
			if(!isset($this->classes[$class_name]))
			{
				// let the next autoloader try its luck

				return false;
			}

			$file = $this->classes[$class_name];

			if(!file_exists($file))
			{
				$e = new \FileNotFoundException('Class "'.$class_name.'" is mapped to file "'.$file.'" which does not exist.');

				InternalLogger::log()->error($e);

				throw $e;
			}

			require_once $file;

			//InternalLogger::log()->info(__CLASS__.' class "'.$class_name.'" was mapped to "'.$file.'" and loaded successfully');

			return true;
		}
	}
}
?>

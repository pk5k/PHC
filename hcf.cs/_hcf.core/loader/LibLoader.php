<?php
namespace hcf\core\loader
{
	use \hcf\core\log\Internal as InternalLogger;

	/**
	 * LibLoader
	 * Loads all *.php files inside the lib-directories
	 *
	 * @category Autoloader
	 * @package rme.loader
	 * @author Philipp Kopf
	 * @see http://php.net/manual/de/function.spl-autoload-register.php
	 */
	class LibLoader extends AutoLoader
	{
		private static $shared_files = null;
		private $for_directory = __DIR__;

		/**
		 * __construct
		 * Sets up an instance and registers the given directory for autoloading
		 *
		 * @param $shared_directory - string - the path of the shared directory
		 *
		 * @throws RuntimeException
		 * @return void
		 */
		public function __construct($shared_directory)
		{
			//InternalLogger::log()->info(__CLASS__.' initialising shared-directory "'.$shared_directory.'"');


			$this->for_directory = realpath($shared_directory);
			
			if(!is_dir($shared_directory))
			{
				throw new \DirectoryNotFoundException('Library directory "'.$this->for_directory.'" is not a directory or does not exist.');
			}
			
			$this->registerAutoload();
		}


		/**
		 * loadLibFiles
		 * Loads the *.php files inside the shared directory
		 *
		 * @param $shared_directory - string - the path of the shared directory
		 *
		 * @throws RuntimeException
		 * @return void
		 */
		private function loadLibFiles()
 		{
			if(!isset(self::$shared_files))
			{
				self::$shared_files = \hcf\core\Utils::getFilesByExtension('php', $this->for_directory);

				InternalLogger::log()->info(__CLASS__.' loading lib class-files in "'.$this->for_directory.'"...');

				foreach(self::$shared_files as $file)
				{
					InternalLogger::log()->info(__CLASS__.' - ' . $file);
					require_once $file;
				}

				InternalLogger::log()->info(__CLASS__.' loading lib class-files done - load '.count(self::$shared_files).' files.');
			}
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
			InternalLogger::log()->info(__CLASS__.' triggered for class "'.$class_name.'"...');

			// ... load the files inside the shared-directory
			$this->loadLibFiles();

			// ... and check, if the class exists now...
			if(class_exists($class_name))
			{
				//InternalLogger::log()->info(__CLASS__.' found '.$class_name.' inside shared-directory.');
				return true;
			}

			//InternalLogger::log()->info(__CLASS__.' '.$class_name.' does not exist inside shared-directory.');
			return false;
		}
	}
}
?>

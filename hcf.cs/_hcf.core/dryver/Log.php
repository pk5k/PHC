<?php
namespace hcf\core\dryver
{
	trait Log
	{
		private static $ROOT_LOGGER_KEY = 'hcf.core.log.Internal';// default logger-name
		private static $logger = [];

		public static function log($name = null)
		{
			if(!isset($name))
			{
				$name = self::$ROOT_LOGGER_KEY;
			}

			if(!isset(self::$logger[$name]))
			{
				self::loadLogger($name);
			}

			return self::$logger[$name];
		}

		private static function logConfigurator($data)
		{
			if ('<?php' == substr($data, 0, 5))
			{
				return new \LoggerConfigurationAdapterPHP();
			}
			else if ('<' == substr($data, 0, 1))
			{
				return new \LoggerConfigurationAdapterXML();
			}
			else 
			{
				return new \LoggerConfigurationAdapterINI();
			}
		}

		private static function loadLogger($name)
		{
			$attachment = self::getLogAttachment();
			$attachment = ltrim($attachment);
			$lc = self::logConfigurator($attachment);
			$config = $lc->convert($attachment, true);// last argument tells the ConfigAdapter to use the first arg NOT as file

			\Logger::configure($config);
			
			if($name == self::$ROOT_LOGGER_KEY)
			{
				self::$logger[self::$ROOT_LOGGER_KEY] = \Logger::getRootLogger();
			}
			else
			{
				self::$logger[$name] = \Logger::getLogger($name);
			}
		}
	}
}
?>

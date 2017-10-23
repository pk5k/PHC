<?php
namespace hcf\core\dryver
{
	trait Config
	{
		private static $config = null;

		protected abstract static function loadConfig();

		public static function config()
		{
			if(!isset(self::$config))
			{
				self::loadConfig();
			}

			return self::$config;
		}
	}
}
?>

<?php
namespace hcf\core\dryver\Client
{
	trait Css
	{
		private static $parser = null;

		public abstract static function style($as_array = false);

		protected static function makeStylesheetArray()
		{
			if (!isset(self::$parser))
			{
				self::$parser = new \CSSParser();
			}

			$index = self::$parser->ParseCSS(self::style(false));
			return self::$parser->GetCSSArray($index);
		}
	}
}
?>

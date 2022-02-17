<?php
namespace hcf\core\dryver\View
{
	trait Css
	{
		private static $parser = null;

		public static function style($as_array = false)
		{
			if ($as_array)
			{
				return [];
			}
			
			return '';
		}

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

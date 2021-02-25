<?php
namespace hcf\core\dryver\Template
{
	trait Xml
	{
		protected static function _cleanAttrs($in, $to_clean)
		{
			if (count($to_clean) == 0)
			{
				return $in;
			}

			foreach ($to_clean as $attr) 
			{
				$in = str_replace($attr.'=?""', '', $in);// this removes empty attributes completely
			}

			return str_replace('=?"', '="', $in);// optional attributes that still exist here weren't empty and must changed back to a valid attribute expression
		}
	}
}
?>

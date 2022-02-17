<?php
namespace hcf\core\dryver
{
	require_once __DIR__.'/View.xml.php';
	require_once __DIR__.'/View.html.php';
	require_once __DIR__.'/View.css.php';

	trait View
	{
		// TODO: Proper Trait resolving in case of View.xml and View.html usage - until then, the common methods are stored here:
		protected static function _postProcess($in, $clean_attributes, $clean_tags)
		{
			$in = self::_cleanAttrs($in, $clean_attributes);
			$in = self::_cleanTags($in, $clean_tags);

			return $in;
		}

		protected static function _cleanAttrs($in, $to_clean)
		{
			if (count($to_clean) == 0)
			{
				return $in;
			}

			$remove_list = [];
			$match = [];
			$restore = [];

			foreach ($to_clean as $attr) 
			{
				$remove_list[] = ' '.$attr.'?=""';

				$match[] = ' '.$attr.'?="';
				$restore[] = ' '.$attr.'="';
			}

			$in = str_replace($remove_list, '', $in);// this removes the empty attributes completely
			$in = str_replace($match, $restore, $in);// optional attributes that still exist here weren't empty and must changed back to a valid attribute expression

			return $in;
		}

		protected static function _cleanTags($in, $to_clean)
		{
			if (count($to_clean) == 0)
			{
				return $in;
			}

			$match = [];
			$restore = [];
			$remove_pattern = '/<([\w\s\-_\.]+)\?.*><\/\1\?>/i';// we do not know the attributes of each tag so we have to use a regex here

			foreach ($to_clean as $tag_name) 
			{
				$match[] = '<'.$tag_name.'?';
				$restore[] = '<'.$tag_name;

				$match[] = '</'.$tag_name.'?>';
				$restore[] = '</'.$tag_name.'>';
			}

			$in = preg_replace($remove_pattern, '', $in); // this replaces all given optional tags that are empty
			$in = str_replace($match, $restore, $in);// repair all remaining optional tags

			return $in;
		}

		public function toString()
		{
			return $this->__toString();
		}

		public function __toString()
		{
			return '';
		}
	}
}
?>

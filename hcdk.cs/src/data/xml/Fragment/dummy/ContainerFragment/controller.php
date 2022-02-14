<?php
use \hcdk\data\ph\Parser as PlaceholderParser;
use \hcdk\data\xml\Parser as XMLParser;

/**
 * Container
 * the content of this fragment will be displayed at the position where it is in the XML-Tree
 * NOTICE: This fragment fixes the problem of appending plain-text mixed between tags as far as
 * this Container does not contain other children-fragments (in this case, text will be omitted)
 *
 * @category XML Fragment
 * @package rmb.xml.fragment.dummy
 * @author Philipp Kopf
 */
trait Controller
{
	public static function build($root, $file_scope)
	{
		$output = '';

		if(count($root->children())>0)
		{
			foreach($root->children() as $child)
			{
				$output .= XMLParser::renderFragment($child, $file_scope);
			}
		}
		else
		{
			$output = parent::FRGMNT_OUTPUT_START().PlaceholderParser::parse((string)$root).parent::FRGMNT_OUTPUT_END();
		}

		return $output;
	}
}
?>

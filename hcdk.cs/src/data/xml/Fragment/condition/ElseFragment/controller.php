<?php
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\xml\Fragment\condition\IfFragment as F_If;
use \hcdk\data\ph\Parser as PlaceholderParser;
/**
 * (F_)Else
 * Else-Fragment for \hcf\core.xml.Parser
 * Will be converted into a PHP else-(if-)condition block
 *
 * @category XML Fragment
 * @package rmb.xml.fragment
 * @author Philipp Kopf
 */
trait Controller
{
	public static function build($root, $file_scope)
	{
		$root_name = $root->getName();

		$value = (isset($root['value'])) ? (string)$root['value'] : null;
		$output = 'else ';

		if(isset($value))
		{
			// conditions for else-fragments only can be set, if a value is given
			$output .= F_If::build($root, $file_scope);
		}
		else
		{
			$output .= '{ ' . parent::buildBody($root, $file_scope).' }';
		}

		return $output;
	}
}
?>

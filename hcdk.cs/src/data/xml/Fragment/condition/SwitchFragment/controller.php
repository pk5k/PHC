<?php
use \hcdk\data\ph\Parser as PlaceholderParser;
use \hcdk\data\xml\Parser as XMLParser;

/**
 * (F_)Switch
 * Switch-Fragment for \hcf\core.xml.Parser
 * Will be converted into a PHP switch-block
 * NOTICE: On the first child-level inside a Switch-Fragment ONLY Case-Fragments ARE ALLOWED!
 *
 * @category XML Fragment
 * @package hcdk.xml.fragment
 * @author Philipp Kopf
 */
trait Controller
{
	public static function build($root, $file_scope)
	{
		$root_name = $root->getName();

		$value  = (isset($root['value'])) ? (string)$root['value'] : null;
		$value 	= PlaceholderParser::parse($value, false);

		if(is_null($value))
		{
			throw new \AttributeNotFoundException('Non-optional attribute "value" is not set');
		}

		$output = 'switch('.$value.') {';

		if(count($root->children())>0)
		{
			foreach($root->children() as $child)
			{
				$output .= XMLParser::renderFragment($child, $file_scope);
			}
		}
		else
		{
			throw new \XMLParseException('Fragment cannot be empty');
		}

		$output .= '}';

		return $output;
	}
}
?>

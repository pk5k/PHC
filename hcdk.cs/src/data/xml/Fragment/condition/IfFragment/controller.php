<?php
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\ph\Parser as PlaceholderParser;

/**
 * (F_)If
 * If-Fragment for \hcf\core.xml.Parser
 * Will be converted into a PHP if-condition block
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

		$value = (isset($root['value'])) ? (string)$root['value'] : null;
		$condition = self::getConditionAttribute($root);

		if(is_null($value))
		{
			throw new \XMLParseException('Value cannot be empty');
		}

		$value = PlaceholderParser::parse($value, false);

		$output = 'if('.$value.' '.$condition[0];

		if(!is_numeric($condition[1]))
		{
			$output .= ' "'.$condition[1].'"';
		}
		else
		{
			$output .= ' '.$condition[1];
		}

		$output .= ') { '.self::buildBody($root, $file_scope).' }';

		return $output;
	}
}
?>

<?php
use \hcdk\data\xml\Parser as XMLParser;

/**
 * (F_)Case
 * Case-Fragment for rmc.xml.Parser
 * Will be converted into a PHP Case-block
 * NOTICE: You have to add this fragment on the first child-level of the Switch-Fragment
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

		$value  	= (isset($root['value'])) ? (string)$root['value'] : null;
		$default 	= false; //if value attribute is not set, the case will be resolved to the "default" case

		if(is_null($value))
		{
			$default = true;
		}
		else if(!is_numeric($value) && is_string($value))
		{
			// Add quotes for string-values
			$value = '\''.$value.'\'';
		}
		else if(!is_numeric($value))
		{
			// If value isn't a string or numeric, it can't be a valid case-value
			throw new \XMLParseException('Attribute "value" must be a string or numeric type');
		}

		$output = null;

		if($default)
		{
			$output = 'default: ';
		}
		else
		{
			$output = 'case '.$value.': ';
		}

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

		$output .= 'break;';

		return $output;
	}
}
?>

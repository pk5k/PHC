<?php
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\ph\Parser as PlaceholderParser;

	/**
	 * Fragment
	 * Abstract parent class for If/Else Fragments
	 *
	 * @category XML Fragment
	 * @package hcdk.xml.fragment
	 * @author Philipp Kopf
	 */
trait Controller
{
	protected static $possible_conditions = ['is' => '==', 'is-not' => '!=', 'gt' => '>', 'lt' => '<', 'gte' => '>=', 'lte' => '<='];// key = attribute name to use this condition, value = the condition in php

  public static function getConditionAttribute($root)
  {
    // return: [0 => 'attr_php_representation', 1 => 'attr_value']
    foreach($root->attributes() as $attr_name => $value)
    {
      if(isset(self::$possible_conditions[$attr_name]))
      {
        return [self::$possible_conditions[$attr_name], PlaceholderParser::parse($value, true)];
      }
    }

    throw new \XMLParseException('No condition set');
  }

  public static function buildBody($root, $file_scope)
  {
    $body = '';

    if(count($root->children())>0)
    {
      foreach($root->children() as $child)
      {
        $body .= XMLParser::renderFragment($child, $file_scope);
      }
    }
    else
    {
      throw new \XMLParseException('Fragment cannot be empty');
    }

    return $body;
  }
}
?>

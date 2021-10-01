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
	protected static $possible_conditions = ['is-not-set' => '!isset(#)', 'is-set' => 'isset(#)' , 'isset' => 'isset(#)', 'is' => '==', 'is-not' => '!=', 'gt' => '>', 'lt' => '<', 'gte' => '>=', 'lte' => '<='];// key = attribute name to use this condition, value = the condition in php

  public static function getConditionAttribute($root)
  {
    // return: [0 => 'attr_php_representation', 1 => 'attr_value']
    foreach($root->attributes() as $attr_name => $value)
    {
      if(isset(self::$possible_conditions[$attr_name]))
      {
        $between_double_quotes = true;

        if (strpos(self::$possible_conditions[$attr_name], '#') !== false)
        {
          $between_double_quotes = false;// no quotes for direct function pass
        }
        
        return [self::$possible_conditions[$attr_name], PlaceholderParser::parse($value, $between_double_quotes)];
      } 
    }

    throw new \XMLParseException(self::FQN.' - No condition set');
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
      throw new \XMLParseException(self::FQN.' - Fragment cannot be empty. In '.$file_scope.' for element "'.str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()).'"');
    }

    return $body;
  }
}
?>

<?php
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\ph\Parser as PlaceholderParser;
use \hcf\core\Utils as Utils;

/**
 *  Render
 * Render-Fragment for \hcf\core.xml.Parser
 * Creates an instance of given class and renders it into the template after calling methods of the newly created instance.
 *
 * @category XML Fragment
 * @package hcdk.xml.fragment
 * @author Philipp Kopf
 */
trait Controller
{
	private static $active_pipeline = null;
	private static $active_pipeline_target = null;
	private static $instance_counter = 0;

	public static function resetInstanceCounter()
	{
		self::$instance_counter = 0;
	}

	private static function nextInstanceCount()
	{
		$current = self::$instance_counter;
		self::$instance_counter += 1;

		return $current;
	}

	public static function getActivePipeline()
	{
		return self::$active_pipeline;
	}

	protected static function setActivePipeline($to)
	{
		self::$active_pipeline = $to;
	}
	
	public static function setActivePipelineTarget($to)
	{
		self::$active_pipeline_target = $to;
	}
	
	public static function getActivePipelineTarget()
	{
		return self::$active_pipeline_target;
	}

	public static function build($root, $file_scope)
	{
		$root_name = $root->getName();
	
		if (!is_null(self::getActivePipeline()))
		{
			throw new \Exception(self::FQN.' - render.pipeline cannot be nested into another render.pipeline element. In '.$file_scope.' for element "'.str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name).'"');
		}
	
		$target = null;

		if (!isset($root['target']))
		{
			throw new \AttributeNotFoundException(self::FQN.' - Non-optional attribute "target" is not set. In '.$file_scope.' for element "'.str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name).'"');
		}

		$template = null;

		if (isset($root['template']) && count($root->children()) > 0)
		{
			throw new \AttributeNotFoundException(self::FQN.' - render.pipeline cannot have children if template-method is given for element "'.str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name).'"');
		}
		else if (isset($root['template']))
		{
			$template = PlaceholderParser::parse(trim((string)$root['template']), false);
		}

		$instance_token = '$instance_'.self::nextInstanceCount();
		$target_raw = trim((string)$root['target']);
		$target = PlaceholderParser::parse($target_raw, false);
		$is_placeholder_target = ($target_raw != $target);
		$constructor_args = self::collectArgumentsFromNode($root);
		$fqn = $target;
		
		if (!$is_placeholder_target)
		{
			$fqn = Utils::HCFQN2PHPFQN($target, true);
		}

		self::setActivePipeline($instance_token);
		self::setActivePipelineTarget($fqn);
		
		$output = '';

		if (is_null($template))
		{
			$output = $instance_token.' = new '.$fqn.'('.implode(',',$constructor_args).');';
			$fast_instructions = self::collectFastInstructionsFromNode($root);

			foreach ($fast_instructions as $method => $_0)
			{
				$fast_instruction = $root->addChild('render.instruction');
				$fast_instruction['method'] = (string)$method;
				$fast_instruction['_0'] = (string)$_0;
			}

			foreach ($root->children() as $instruction) 
			{
				$output .= XMLParser::renderFragment($instruction, $file_scope);
			}

			$output .= parent::FRGMNT_OUTPUT_START().$instance_token.parent::FRGMNT_OUTPUT_END(); // implicit toString call
		}
		else
		{
			if ($is_placeholder_target)
			{
				$output .= $instance_token.' = '.$fqn.'->'.$template.'('.implode(',',$constructor_args).');';
			}
			else
			{
				$output .= $instance_token.' = '.$fqn.'::'.$template.'('.implode(',',$constructor_args).');';
			}

			$output .= parent::FRGMNT_OUTPUT_START().$instance_token.parent::FRGMNT_OUTPUT_END();
		}
		
		self::setActivePipeline(null);
		self::setActivePipelineTarget(null);

		return $output;
	}

	private static function collectFastInstructionsFromNode($node)
	{
		$fi = [];

		foreach ($node->attributes() as $name => $value)
		{
			// all Attributes of render.pipline (except target, template and everything beginning with an underscore _ ) will be converted to an <render.instruction method="$name" _0="$value"/> child of this pipeline
			if (substr($name, 0, 1) == '_' || $name == 'template' || $name == 'target')
			{
				continue;
			}

			$fi[$name] = $value;
		}

		return $fi;
	}

	public static function collectArgumentsFromNode($node)
	{
		$args = [];

		foreach ($node->attributes() as $name => $value) 
		{
			// _0="val" _1="val" _2="val" are the arguments that will be passed in their numeric order (the _ is removed before sorting)
			if (substr($name, 0, 1) == '_')
			{
				$i = (int)substr($name, 1);
				$quotes_required = true;
				$v = $value;

				if (substr($v, 0, 2) == '{{' && substr($v, -2, 2) == '}}' && strpos($v, ':') !== false)
				{
					// if the given attribute is a placeholder only, allow passing the resolved placeholder as raw-value instead of part as a string between double quotes
					// this allows return value types like array or object be passed from a placeholder to this factory without casting the return value to a string before (which wouldnt work)
					$quotes_required = false;
				}

				$args[$i] = PlaceholderParser::parse($v, $quotes_required);

				if ($quotes_required)
				{
					$args[$i] = '"'.$args[$i].'"';
				}
			}
		}

		ksort($args, SORT_NUMERIC);
		return $args;
	}
}
?>

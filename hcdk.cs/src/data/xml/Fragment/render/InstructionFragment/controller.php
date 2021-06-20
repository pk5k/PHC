<?php
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\ph\Parser as PlaceholderParser;
use \hcf\core\Utils as Utils;
use \hcdk\data\xml\Fragment\render\PipelineFragment;
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
	public static function build($root, $file_scope)
	{
		if (is_null(PipelineFragment::getActivePipeline()))
		{
			throw new \Exception(self::FQN.' - no render.pipeline was started for this instruction. In '.$file_scope.' for element "'.str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name).'"');
		}

		if (!isset($root['method']))
		{
			throw new \AttributeNotFoundException(self::FQN.' - missing attribute "method" for element instruction In '.$file_scope);
		}

		$instance_token = PipelineFragment::getActivePipeline();
		$fqn = PipelineFragment::getActivePipelineTarget();

		$output = '';
		$instr_meth = trim($root['method']);
		// allow static methods to be called. That doesn't make much sense in case of rendering an instance but maybe neccessary anyways
		$static = (isset($root['static']) && (string)$root['static'] == 'true');
		$instr_args = PipelineFragment::collectArgumentsFromNode($root);

		if ($static)
		{
			$output .= $fqn.'::'.$instr_meth.'('.implode(',', $instr_args).');';
		}
		else 
		{
			$output .= $instance_token.'->'.$instr_meth.'('.implode(',', $instr_args).');';
		}

		return $output;
	}
}
?>
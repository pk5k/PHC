<?php #HYPERCELL hcdk.data.xml.Fragment.render.InstructionFragment - BUILD 22.01.24#13
namespace hcdk\data\xml\Fragment\render;
class InstructionFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, InstructionFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.render.InstructionFragment';
    const NAME = 'InstructionFragment';
    public function __construct() {
        if (method_exists($this, 'hcdkdataxmlFragmentrenderInstructionFragment_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataxmlFragmentrenderInstructionFragment_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\render\InstructionFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
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
    trait Controller {
        public static function build($root, $file_scope) {
            if (is_null(PipelineFragment::getActivePipeline())) {
                throw new \Exception(self::FQN . ' - no render.pipeline was started for this instruction. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name) . '"');
            }
            if (!isset($root['method'])) {
                throw new \AttributeNotFoundException(self::FQN . ' - missing attribute "method" for element instruction In ' . $file_scope);
            }
            $instance_token = PipelineFragment::getActivePipeline();
            $fqn = PipelineFragment::getActivePipelineTarget();
            $output = '';
            $instr_meth = trim($root['method']);
            // allow static methods to be called. That doesn't make much sense in case of rendering an instance but maybe neccessary anyways
            $static = (isset($root['static']) && (string)$root['static'] == 'true');
            $instr_args = PipelineFragment::collectArgumentsFromNode($root);
            if ($static) {
                $output.= $fqn . '::' . $instr_meth . '(' . implode(',', $instr_args) . ');';
            } else {
                $output.= $instance_token . '->' . $instr_meth . '(' . implode(',', $instr_args) . ');';
            }
            return $output;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.data.xml.Fragment.render.PipelineFragment - BUILD 21.02.26#9
namespace hcdk\data\xml\Fragment\render;
class PipelineFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, PipelineFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.render.PipelineFragment';
    const NAME = 'PipelineFragment';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\render\PipelineFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
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
    trait Controller {
        private static $active_pipeline = null;
        private static $active_pipeline_target = null;
        public static function getActivePipeline() {
            return self::$active_pipeline;
        }
        protected static function setActivePipeline($to) {
            self::$active_pipeline = $to;
        }
        public static function setActivePipelineTarget($to) {
            self::$active_pipeline_target = $to;
        }
        public static function getActivePipelineTarget() {
            return self::$active_pipeline_target;
        }
        public static function build($root, $file_scope) {
            $root_name = $root->getName();
            if (!is_null(self::getActivePipeline())) {
                throw new \Exception(self::FQN . ' - render.pipeline cannot be nested into another render.pipeline element. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name) . '"');
            }
            $target = null;
            if (!isset($root['target'])) {
                throw new \AttributeNotFoundException(self::FQN . ' - Non-optional attribute "target" is not set. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name) . '"');
            }
            $instance_token = uniqid('$instance_');
            $target = PlaceholderParser::parse(trim((string)$root['target']), false);
            $constructor_args = self::collectArgumentsFromNode($root);
            $fqn = Utils::HCFQN2PHPFQN($target, true);
            self::setActivePipeline($instance_token);
            self::setActivePipelineTarget($fqn);
            $output = $instance_token . ' = new ' . $fqn . '(' . implode(',', $constructor_args) . ');';
            foreach ($root->children() as $instruction) {
                $output.= XMLParser::renderFragment($instruction, $file_scope);
            }
            $output.= parent::FRGMNT_OUTPUT_START() . $instance_token . parent::FRGMNT_OUTPUT_END(); // implicit toString call
            self::setActivePipeline(null);
            self::setActivePipelineTarget(null);
            return $output;
        }
        public static function collectArgumentsFromNode($node) {
            $args = [];
            foreach ($node->attributes() as $name => $value) {
                // _0="val" _1="val" _2="val" are the arguments that will be passed in their numeric order (the _ is removed before sorting)
                if (substr($name, 0, 1) == '_') {
                    $i = (int)substr($name, 1);
                    $quotes_required = true;
                    $v = $value;
                    if (substr($v, 0, 2) == '{{' && substr($v, -2, 2) == '}}' && strpos($v, ':') !== false) {
                        // if the given attribute is a placeholder only, allow passing the resolved placeholder as raw-value instead of part as a string between double quotes
                        // this allows return value types like array or object be passed from a placeholder to this factory without casting the return value to a string before (which wouldnt work)
                        $quotes_required = false;
                    }
                    $args[$i] = PlaceholderParser::parse($v, $quotes_required);
                    if ($quotes_required) {
                        $args[$i] = '"' . $args[$i] . '"';
                    }
                }
            }
            ksort($args, SORT_NUMERIC);
            return $args;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



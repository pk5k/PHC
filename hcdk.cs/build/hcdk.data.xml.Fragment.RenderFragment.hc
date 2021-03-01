<?php #HYPERCELL hcdk.data.xml.Fragment.RenderFragment - BUILD 21.02.26#6
namespace hcdk\data\xml\Fragment;
class RenderFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, RenderFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.RenderFragment';
    const NAME = 'RenderFragment';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\RenderFragment\__EO__;
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
        public static function build($root, $file_scope) {
            $root_name = $root->getName();
            $target = null;
            if (!isset($root['target'])) {
                throw new \AttributeNotFoundException(self::FQN . ' - Non-optional attribute "target" is not set. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name) . '"');
            }
            $instance_token = uniqid('$instance_');
            $target = PlaceholderParser::parse(trim((string)$root['target']), false);
            $constructor_args = self::collectArgumentsFromNode($root);
            $fqn = Utils::HCFQN2PHPFQN($target, true);
            $output = $instance_token . ' = new ' . $fqn . '(' . implode(',', $constructor_args) . ');';
            foreach ($root->children() as $instruction) {
                if ($instruction->getName() != 'instruction') {
                    // allow additional elements next to the instruction set (e.g. "if" could be useful)
                    $output.= XMLParser::renderFragment($instruction, $file_scope);
                    continue;
                }
                // process instruction-fragments here since we must know the instance-id
                if (!isset($instruction['method'])) {
                    throw new \AttributeNotFoundException(self::FQN . ' - missing attribute "method" for element instruction In ' . $file_scope);
                }
                $instr_meth = trim($instruction['method']);
                // allow static methods be called but that doesn't make much sense in case of rendering an instance (but maybe neccessary anyways)
                $static = (isset($instruction['static']) && (string)$instruction['static'] == 'true');
                $instr_args = self::collectArgumentsFromNode($instruction);
                if ($static) {
                    $output.= $fqn . '::' . $instr_meth . '(' . implode(',', $instr_args) . ');';
                } else {
                    $output.= $instance_token . '->' . $instr_meth . '(' . implode(',', $instr_args) . ');';
                }
            }
            $output.= parent::FRGMNT_OUTPUT_START() . $instance_token . parent::FRGMNT_OUTPUT_END(); // implicit toString call
            return $output;
        }
        private static function collectArgumentsFromNode($node) {
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



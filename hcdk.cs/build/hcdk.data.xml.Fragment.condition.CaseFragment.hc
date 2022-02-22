<?php #HYPERCELL hcdk.data.xml.Fragment.condition.CaseFragment - BUILD 22.02.18#80
namespace hcdk\data\xml\Fragment\condition;
class CaseFragment extends \hcdk\data\xml\Fragment\condition {
    use \hcf\core\dryver\Base, CaseFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.condition.CaseFragment';
    const NAME = 'CaseFragment';
    public function __construct() {
        if (method_exists($this, 'hcdkdataxmlFragmentconditionCaseFragment_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkdataxmlFragmentconditionCaseFragment_onConstruct_Controller'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\condition\CaseFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
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
    trait Controller {
        public static function build($root, $file_scope) {
            $root_name = $root->getName();
            $value = (isset($root['value'])) ? (string)$root['value'] : null;
            $default = false; //if value attribute is not set, the case will be resolved to the "default" case
            if (is_null($value)) {
                $default = true;
            } else if (!is_numeric($value) && is_string($value)) {
                // Add quotes for string-values
                $value = '\'' . $value . '\'';
            } else if (!is_numeric($value)) {
                // If value isn't a string or numeric, it can't be a valid case-value
                throw new \XMLParseException(self::FQN . ' - Attribute "value" must be a string or numeric type. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            $output = null;
            if ($default) {
                $output = 'default: ';
            } else {
                $output = 'case ' . $value . ': ';
            }
            if (count($root->children()) > 0) {
                foreach ($root->children() as $child) {
                    $output.= XMLParser::renderFragment($child, $file_scope);
                }
            } else {
                throw new \XMLParseException(self::FQN . ' - Fragment cannot be empty. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            $output.= 'break;';
            return $output;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcdk.data.xml.Fragment.condition.SwitchFragment - BUILD 18.06.15#59
namespace hcdk\data\xml\Fragment\condition;
class SwitchFragment extends \hcdk\data\xml\Fragment\condition {
    use \hcf\core\dryver\Base, SwitchFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.condition.SwitchFragment';
    const NAME = 'SwitchFragment';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\condition\SwitchFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\data\ph\Parser as PlaceholderParser;
    use \hcdk\data\xml\Parser as XMLParser;
    /**
     * (F_)Switch
     * Switch-Fragment for \hcf\core.xml.Parser
     * Will be converted into a PHP switch-block
     * NOTICE: On the first child-level inside a Switch-Fragment ONLY Case-Fragments ARE ALLOWED!
     *
     * @category XML Fragment
     * @package hcdk.xml.fragment
     * @author Philipp Kopf
     */
    trait Controller {
        public static function build($root, $file_scope) {
            $root_name = $root->getName();
            $value = (isset($root['value'])) ? (string)$root['value'] : null;
            $value = PlaceholderParser::parse($value, false);
            if (is_null($value)) {
                throw new \AttributeNotFoundException(self::FQN . ' - Non-optional attribute "value" is not set. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            $output = 'switch(' . $value . ') {';
            if (count($root->children()) > 0) {
                foreach ($root->children() as $child) {
                    $output.= XMLParser::renderFragment($child, $file_scope);
                }
            } else {
                throw new \XMLParseException(self::FQN . ' - Fragment cannot be empty. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            $output.= '}';
            return $output;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.data.xml.Fragment.condition.IfFragment - BUILD 22.01.24#74
namespace hcdk\data\xml\Fragment\condition;
class IfFragment extends \hcdk\data\xml\Fragment\condition {
    use \hcf\core\dryver\Base, IfFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.condition.IfFragment';
    const NAME = 'IfFragment';
    public function __construct() {
        if (method_exists($this, 'hcdkdataxmlFragmentconditionIfFragment_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataxmlFragmentconditionIfFragment_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\condition\IfFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\data\xml\Parser as XMLParser;
    use \hcdk\data\ph\Parser as PlaceholderParser;
    /**
     * (F_)If
     * If-Fragment for \hcf\core.xml.Parser
     * Will be converted into a PHP if-condition block
     *
     * @category XML Fragment
     * @package hcdk.xml.fragment
     * @author Philipp Kopf
     */
    trait Controller {
        public static function build($root, $file_scope) {
            $root_name = $root->getName();
            $value = (isset($root['value'])) ? (string)$root['value'] : null;
            $condition = self::getConditionAttribute($root);
            if (strpos($condition[0], '#') !== false) {
                if (!is_null($value)) {
                    throw new \XMLParseException(self::FQN . ' - attribute "value" cannot be set on ' . $condition[0] . ' condition. The attribute contains already the value that should be checked. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
                }
                $output = 'if(' . str_replace('#', $condition[1], $condition[0]);
            } else {
                if (is_null($value)) {
                    throw new \XMLParseException(self::FQN . ' - Value cannot be empty. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
                }
                $value = PlaceholderParser::parse($value, false);
                $output = 'if(' . $value . ' ' . $condition[0];
                if (!is_numeric($condition[1])) {
                    $output.= ' "' . $condition[1] . '"';
                } else {
                    $output.= ' ' . $condition[1];
                }
            }
            $output.= ') { ' . self::buildBody($root, $file_scope) . ' }';
            return $output;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



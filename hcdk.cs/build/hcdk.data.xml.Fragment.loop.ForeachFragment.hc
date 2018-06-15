<?php #HYPERCELL hcdk.data.xml.Fragment.loop.ForeachFragment - BUILD 18.06.15#59
namespace hcdk\data\xml\Fragment\loop;
class ForeachFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, ForeachFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.loop.ForeachFragment';
    const NAME = 'ForeachFragment';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
}
namespace hcdk\data\xml\Fragment\loop\ForeachFragment\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\ph\Parser as PlaceholderParser;
/**
 * (F_)ForEach
 * ForEach-Fragment for \hcf\core.xml.Parser
 * Will be converted into a for-each loop for a given raw-merge array-property
 *
 * @category XML Fragment
 * @package hcdk.xml.fragment
 * @author Philipp Kopf
 */
trait Controller {
    public static function build($root, $file_scope) {
        $root_name = $root->getName();
        $var = (isset($root['var'])) ? (string)$root['var'] : null;
        $as_key = (isset($root['key'])) ? (string)$root['key'] : null;
        $as_val = (isset($root['value'])) ? (string)$root['value'] : null;
        $call = (isset($root['call'])) ? (string)$root['call'] : null;
        if (is_null($var)) {
            throw new \AttributeNotFoundException('Non-optional attribute "var" is not set');
        }
        $var = PlaceholderParser::parse($var, false);
        if (is_null($as_val)) {
            throw new \AttributeNotFoundException('Non-optional attribute "value" is not set');
        }
        $output = 'foreach(' . $var . ' as ';
        if (!is_null($as_key)) {
            $output.= '$' . $as_key . ' => $' . $as_val;
        } else {
            $output.= '$' . $as_val;
        }
        $output.= ') {';
        if (!is_null($call)) {
            $output.= ' $__CLASS__::_call(\'' . $call . '\', $__CLASS__, $_this,';
            if (!is_null($as_key)) {
                $output.= '$' . $as_key . ',';
            }
            $output.= '$' . $as_val . ');';
        }
        if (count($root->children()) > 0) {
            foreach ($root->children() as $child) {
                $output.= XMLParser::renderFragment($child, $file_scope);
            }
        } else {
            $output.= parent::FRGMNT_OUTPUT_START() . PlaceholderParser::parse(((string)$root)) . parent::FRGMNT_OUTPUT_END();
        }
        $output.= '}';
        return $output;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



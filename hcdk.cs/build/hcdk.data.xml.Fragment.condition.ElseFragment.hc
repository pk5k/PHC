<?php #HYPERCELL hcdk.data.xml.Fragment.condition.ElseFragment - BUILD 18.02.22#56
namespace hcdk\data\xml\Fragment\condition;
class ElseFragment extends \hcdk\data\xml\Fragment\condition {
    use \hcf\core\dryver\Base, ElseFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.condition.ElseFragment';
    const NAME = 'ElseFragment';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
}
namespace hcdk\data\xml\Fragment\condition\ElseFragment\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\ph\Parser as PlaceholderParser;
/**
 * (F_)Else
 * Else-Fragment for \hcf\core.xml.Parser
 * Will be converted into a PHP else-(if-)condition block
 *
 * @category XML Fragment
 * @package rmb.xml.fragment
 * @author Philipp Kopf
 */
trait Controller {
    public static function build($root, $file_scope) {
        $root_name = $root->getName();
        $value = (isset($root['value'])) ? (string)$root['value'] : null;
        $output = 'else ';
        if (isset($value)) {
            // conditions for else-fragments only can be set, if a value is given
            $output.= F_If::build($root, $file_scope);
        } else {
            $output.= '{ ' . parent::buildBody($root, $file_scope) . ' }';
        }
        return $output;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



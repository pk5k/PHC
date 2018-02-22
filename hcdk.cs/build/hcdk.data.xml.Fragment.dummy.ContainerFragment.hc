<?php #HYPERCELL hcdk.data.xml.Fragment.dummy.ContainerFragment - BUILD 18.02.22#56
namespace hcdk\data\xml\Fragment\dummy;
class ContainerFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, ContainerFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.dummy.ContainerFragment';
    const NAME = 'ContainerFragment';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
}
namespace hcdk\data\xml\Fragment\dummy\ContainerFragment\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\data\ph\Parser as PlaceholderParser;
use \hcdk\data\xml\Parser as XMLParser;
/**
 * Container
 * the content of this fragment will be displayed at the position where it is in the XML-Tree
 * NOTICE: This fragment fixes the problem of appending plain-text mixed between tags as far as
 * this Container does not contain other children-fragments (in this case, text will be omitted)
 *
 * @category XML Fragment
 * @package rmb.xml.fragment.dummy
 * @author Philipp Kopf
 */
trait Controller {
    public static function build($root, $file_scope) {
        $output = '';
        if (count($root->children()) > 0) {
            foreach ($root->children() as $child) {
                $output.= XMLParser::renderFragment($child, $file_scope);
            }
        } else {
            $output = parent::FRGMNT_OUTPUT_START() . PlaceholderParser::parse((string)$root) . parent::FRGMNT_OUTPUT_END();
        }
        return $output;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



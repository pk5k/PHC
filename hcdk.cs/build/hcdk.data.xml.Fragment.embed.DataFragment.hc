<?php #HYPERCELL hcdk.data.xml.Fragment.embed.DataFragment - BUILD 18.02.22#58
namespace hcdk\data\xml\Fragment\embed;
class DataFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, DataFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.embed.DataFragment';
    const NAME = 'DataFragment';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
}
namespace hcdk\data\xml\Fragment\embed\DataFragment\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\data\xml\Parser as XMLParser;
use \hcdk\data\ph\Parser as PlaceholderParser;
use \hcf\core\Utils as Utils;
/**
 * Data
 * This fragment converts an associative array property into HTML5 'data-' attributes on runtime.
 *
 * @category XML Fragment
 * @package rmb.xml.fragment.embed
 * @author Philipp Kopf
 */
trait Controller {
    public static function build($root, $file_scope) {
        $root_name = $root->getName();
        $var = (isset($root['var'])) ? (string)$root['var'] : null;
        $as = (isset($root['as'])) ? (string)$root['as'] : 'div';
        if (is_null($var)) {
            throw new \AttributeNotFoundException('Non-optional attribute "var" is not set');
        }
        $var = PlaceholderParser::parse($var, false);
        $as = PlaceholderParser::parse($as);
        $as_key = '$_ak';
        $as_val = '$_av';
        $output = parent::FRGMNT_OUTPUT_START() . '<' . $as;
        foreach ($root->attributes() as $name => $value) {
            $c_name = strtolower($name);
            if ($c_name == 'as' || $c_name == 'var') {
                continue;
            }
            $output.= ' ' . $name . '=\"' . PlaceholderParser::parse($value) . '\"';
        }
        $output.= parent::FRGMNT_OUTPUT_END() . Utils::newLine();
        $output.= 'foreach(' . $var . ' as  ' . $as_key . ' => ' . $as_val . ') {';
        $output.= parent::FRGMNT_OUTPUT_START() . ' data-' . $as_key . '=\"' . $as_val . '\"' . parent::FRGMNT_OUTPUT_END();
        $output.= '}';
        if (XMLParser::isVoidTag($as)) {
            $output.= parent::FRGMNT_OUTPUT_START() . '/>' . parent::FRGMNT_OUTPUT_END();
            return $output;
        } else {
            $output.= parent::FRGMNT_OUTPUT_START() . '>' . parent::FRGMNT_OUTPUT_END();
        }
        if (count($root->children()) > 0) {
            foreach ($root->children() as $child) {
                $output.= XMLParser::renderFragment($child, $file_scope);
            }
        } else {
            $output.= parent::FRGMNT_OUTPUT_START() . PlaceholderParser::parse(((string)$root)) . parent::FRGMNT_OUTPUT_END();
        }
        $output.= parent::FRGMNT_OUTPUT_START() . '</' . $as . '>' . parent::FRGMNT_OUTPUT_END();
        return $output;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



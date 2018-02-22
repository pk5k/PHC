<?php #HYPERCELL hcdk.assembly.Constant - BUILD 18.02.22#184
namespace hcdk\assembly;
class Constant extends \hcdk\assembly {
    use \hcf\core\dryver\Base, Constant\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.Constant';
    const NAME = 'Constant';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
}
namespace hcdk\assembly\Constant\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\core\Utils as Utils;
use \hcdk\raw\Property as Property;
use \hcdk\raw\Constant as ConstantProperty;
trait Controller {
    public function getType() {
        return '';
    }
    public function getName() {
        return 'CONSTANT';
    }
    public function getConstructor() {
        return null;
    }
    public function getMethods() {
        return null;
    }
    public function getStaticMethods() {
        return null;
    }
    public function getProperties() {
        return null;
    }
    public function getStaticProperties() {
        $const_arr = $this->getConstants();
        $name_arr = array_keys($const_arr);
        $name_str = '[';
        foreach ($name_arr as $i => $value) {
            $name_str.= '\'' . $value . '\'';
            if (($i + 1) < count($name_arr)) {
                $name_str.= ',';
            }
        }
        $name_str.= ']';
        $c_list = new Property('_constant_list', ['private', 'static']);
        $c_list->setValue($name_str);
        $const_arr['_constant_list'] = $c_list;
        return $const_arr;
    }
    public function isAttachment() {
        return false;
    }
    public function isExecutable() {
        return false;
    }
    public function getClassModifiers() {
        return null;
    }
    public function getAliases() {
        return null;
    }
    public function getTraits() {
        return ['Constant' => '\\hcf\\core\\dryver\\Constant'];
    }
    private function getConstants() {
        $consts = [];
        $ri = $this->rawInput();
        $lines = explode("\n", $ri);
        foreach ($lines as $line) {
            $clean_line = trim(str_replace("\t", ' ', $line));
            $delimiter = strpos($clean_line, ' '); // split by first blank
            $name = trim(substr($clean_line, 0, $delimiter));
            $value = trim(substr($clean_line, $delimiter + 1));
            if (!is_string($name) || strlen($name) == 0) {
                continue;
            }
            $const = new ConstantProperty($name);
            $const->setValue($value);
            $consts[$name] = $const;
        }
        return $consts;
    }
    public function checkInput() {
    }
    public function defaultInput() {
        return '';
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



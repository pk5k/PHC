<?php #HYPERCELL hcdk.raw.Constant - BUILD 22.01.24#293
namespace hcdk\raw;
class Constant {
    use Constant\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.raw.Constant';
    const NAME = 'Constant';
    public function __construct() {
        if (method_exists($this, 'hcdkrawConstant_onConstruct')) {
            call_user_func_array([$this, 'hcdkrawConstant_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "const {$__CLASS__::_property('name', $__CLASS__, $_this) } = {$__CLASS__::_property('value', $__CLASS__, $_this) };";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
    }
    namespace hcdk\raw\Constant\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        private $name = 'UNNAMED_CONSTANT';
        private $value = 0;
        public function hcdkrawConstant_onConstruct($name) {
            $this->setName($name);
        }
        public function setName($name) {
            if (!is_string($name)) {
                throw new \Exception('Given name for constant is not a string');
            }
            $this->name = $name;
        }
        public function getName() {
            return $this->name;
        }
        public function setValue($value = null) {
            if (isset($value)) {
                if (!is_numeric($value) && !is_string($value)) {
                    throw new \Exception(self::FQN . ' - Given value for constant "' . $this->name . '" is not a string nor a numeric and therefore can\'t be used as constant');
                }
                if (!is_numeric($value) && is_string($value)) {
                    if (substr($value, 0, 1) !== '\'') {
                        $value = '\'' . $value . '\'';
                    } else if (substr($value, 0, 1) == '"') {
                        $value = str_replace('"', '\'', $value);
                    }
                }
                $this->value = $value;
            } else {
                $this->value = 'null';
            }
        }
        public function getValue() {
            return $this->value;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



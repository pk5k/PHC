<?php #HYPERCELL hcdk.raw.Property - BUILD 22.02.18#300
namespace hcdk\raw;
class Property {
    use Property\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.raw.Property';
    const NAME = 'Property';
    public function __construct() {
        if (method_exists($this, 'hcdkrawProperty_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkrawProperty_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "{$__CLASS__::_call('makeModifierString', $__CLASS__, $_this) } \${$__CLASS__::_property('name', $__CLASS__, $_this) } = {$__CLASS__::_property('value', $__CLASS__, $_this) };";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\raw\Property\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        private $name = 'unnamedProperty';
        private $modifiers = [];
        private $value = 'null';
        public function hcdkrawProperty_onConstruct_Controller($name, $modifiers = null) {
            $this->setName($name);
            $this->setModifiers($modifiers);
        }
        public function setName($name) {
            if (!is_string($name)) {
                throw new \Exception('Given property name is not a valid string');
            }
            $this->name = $name;
        }
        public function getName() {
            return $this->name;
        }
        public function setModifiers($modifiers) {
            if (!is_array($modifiers) || !count($modifiers)) {
                throw new \Exception('Given modifiers array is invalid');
            }
            $this->modifiers = $modifiers;
        }
        public function getModifiers() {
            return $this->modifiers;
        }
        public function setValue($value) {
            if (isset($value)) {
                $this->value = $value;
            } else {
                $this->value = 'null';
            }
        }
        public function getValue() {
            return $this->value;
        }
        private function makeModifierString() {
            if (!count($this->modifiers)) {
                return 'private';
            }
            $mod_str = '';
            foreach ($this->modifiers as $value) {
                $mod_str.= ' ' . $value;
            }
            return $mod_str;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
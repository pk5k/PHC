<?php #HYPERCELL hcdk.raw.Property - BUILD 17.10.11#169
namespace hcdk\raw;
class Property {
    use Property\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.raw.Property';
    const NAME = 'Property';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $output = "{$this->_call('makeModifierString') } \${$this->_property('name') } = {$this->_property('value') };";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
}
namespace hcdk\raw\Property\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
trait Controller {
    private $name = 'unnamedProperty';
    private $modifiers = [];
    private $value = 'null';
    public function onConstruct($name, $modifiers = null) {
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



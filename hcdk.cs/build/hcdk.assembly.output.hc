<?php #HYPERCELL hcdk.assembly.output - BUILD 22.01.24#200
namespace hcdk\assembly;
abstract class output extends \hcdk\assembly {
    use \hcf\core\dryver\Base, output\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.output';
    const NAME = 'output';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyoutput_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyoutput_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.RAW
    public function defaultInput() {
        $output = "{{method:stdTpl}}";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.RAW
    
    }
    namespace hcdk\assembly\output\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        protected abstract function build__toString();
        public function getName() {
            return 'OUTPUT';
        }
        protected function escape($str) {
            // escape double quotes, to don't mess up the __toString method
            $escaped = str_replace(['"', '$'], ['\\"', '\\$'], $str);
            return $escaped;
        }
        public function getConstructor() {
            return null;
        }
        public function getMethods() {
            $methods = [];
            $methods['__toString'] = $this->build__toString();
            return $methods;
        }
        public function getStaticMethods() {
            return null;
        }
        public function getProperties() {
            return null;
        }
        public function getStaticProperties() {
            return null;
        }
        public function getClassModifiers() {
            return null;
        }
        public function isAttachment() {
            return false;
        }
        public function isExecutable() {
            return false;
        }
        public function getAliases() {
            return null;
        }
        public function getTraits() {
            return ['Output' => '\\hcf\\core\\dryver\\Output'];
        }
        public function checkInput() {
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



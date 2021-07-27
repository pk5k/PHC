<?php #HYPERCELL hcdk.assembly.controller - BUILD 21.07.08#197
namespace hcdk\assembly;
abstract class controller extends \hcdk\assembly {
    use \hcf\core\dryver\Base, controller\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.controller';
    const NAME = 'controller';
    public function __construct() {
        if (method_exists($this, 'hcdkassemblycontroller_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblycontroller_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\assembly\controller\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        protected abstract function getControllerTrait();
        protected abstract function getConstructorContents();
        protected abstract function getControllerMethods();
        protected abstract function getStaticControllerMethods();
        public function getName() {
            return 'CONTROLLER';
        }
        public function getConstructor() {
            return $this->getConstructorContents();
        }
        public function getMethods() {
            return $this->getControllerMethods();
        }
        public function getStaticMethods() {
            return $this->getStaticControllerMethods();
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
        public function getAliases() {
            return null;
        }
        public function getTraits() {
            return $this->getControllerTrait();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.assembly.model - BUILD 22.02.15#207
namespace hcdk\assembly;
abstract class model extends \hcdk\assembly {
    use \hcf\core\dryver\Base, model\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.model';
    const NAME = 'model';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblymodel_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblymodel_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\assembly\model\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        protected abstract function getModelTrait();
        protected abstract function getConstructorContents();
        protected abstract function getModelMethods();
        protected abstract function getStaticModelMethods();
        public function getName() {
            return 'MODEL';
        }
        public function getConstructor() {
            return $this->getConstructorContents();
        }
        public function getMethods() {
            return $this->getModelMethods();
        }
        public function getStaticMethods() {
            return $this->getStaticModelMethods();
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
            return $this->getModelTrait();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
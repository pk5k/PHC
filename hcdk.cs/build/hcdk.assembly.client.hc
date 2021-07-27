<?php #HYPERCELL hcdk.assembly.client - BUILD 21.07.08#196
namespace hcdk\assembly;
abstract class client extends \hcdk\assembly {
    use \hcf\core\dryver\Base, client\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.client';
    const NAME = 'client';
    public function __construct() {
        if (method_exists($this, 'hcdkassemblyclient_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyclient_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\assembly\client\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        public abstract function buildClient();
        protected abstract function sourceIsAttachment();
        public function getName() {
            return 'CLIENT';
        }
        public function getConstructor() {
            return null;
        }
        public function getMethods() {
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
            return $this->sourceIsAttachment();
        }
        public function isExecutable() {
            return false;
        }
        public function getAliases() {
            return null;
        }
        public function checkInput() {
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



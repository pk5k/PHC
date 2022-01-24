<?php #HYPERCELL hcdk.assembly.log - BUILD 22.01.24#199
namespace hcdk\assembly;
abstract class log extends \hcdk\assembly {
    use \hcf\core\dryver\Base, log\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.log';
    const NAME = 'log';
    public function __construct() {
        if (method_exists($this, 'hcdkassemblylog_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblylog_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\assembly\log\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    use \hcdk\raw\Property as Property;
    trait Controller {
        protected abstract function buildGetLogAttachment();
        public function getName() {
            return 'LOG';
        }
        public function getConstructor() {
            return null;
        }
        public function getMethods() {
            return null;
        }
        public function getStaticMethods() {
            $gla = new Method('getLogAttachment', ['protected', 'static']);
            $gla->setBody($this->buildGetLogAttachment());
            $static_methods = [];
            $static_methods['getLogAttachment'] = $gla->toString();
            return $static_methods;
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
            return true;
        }
        public function isExecutable() {
            return false;
        }
        public function getAliases() {
            return null;
        }
        public function getTraits() {
            return ['Log' => '\\hcf\\core\\dryver\\Log'];
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



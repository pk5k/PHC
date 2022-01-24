<?php #HYPERCELL hcdk.assembly.config - BUILD 22.01.24#197
namespace hcdk\assembly;
abstract class config extends \hcdk\assembly {
    use \hcf\core\dryver\Base, config\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.config';
    const NAME = 'config';
    public function __construct() {
        if (method_exists($this, 'hcdkassemblyconfig_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyconfig_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\assembly\config\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    trait Controller {
        public function getName() {
            return 'CONFIG';
        }
        public function getConstructor() {
            return [1 => 'if(!isset(self::$config)){ self::loadConfig(); }' . Utils::newLine() ];
        }
        public function getMethods() {
            // Config-Channels do not have a non-static method
            return null;
        }
        public function getStaticMethods() {
            $methods = [];
            $methods['loadConfig'] = $this->buildloadConfig();
            return $methods;
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
            return ['Config' => '\\hcf\\core\\dryver\\Config'];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



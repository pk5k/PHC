<?php #HYPERCELL hcdk.assembly.view - BUILD 22.02.18#256
namespace hcdk\assembly;
abstract class view extends \hcdk\assembly {
    use \hcf\core\dryver\Base, view\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.view';
    const NAME = 'view';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyview_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkassemblyview_onConstruct_Controller'], func_get_args());
        }
    }
    }
    namespace hcdk\assembly\view\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\log\Internal as InternalLogger;
    use \hcdk\data\Sectionizer as Sectionizer;
    trait Controller {
        public abstract function buildTemplate($name, $data);
        public function getName() {
            return 'VIEW';
        }
        public function getConstructor() {
            return null;
        }
        public function getMethods() {
            $sections = Sectionizer::toArray($this->rawInput());
            $methods = [];
            foreach ($sections as $name => $data) {
                $methods[$name] = $this->buildTemplate($name, $data);
            }
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
            return ['View' => '\\hcf\\core\\dryver\\View'];
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
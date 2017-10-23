<?php #HYPERCELL hcdk.assembly.style - BUILD 17.10.11#180
namespace hcdk\assembly;
abstract class style extends \hcdk\assembly {
    use \hcf\core\dryver\Base, style\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.style';
    const NAME = 'style';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
}
namespace hcdk\assembly\style\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
trait Controller {
    public abstract function buildStyle();
    public abstract function getIsAttachment();
    public function isAttachment() {
        return $this->getIsAttachment();
    }
    public function isExecutable() {
        return false;
    }
    public function getName() {
        return 'STYLE';
    }
    public function getClassModifiers() {
        return null;
    }
    public function getConstructor() {
        return null;
    }
    public function getMethods() {
        // Style-channels do not have a non-static method
        return null;
    }
    public function getStaticMethods() {
        $methods = [];
        $methods['style'] = $this->buildStyle();
        return $methods;
    }
    public function getProperties() {
        // Style-channels do not use properties
        return null;
    }
    public function getStaticProperties() {
        // dito
        return null;
    }
    public function getAliases() {
        return null;
    }
    public function getTraits() {
        return ['Style' => '\\hcf\\core\\dryver\\Style'];
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



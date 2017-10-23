<?php #HYPERCELL hcdk.assembly.template - BUILD 17.10.11#227
namespace hcdk\assembly;
abstract class template extends \hcdk\assembly {
    use \hcf\core\dryver\Base, template\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.template';
    const NAME = 'template';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
}
namespace hcdk\assembly\template\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\core\Utils as Utils;
use \hcf\core\log\Internal as InternalLogger;
use \hcdk\data\Sectionizer as Sectionizer;
trait Controller {
    public abstract function buildTemplate($name, $data);
    public function getName() {
        return 'TEMPLATE';
    }
    public function getConstructor() {
        return null;
    }
    public function getMethods() {
        $sections = Sectionizer::toArray($this->rawInput());
        $methods = [];
        foreach ($sections as $name => $data) {
            if ($data['content'] != $this->processPlaceholders($data['content']) && in_array('static', $data['mod'])) {
                throw new \Exception(static ::FQN . ' - placeholders in static template "' . $name . '" detected. Using placeholders inside static templates is not possible.');
            }
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
        return ['Template' => '\\hcf\\core\\dryver\\Template'];
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



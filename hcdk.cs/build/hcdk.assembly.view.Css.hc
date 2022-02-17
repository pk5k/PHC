<?php #HYPERCELL hcdk.assembly.view.Css - BUILD 22.02.15#199
namespace hcdk\assembly\view;
class Css extends \hcdk\assembly\view {
    use \hcf\core\dryver\Base, Css\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.view.Css';
    const NAME = 'Css';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyviewCss_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyviewCss_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    protected function tplBuildStyle() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "if(\$as_array)
{
	return self::makeStylesheetArray();
}

return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$__CLASS__::_call('getName', $__CLASS__, $_this) }', '{$__CLASS__::_call('getType', $__CLASS__, $_this) }');";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\assembly\view\Css\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    trait Controller {
        public function getType() {
            return 'CSS';
        }
        public function sourceIsAttachment() {
            return true;
        }
        public function styleMethod() {
            $method = new Method('style', ['public', 'static'], ['as_array' => false]);
            $method->setBody($this->tplBuildStyle());
            return $method->toString();
        }
        public function getStaticMethods() {
            $methods = [];
            $methods['style'] = $this->styleMethod();
            return $methods;
        }
        public function buildTemplate($name, $data) {
            return '';
        }
        public function defaultInput() {
            return '';
        }
        public function getTraits() {
            return ['View' => '\\hcf\\core\\dryver\\View', 'ViewCss' => '\\hcf\\core\\dryver\\View\\Css'];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcdk.assembly.client.Css - BUILD 22.01.24#192
namespace hcdk\assembly\client;
class Css extends \hcdk\assembly\client {
    use \hcf\core\dryver\Base, Css\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.client.Css';
    const NAME = 'Css';
    public function __construct() {
        if (method_exists($this, 'hcdkassemblyclientCss_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyclientCss_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function tplBuildStyle() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "
if(\$as_array)
{
	return self::makeStylesheetArray();
}

return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$__CLASS__::_call('getName', $__CLASS__, $_this) }', '{$__CLASS__::_call('getType', $__CLASS__, $_this) }');
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\assembly\client\Css\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    trait Controller {
        public function getType() {
            return 'CSS';
        }
        public function sourceIsAttachment() {
            return true;
        }
        public function buildClient() {
            $method = new Method('style', ['public', 'static'], ['as_array' => false]);
            $method->setBody($this->tplBuildStyle());
            return $method->toString();
        }
        public function getStaticMethods() {
            $methods = [];
            $methods['style'] = $this->buildClient();
            return $methods;
        }
        public function defaultInput() {
            return '';
        }
        public function getTraits() {
            return ['Client' => '\\hcf\\core\\dryver\\Client', 'ClientCss' => '\\hcf\\core\\dryver\\Client\\Css'];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



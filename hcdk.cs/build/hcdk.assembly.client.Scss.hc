<?php #HYPERCELL hcdk.assembly.client.Scss - BUILD 20.10.09#180
namespace hcdk\assembly\client;
class Scss extends \hcdk\assembly\client\Css {
    use \hcf\core\dryver\Base, Scss\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.client.Scss';
    const NAME = 'Scss';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function tplBuildStyle() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "
if(\$as_array)
{
	return self::makeStylesheetArray();
}

{$__CLASS__::_call('buildMethodBody', $__CLASS__, $_this) }
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\assembly\client\Scss\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \ScssPhp\ScssPhp\Compiler as scssc;
    use \hcdk\raw\Method as Method;
    trait Controller {
        public function getType() {
            return 'SCSS';
        }
        public function sourceIsAttachment() {
            return false;
        }
        private function compile($scss) {
            $compiler = new scssc();
            $import_path = dirname($this->for_file);
            // add the channel-source's directory as import path, so we can use imports
            $compiler->addImportPath($import_path);
            $compiler->setFormatter('ScssPhp\ScssPhp\Formatter\Compressed');
            return $compiler->compile($scss);
        }
        private function buildMethodBody() {
            $body = 'return \'';
            $body.= str_replace("'", "\'", $this->compile($this->rawInput()));
            $body.= '\';';
            return $body;
        }
        public function buildClient() {
            $method = new Method('style', ['public', 'static'], ['as_array' => 'false']);
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



<?php #HYPERCELL hcdk.assembly.view.Scss - BUILD 22.02.23#204
namespace hcdk\assembly\view;
class Scss extends \hcdk\assembly\view\Css {
    use \hcf\core\dryver\Base, Scss\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.view.Scss';
    const NAME = 'Scss';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyviewScss_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkassemblyviewScss_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    protected function tplBuildStyle() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "if(\$as_array)
{
	return self::makeStylesheetArray();
}

{$__CLASS__::_call('buildMethodBody', $__CLASS__, $_this) }";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\assembly\view\Scss\__EO__;
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
            // add the assemblies directory (hypercell folder) as import path, so we can use imports
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
        public function styleMethod() {
            $method = new Method('style', ['public', 'static'], ['as_array' => 'false']);
            $method->setBody($this->tplBuildStyle());
            return $method->toString();
        }
        public function getMethods() {
            return null;
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
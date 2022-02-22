<?php #HYPERCELL hcdk.assembly.controller.Js - BUILD 22.02.18#206
namespace hcdk\assembly\controller;
class Js extends \hcdk\assembly\controller {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Config, Js\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.controller.Js';
    const NAME = 'Js';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcdkassemblycontrollerJs_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkassemblycontrollerJs_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    protected function buildClientMethod() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "\$js = \"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\";

return \$js;";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\assembly\controller\Js\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    use \hcf\core\log\Internal as InternalLogger;
    trait Controller {
        public function getType() {
            return 'JS';
        }
        protected function sourceIsAttachment() {
            return false;
        }
        public function isAttachment() {
            return false;
        }
        public function isExecutable() {
            return false;
        }
        protected function minifyJS($js_data) {
            if (self::config()->jshrink->minify) {
                $keep = (self::config()->jshrink->{'keep-doc-blocks'}) ? true : false;
                $flagged_comments = ['flaggedComments' => $keep];
                return \JShrink\Minifier::minify($js_data, $flagged_comments);
            }
            return $js_data;
        }
        public function buildClient() {
            $js = $this->minifyJS($this->rawInput());
            $client_data = str_replace('"', '\\"', $js);
            $client_data = str_replace('$', '\\$', $client_data); //Escape the $ for e.g. jQuery
            $method = new Method('script', ['public', 'static']);
            $method->setBody($this->buildClientMethod($client_data));
            //$client_data = $this->processPlaceholders($client_data);
            return $method;
        }
        protected function getControllerMethods() {
            return null;
        }
        public function getStaticControllerMethods() {
            $methods = [];
            $methods['script'] = $this->buildClient();
            return $methods;
        }
        public function defaultInput() {
            return 'class {}';
        }
        public function checkInput() {
        }
        public function getControllerTrait() {
            return ['Controller' => '\\hcf\\core\\dryver\\Controller', 'ControllerJs' => '\\hcf\\core\\dryver\\Controller\\Js'];
        }
        protected function getConstructorContents() {
            return null;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__
BEGIN[CONFIG.INI]
[jshrink]
minify = true; if false, keep-doc-blocks will be true
keep-doc-blocks = false;
END[CONFIG.INI]

?>
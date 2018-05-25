<?php #HYPERCELL hcdk.assembly.client.Js - BUILD 18.05.25#175
namespace hcdk\assembly\client;
class Js extends \hcdk\assembly\client {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Config, Js\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.client.Js';
    const NAME = 'Js';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildClientMethod() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "
\$js = \"{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }\";

return \$js;";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\client\Js\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
trait Controller {
    public function getType() {
        return 'JS';
    }
    protected function sourceIsAttachment() {
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
        $client_data = str_replace('"', '\\"', $this->minifyJS($this->rawInput()));
        $client_data = str_replace('$', '\\$', $client_data); //Escape the $ for e.g. jQuery
        $method = new Method('script', ['public', 'static']);
        $method->setBody($this->buildClientMethod($client_data));
        //$client_data = $this->processPlaceholders($client_data);
        return $method;
    }
    public function getStaticMethods() {
        $methods = [];
        $methods['script'] = $this->buildClient();
        return $methods;
    }
    public function defaultInput() {
        return '{}';
    }
    public function getTraits() {
        return ['Client' => '\\hcf\\core\\dryver\\Client', 'ClientJs' => '\\hcf\\core\\dryver\\Client\\Js'];
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



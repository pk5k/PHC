<?php #HYPERCELL hcdk.assembly.client.Ts - BUILD 21.06.20#197
namespace hcdk\assembly\client;
class Ts extends \hcdk\assembly\client {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Config, Ts\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.client.Ts';
    const NAME = 'Ts';
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
        $_func_args = \func_get_args();
        $output = "
\$js = \"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\";

return \$js;";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\assembly\client\Ts\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    use \hcf\core\log\Internal as InternalLogger;
    trait Controller {
        public function getType() {
            return 'TS';
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
            $file_path = dirname($this->for_file);
            $temp_name = basename($this->for_file, '.ts') . '.js';
            $temp_file = $file_path . '/' . $temp_name;
            if (file_exists($temp_file)) {
                throw new \Exception(self::FQN . ' - ' . $temp_name . ' already exists at ' . $temp_path . '. This file is required for storing compiled typescript.');
            }
            $windows = strpos(PHP_OS, 'WIN') === 0;
            $test = $windows ? 'where' : 'command -v';
            if (!is_executable(trim(shell_exec("$test tsc")))) {
                throw new \Exception(self::FQN . ' -  typescript compiler (tsc) seems to be missing: https://github.com/microsoft/TypeScript/#installing');
            }
            $tsc_out = shell_exec('tsc ' . $this->for_file . ' --outFile ' . $temp_file);
            if ($tsc_out != '') {
                if (file_exists($temp_file)) {
                    unlink($temp_file);
                }
                throw new \Exception('Typescript compilation errors for ' . $this->for_file . ":\n" . $tsc_out);
            }
            if (!file_exists($temp_file)) {
                throw new \Exception(self::FQN . ' - no compiled typescript output found at ' . $temp_file);
            }
            $raw_input = file_get_contents($temp_file);
            unlink($temp_file);
            $client_data = str_replace('"', '\\"', $this->minifyJS($raw_input));
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
            return 'Class Client {}';
        }
        public function getTraits() {
            return ['Client' => '\\hcf\\core\\dryver\\Client', 'ClientTs' => '\\hcf\\core\\dryver\\Client\\Js'];
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



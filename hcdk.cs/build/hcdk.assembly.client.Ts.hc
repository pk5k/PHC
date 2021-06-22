<?php #HYPERCELL hcdk.assembly.client.Ts - BUILD 21.06.22#267
namespace hcdk\assembly\client;
class Ts extends \hcdk\assembly\client\Js {
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
    use \hcf\core\Utils;
    use \hcdk\raw\Method as Method;
    use \hcf\core\log\Internal as InternalLogger;
    trait Controller {
        private static $nm_refreshed = false;
        private static $node_modules = '/node_modules/';
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
        protected function createNodeModules($at, $cs) {
            // Required to use
            //			import bla from "hcfqn.of.Hypercell"
            // npm install removes them so refreshing per build is neccessary
            // (also to keep them updated)
            $css = $cs->getSettings();
            if (!is_dir($at)) {
                mkdir($at);
            }
            foreach ($cs->getHypercells() as $hc) {
                foreach ($hc->getAssemblies() as $ass) {
                    if ($ass instanceof self) {
                        $t = $at . $hc->getName()->long . '.' . strtolower($this->getType());
                        file_put_contents($t, $ass->rawInput());
                    }
                }
            }
        }
        protected function tscSupportExists() {
            $windows = strpos(PHP_OS, 'WIN') === 0;
            $test = $windows ? 'where' : 'command -v';
            return (is_executable(trim(shell_exec("$test tsc"))));
        }
        protected function refreshNodeModules($to, $cs) {
            $this->createNodeModules($to, $cs);
            // to refer to other modules in the cellspace
            // the node_modules directory of each included cellspace
            // will be merged to it's own
            $css = $cs->getSettings();
            $includes = [];
            if (is_string($css->include)) {
                $includes = [$css->include];
            } else if (is_array($css->include)) {
                $includes = $css->include;
            }
            foreach ($includes as $include) {
                if (!is_dir($include . self::$node_modules)) {
                    InternalLogger::log()->info(self::FQN . ' - include directory does not contain a ' . self::$node_modules . ' directory - possible typescript-modules will not be found.');
                } else {
                    InternalLogger::log()->info(self::FQN . ' - copying ' . $include . self::$node_modules . '.');
                    Utils::copyPath($include . self::$node_modules, $to);
                }
            }
        }
        public function buildClient() {
            $file_path = dirname($this->for_file);
            $temp_name = basename($this->for_file, '.ts') . '.js';
            $temp_file = $file_path . '/' . $temp_name;
            if (file_exists($temp_file)) {
                throw new \Exception(self::FQN . ' - file ' . $temp_file . ' already exists. Contents will be overridden and removed while compiling assembly ' . $this->for_file);
            }
            if (!$this->tscSupportExists()) {
                throw new \Exception(self::FQN . ' -  typescript compiler (tsc) seems to be missing: https://github.com/microsoft/TypeScript/#installing');
            }
            $hc = $this->forHypercell();
            $cs = $hc->getCellspace();
            $nmp = $cs->getRoot() . self::$node_modules;
            if (!self::$nm_refreshed) {
                $this->refreshNodeModules($nmp, $cs);
                self::$nm_refreshed = true;
            }
            $tsc_out = shell_exec('tsc ' . $this->for_file . ' --baseUrl ' . $cs->getRoot() . ' --allowJs --checkJs --module amd --moduleResolution node');
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



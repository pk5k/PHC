<?php #HYPERCELL hcdk.assembly.controller.Ts - BUILD 22.02.15#141
namespace hcdk\assembly\controller;
class Ts extends \hcdk\assembly\controller\Js {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Config, Ts\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.controller.Ts';
    const NAME = 'Ts';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcdkassemblycontrollerTs_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblycontrollerTs_onConstruct'], func_get_args());
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
    protected function amdModuleName() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "/// <amd-module name=\"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\"/>";
        return $output;
    }
    protected function tsConfig() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "{
	\"files\": [\"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\"],
	\"compilerOptions\": {
		\"baseUrl\":\"{$__CLASS__::_arg($_func_args, 3, $__CLASS__, $_this) }\",
		\"rootDirs\":[\"{$__CLASS__::_arg($_func_args, 3, $__CLASS__, $_this) }\"],
		\"paths\": {\"*\": [\"./{$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }/*\"]},
		\"allowSyntheticDefaultImports\": true,
		\"allowUmdGlobalAccess\": true,
		\"lib\": [\"es6\", \"dom\"],
		\"target\":\"es6\",
		\"strict\": true,
		\"allowJs\": true,
		\"checkJs\": false,
		\"module\": \"amd\",
		\"moduleResolution\": \"node\",
		\"outFile\": \"{$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }\"
	}
}";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\assembly\controller\Ts\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils;
    use \hcdk\raw\Method as Method;
    use \hcf\core\log\Internal as InternalLogger;
    use \hcf\web\App\RequireJS;
    trait Controller {
        private static $nm_refreshed = false;
        private static $hclinks = '/_hclinks/';
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
        protected function copyOwnModules($at, $cs) {
            InternalLogger::log()->info(self::FQN . ' - creating node module directory at ' . $at);
            // Required to use
            //			import bla from "hcfqn.of.Hypercell"
            // npm install removes them so refreshing per build is neccessary
            // (also to keep them updated)
            $css = $cs->getSettings();
            $files = [];
            if (!is_dir($at)) {
                mkdir($at);
            }
            foreach ($cs->getHypercells() as $hc) {
                foreach ($hc->getAssemblies() as $ass) {
                    $nl = $hc->getName()->long;
                    if ($ass->getName() == $this->getName() && $ass->getType() == $this->getType()) {
                        $content = $ass->rawInput();
                        if ($this->amdModuleNameSubstitutionRequired($content)) {
                            $content = trim($this->amdModuleName($nl)) . Utils::newLine() . $content;
                        }
                        $t = $at . $nl . '.' . strtolower($this->getType());
                        file_put_contents($t, $content);
                        $files[] = $t;
                    }
                }
            }
            return $files;
        }
        protected function importLinkedModules($to, $cs) {
            InternalLogger::log()->info(self::FQN . ' - copying linked node_modules to ' . $to);
            // copy all node modules + hc-references of linked cellspaced to own
            $css = $cs->getSettings();
            $includes = [];
            if (is_string($css->link)) {
                $includes = [$css->link];
            } else if (is_array($css->link)) {
                $includes = $css->link;
            }
            foreach ($includes as $include) {
                if (!is_dir($include . RequireJS::NODE_MODULES)) {
                    InternalLogger::log()->info(self::FQN . ' - link directory does not contain a ' . RequireJS::NODE_MODULES . ' folder - possible typescript-modules will not be found.');
                } else {
                    InternalLogger::log()->info(self::FQN . ' - copying ' . $include . RequireJS::NODE_MODULES . '.');
                    Utils::copyPath($include . RequireJS::NODE_MODULES, $to);
                }
            }
        }
        protected function mapModule($module_dir) {
            $files = Utils::getFilesByExtension(['js'], $module_dir);
            $out = [];
            foreach ($files as $file) {
                $out[] = './' . Utils::getOffset($file, $module_dir);
            }
            return $out;
        }
        protected function refreshNodeModulesMap($to, $cs) {
            InternalLogger::log()->info(self::FQN . ' - refreshing node-modules-map at ' . $to);
            $directories = Utils::getAllSubDirectories($to, '/', true);
            $node_modules = Utils::getFilesByExtension(['js'], $to);
            $non_phc_modules = [];
            $hcbase = basename(self::$hclinks, '/');
            foreach ($directories as $module_dir) {
                $md = basename($module_dir, '/');
                if ($md != $hcbase) {
                    $non_phc_modules[$md] = $this->mapModule($module_dir);
                }
            }
            if (count($non_phc_modules) > 0) {
                $out = '';
                foreach ($non_phc_modules as $name => $paths) {
                    foreach ($paths as $path) {
                        $out.= $name . '=' . $path . Utils::newLine();
                    }
                }
                file_put_contents($to . RequireJS::NM_MAP, $out);
            }
        }
        protected function tscSupportExists() {
            $windows = strpos(PHP_OS, 'WIN') === 0;
            $test = $windows ? 'where' : 'command -v';
            $se = shell_exec("$test tsc");
            if (is_null($se)) {
                return false;
            }
            return (is_executable(trim($se)));
        }
        private function amdModuleNameSubstitutionRequired($content) {
            return ((strpos($content, 'export') !== false || strpos($content, 'import') !== false) && strpos($content, '<amd-module') === false);
        }
        private function substituteAmdModuleName($filepath, $hc_name) {
            $dir = dirname($filepath);
            $name = basename($filepath);
            $new_name = $dir . '/_AMD_' . $name;
            file_put_contents($new_name, trim($this->amdModuleName($hc_name)) . Utils::newLine() . $this->rawInput());
            return $new_name;
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
            $nmp = $cs->getRoot() . RequireJS::NODE_MODULES;
            if (!self::$nm_refreshed) {
                $this->copyOwnModules($nmp . self::$hclinks, $cs);
                $this->importLinkedModules($nmp, $cs);
                $this->refreshNodeModulesMap($nmp, $cs);
                self::$nm_refreshed = true;
            }
            $use_file = $this->for_file;
            $clean = false;
            if ($this->amdModuleNameSubstitutionRequired($this->rawInput())) {
                $clean = true;
                $use_file = $this->substituteAmdModuleName($use_file, $hc->getName()->long);
                $temp_file = $file_path . '/' . basename($use_file, '.ts') . '.js';
            }
            $hc_build_file = $nmp . $hc->getName()->long . '.json';
            $clean_bf = false;
            if (!file_exists($hc_build_file)) {
                $clean_bf = true;
                file_put_contents($hc_build_file, $this->tsConfig($use_file, $temp_file, self::$hclinks, $nmp));
            }
            $cmd = 'tsc --build ' . $hc_build_file;
            InternalLogger::log()->info(self::FQN . ' - executing: ' . $cmd);
            $tsc_out = shell_exec($cmd);
            if ($clean_bf) {
                unlink($hc_build_file);
            }
            if ($tsc_out != '') {
                if (file_exists($temp_file)) {
                    unlink($temp_file);
                }
                if ($clean) {
                    unlink($use_file);
                }
                throw new \Exception('Typescript compilation errors for ' . $this->for_file . ":\n" . $tsc_out);
            }
            if (!file_exists($temp_file)) {
                throw new \Exception(self::FQN . ' - no compiled typescript output found at ' . $temp_file);
            }
            $raw_input = file_get_contents($temp_file);
            if ($clean) {
                unlink($use_file);
            }
            unlink($temp_file);
            $client_data = str_replace('"', '\\"', $this->minifyJS($raw_input));
            $client_data = str_replace('$', '\\$', $client_data); //Escape the $ for e.g. jQuery
            $method = new Method('script', ['public', 'static']);
            $method->setBody($this->buildClientMethod($client_data));
            //$client_data = $this->processPlaceholders($client_data);
            return $method;
        }
        public function getStaticControllerMethods() {
            $methods = [];
            $methods['script'] = $this->buildClient();
            return $methods;
        }
        protected function getControllerMethods() {
            return null;
        }
        public function defaultInput() {
            return 'Class {}';
        }
        public function checkInput() {
        }
        public function getTraits() {
            return ['Client' => '\\hcf\\core\\dryver\\Client', 'ClientTs' => '\\hcf\\core\\dryver\\Client\\Js'];
        }
        public function isAttachment() {
            return false;
        }
        public function isExecutable() {
            return false;
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
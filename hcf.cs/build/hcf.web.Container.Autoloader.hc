<?php #HYPERCELL hcf.web.Container.Autoloader - BUILD 18.02.22#3142
namespace hcf\web\Container;
class Autoloader {
    use \hcf\core\dryver\Config, Autoloader\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container.Autoloader';
    const NAME = 'Autoloader';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.JSON
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'JSON');
        self::$config = json_decode($content);
    }
    # END ASSEMBLY FRAME CONFIG.JSON
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "{$__CLASS__::_call('stdTpl', $__CLASS__, $_this) }
";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    # BEGIN ASSEMBLY FRAME TEMPLATE.XML
    public function stdTpl() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = '';
        foreach ($__CLASS__::_property('data', $__CLASS__, $_this) as $current_value) {
            $__CLASS__::_call('createRow', $__CLASS__, $_this, $current_value);
            $output.= "{$__CLASS__::_property('current_row', $__CLASS__, $_this) }";
        }
        foreach ($__CLASS__::_property('assembly_data', $__CLASS__, $_this) as $assembly_name => $content) {
            $__CLASS__::_call('shiftExternal', $__CLASS__, $_this, $assembly_name, $content);
            switch ($assembly_name) {
                case 'style':
                    if ($content == "EXTERNAL") {
                        $output.= "<link rel=\"stylesheet\" type=\"text/css\" href=\"{$__CLASS__::_property('current_assembly_route', $__CLASS__, $_this) }\"/>";
                    } else {
                        $output.= "<style>$content</style>";
                    }
                break;
                case 'client':
                    if ($content == "EXTERNAL") {
                        $output.= "<script src=\"{$__CLASS__::_property('current_assembly_route', $__CLASS__, $_this) }\" language=\"javascript\"></script>";
                    } else {
                        $output.= "<script language=\"javascript\">$content</script>";
                    }
                break;
                case 'output':
                    if ($content == "EXTERNAL") {
                        $output.= "<script language=\"javascript\">alert('EXTERNAL LOADING OF OUTPUT ASSEMBLIES IS CURRENTLY NOT POSSIBLE TROUGH THE hcf.web.Container - greetings from {$__CLASS__::_constant('FQN', $__CLASS__, $_this) }');</script>";
                    } else {
                        $output.= "$content";
                    }
                break;
                default:
                    $output.= "$content";
                break;
            }
        }
        return $output;
    }
    protected function registerHCFQN() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = '';
        $output.= "document.registerComponent('{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }', {$__CLASS__::_arg(\func_get_args(), 1, $__CLASS__, $_this) });";
        return $output;
    }
    protected function stylesheet() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = '';
        if ($__CLASS__::_arg(\func_get_args(), 1, $__CLASS__, $_this) == "true") {
            $output.= "<style>{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }</style>";
        } else {
            $output.= "<link rel=\"stylesheet\" type=\"text/css\" href=\"{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }\"/>";
        }
        return $output;
    }
    protected function javascript() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = '';
        if ($__CLASS__::_arg(\func_get_args(), 1, $__CLASS__, $_this) == "true") {
            $output.= "<script language=\"javascript\">{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }</script>";
        } else {
            $output.= "<script src=\"{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }\"></script>";
        }
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.XML
    
}
namespace hcf\web\Container\Autoloader\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\core\Utils as Utils;
use \hcf\core\remote\Invoker as RemoteInvoker;
use \hcf\web\Router;
use \hcf\log\Internal as InternalLogger;
trait Controller {
    private $data = [];
    private $assembly_data = '';
    private $current_row = null;
    private $assembly_link_routes = [];
    private $current_assembly_route = null;
    /**
     * __construct
     */
    public function onConstruct($autorun = true) {
        if ($autorun) {
            $this->processSections(self::config()->shared);
            $this->assemblyLoader(self::config()->assemblies);
        }
    }
    private function writeOutRequired($assembly_name) {
        $to = $this->assembly_link_routes[$assembly_name];
        if (file_exists($to) && !isset($_GET['force-writeout'])) {
            // nothing to do in this case
            return false;
        } else {
            return true;
        }
    }
    private function writeOut($assembly_name) {
        $to = $this->assembly_link_routes[$assembly_name];
        if (isset($_GET['force-writeout'])) {
            InternalLogger::log()->info(self::FQN . ' - write-out of assembly-type "' . $assembly_name . '" to "' . $to . '" was forced by $_GET[force-writeout]');
        }
        if (!is_writable(dirname($to))) {
            throw new \Exception(self::FQN . ' - unable to write-out; "' . dirname($to) . '" is not writeable');
        }
        @file_put_contents($to, $this->assembly_data->$assembly_name);
    }
    /**
     * assemblyLoader
     * Loads the assemblies of hypercells, defined inside the "assemblies" section of config.json
     *
     * @return string - assemblyLoader output
     */
    public function assemblyLoader($assemblies) {
        $this->assembly_data = new \stdClass();
        $implicit = false;
        foreach ($assemblies as $assembly_name => $assembly_conf) {
            $implicit = ($assembly_name === 'output') ? true : false;
            $is_writeout = false;
            if (!isset($this->assembly_data->$assembly_name)) {
                $this->assembly_data->$assembly_name = '';
            }
            if (isset($assembly_conf->link) && ($assembly_conf->link === true || is_object($assembly_conf->link))) {
                // linking happens by calling a route section of hcf.web.Router which outputs all required assemblies of a given assembly-type
                // the route section is the assembly-type with a leading dash. This section can be overridden with an custom URI by replaceing
                // {"link":true} trough {"link":{"from":"?!-another-route"}}.
                // You can also add "is-writeout: true" to the link-object. This will write all the assembly-data to the file specified inside the
                // "from" property and link to it. In this case, the filepath must be relative to HCF_SHARED.
                // NOTE: if the file already exists the data won't be rewritten as long as no &force-writeout argument
                // is set on the request that creates this instance of hcf.web.Container.Autoloader
                $route_name = '-' . $assembly_name;
                $this->assembly_link_routes[$assembly_name] = '?!=' . $route_name;
                if (is_object($assembly_conf->link) && isset($assembly_conf->link->from)) {
                    // change the route to an custom URI
                    $route_name = $assembly_conf->link->from;
                    $this->assembly_link_routes[$assembly_name] = $route_name;
                    if (isset($assembly_conf->link->{'is-writeout'})) {
                        $is_writeout = $assembly_conf->link->{'is-writeout'};
                        $wo_target = HCF_SHARED . $route_name;
                        $this->assembly_link_routes[$assembly_name] = $wo_target;
                        if (isset($this->data[$wo_target])) {
                            // if the assembly-data is written to a directory that is also an shared-loader directory, the write-out file will appear in the shared-loader-list
                            // remove it from the shared-list to avoid double-loading this files
                            unset($this->data[$wo_target]);
                        }
                    }
                } else if ((substr($this->assembly_link_routes[$assembly_name], 0, 3) == '?!=') && !isset(Router::config()->$route_name)) {
                    // == '?!=' -> if an internal route is meant
                    throw new \Exception(self::FQN . ' - cannot enable external autoloading for assembly-type "' . $assembly_name . '"; missing route configuration "' . $route_name . '" in ' . Router::FQN);
                }
                if (!$is_writeout || !$this->writeOutRequired($assembly_name)) {
                    $this->assembly_data->$assembly_name = 'EXTERNAL';
                    continue;
                }
            }
            foreach ($assembly_conf->hypercells as $hcfqn) {
                RemoteInvoker::implicitConstructor($implicit);
                $invoker = new RemoteInvoker($hcfqn);
                if ($invoker->invoke('hasAssembly', [$assembly_name])) {
                    // all assemblies will be embedded
                    switch ($assembly_name) {
                        case 'output':
                            // output assemblies will be rendered as-is into the container and their constructor will be called implicit
                            $this->assembly_data->$assembly_name.= $invoker->invoke('toString');
                        break;
                        case 'style':
                            $data = $invoker->invoke('style') . Utils::newLine();
                            $this->assembly_data->$assembly_name.= (string)$data;
                        break;
                        case 'client':
                            $data = $invoker->invoke('client') . Utils::newLine();
                            $this->assembly_data->$assembly_name.= $this->registerHCFQN($hcfqn, $data);
                        break;
                    }
                } else {
                    throw new \RuntimeException('Failed to access assembly_name "' . $assembly_name . '" for Hypercell "' . $component . '" - assembly_name does not exist but was defined to load');
                }
            }
            if ($is_writeout) {
                $this->writeOut($assembly_name);
                $this->assembly_data->$assembly_name = 'EXTERNAL'; // mark as EXTERNAL after writingOut to add the link to the markup
                
            }
        }
        return $this->assembly_data;
    }
    private function shiftExternal($k, $v) {
        if (isset($this->assembly_link_routes[$k])) {
            $this->current_assembly_route = $this->assembly_link_routes[$k];
        } else {
            $this->current_assembly_route = '';
        }
    }
    /**
     * processSections
     * read the shared-section inside the config.json and add the files inside these directories to the container
     *
     * @throws RuntimeException
     * @return array - array of files, which where found for this shared-section settings
     */
    private function processSections($sections) {
        foreach ($sections as $name => $section) {
            // value is an object, if the current config-setting is a section
            if (is_object($section)) {
                $this->processSection($name, $section);
            }
        }
    }
    private function processSection($name, $section) {
        $dirs = $section->directory;
        $extension = $section->extension;
        $embed = $section->embed;
        $processor = $section->processor;
        if (!is_array($dirs)) {
            $dirs = [$dirs];
        }
        foreach ($dirs as $dir) {
            if (substr($dir, 0, 1) !== '/') {
                if (!defined('HCF_SHARED')) {
                    throw new \RuntimeException('Cannot use ' . self::FQN . ' without valid HCF_SHARED directory - set "shared" configuration inside ' . HCF_INI_FILE);
                }
                $dir = HCF_SHARED . $dir;
            }
            $files = Utils::getFilesByExtension($extension, $dir);
            sort($files); // sort always, so files inside directories will be load AFTER the parent-dir-files (useful for e.g. loading jquery plugins afterwards for the DOM: /js/jquery.js -> /js/jquery-plugins/...)
            if (is_array($files)) {
                foreach ($files as $file) {
                    $save = null;
                    if ($embed) {
                        $save = $this->file($file);
                    } else {
                        $save = $file;
                    }
                    $this->data[$file] = ['content' => $save, 'section' => $name];
                }
            }
        }
    }
    public function createRow($value) {
        $config = self::config()->shared;
        $content = $value['content'];
        $name = $value['section'];
        $section = $config->$name;
        $processor = $section->processor;
        $embed = $section->embed;
        $this->current_row = $this->$processor($content, $embed);
    }
    public function file($autoload_file) {
        if (!file_exists($autoload_file)) {
            throw new \FileNotFoundException('File "' . $autoload_file . ' does not exist');
        }
        $content = file_get_contents($autoload_file);
        return $content;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.JSON]

{
  "assemblies":{
    "output":{
			"link": false,
			"hypercells": []
		},
    "style":{
			"link": true,
			"hypercells": []
		},
    "client":{
			"link": {
        "write-out": true,
				"from": "js/scripts.js"
			},
			"hypercells": ["hcf.web.Bridge"]
		}
  },
  "shared":{
    "javascript":{
      "extension":["js"],
      "directory": ["js"],
      "embed": false,
      "processor": "javascript"
    },
    "stylesheet":{
      "extension":["css"],
      "directory": ["css"],
      "embed": false,
      "processor": "stylesheet"
    }
  }
}


END[CONFIG.JSON]


?>



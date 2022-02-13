<?php #HYPERCELL hcf.web.Container.Autoloader - BUILD 22.02.13#3293
namespace hcf\web\Container;
class Autoloader {
    use \hcf\core\dryver\Config, Autoloader\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Template, \hcf\core\dryver\Template\Html, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container.Autoloader';
    const NAME = 'Autoloader';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfwebContainerAutoloader_onConstruct')) {
            call_user_func_array([$this, 'hcfwebContainerAutoloader_onConstruct'], func_get_args());
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
        $_func_args = \func_get_args();
        $output = "{$__CLASS__::_call('stdTpl', $__CLASS__, $_this) }
";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    # BEGIN ASSEMBLY FRAME TEMPLATE.HTML
    public function stdTpl() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        foreach ($__CLASS__::_property('data', $__CLASS__, $_this) as $current_value) {
            $__CLASS__::_call('createRow', $__CLASS__, $_this, $current_value);
            $output.= "{$__CLASS__::_property('current_row', $__CLASS__, $_this) }";
        }
        foreach ($__CLASS__::_property('client_data', $__CLASS__, $_this) as $client_name => $content) {
            $__CLASS__::_call('shiftExternal', $__CLASS__, $_this, $client_name, $content);
            switch ($client_name) {
                case 'style':
                    if ($content == "EXTERNAL") {
                        $output.= "<link rel=\"stylesheet\" type=\"text/css\" href=\"{$__CLASS__::_property('current_client_route', $__CLASS__, $_this) }\"/>";
                    } else {
                        $output.= "<style>$content</style>";
                    }
                break;
                case 'script':
                    if ($content == "EXTERNAL") {
                        $output.= "<script src=\"{$__CLASS__::_property('current_client_route', $__CLASS__, $_this) }\" language=\"javascript\"></script>";
                    } else {
                        $output.= "<script language=\"javascript\">$content</script>";
                    }
                break;
                default:
                    $output.= "$content";
                break;
            }
        }
        return self::_postProcess($output, [], []);
    }
    protected function registerHCFQN() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "document.registerComponentController('{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }', {$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) });";
        return self::_postProcess($output, [], []);
    }
    protected function stylesheet() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        if ($__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) == "true") {
            $output.= "<style>{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }</style>";
        } else {
            $output.= "<link rel=\"stylesheet\" type=\"text/css\" href=\"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\"/>";
        }
        return self::_postProcess($output, [], []);
    }
    protected function javascript() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        if ($__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) == "true") {
            $output.= "<script language=\"javascript\">{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }</script>";
        } else {
            $output.= "<script src=\"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\"></script>";
        }
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME TEMPLATE.HTML
    
    }
    namespace hcf\web\Container\Autoloader\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\remote\Invoker as RemoteInvoker;
    use \hcf\web\Router;
    use \hcf\core\log\Internal as InternalLogger;
    use \hcf\core\loader\AutoLoader as CoreLoader;
    trait Controller {
        private $data = [];
        private $client_data = '';
        private $current_row = null;
        private $client_link_routes = [];
        private $current_client_route = null;
        /**
         * __construct
         */
        public function hcfwebContainerAutoloader_onConstruct($autorun = true) {
            if ($autorun) {
                $this->processSections(self::config()->shared);
                $this->clientLoader(self::config()->client);
            }
        }
        private function writeOutRequired($client_name) {
            $to = $this->client_link_routes[$client_name];
            if (file_exists($to) && !isset($_GET['force-writeout'])) {
                // nothing to do in this case
                return false;
            } else {
                return true;
            }
        }
        private function resolveConstants($str) {
            $mat = [];
            preg_match_all('/%([a-zA-Z0-9_]+)%/', $str, $mat, PREG_SET_ORDER);
            foreach ($mat as $match => $values) {
                if (!defined($values[1])) {
                    throw new \Exception(self::FQN . ' - constant ' . $values[1] . ' does not exist.');
                }
                $str = str_replace($values[0], constant($values[1]), $str);
            }
            return $str;
        }
        private function writeOut($client_name) {
            $to = $this->resolveConstants($this->client_link_routes[$client_name]);
            if (isset($_GET['force-writeout'])) {
                InternalLogger::log()->info(self::FQN . ' - write-out of client-type "' . $client_name . '" to "' . $to . '" was forced by $_GET[force-writeout]');
            }
            if (!is_writable(dirname($to))) {
                throw new \Exception(self::FQN . ' - unable to write-out; "' . dirname($to) . '" is not writeable');
            }
            @file_put_contents($to, $this->client_data->$client_name);
        }
        private function dataExists($client_name, $data) {
            // In case of wildcards data may be added doubled if one of the hypercells was added explicitly
            return (strpos($this->client_data->$client_name, $data) !== false);
        }
        private function invokeClientForData($hcfqn, $client, $implicit, $is_generic) {
            $hcfqn = Utils::PHPFQN2HCFQN($hcfqn);
            RemoteInvoker::implicitConstructor($implicit);
            $invoker = new RemoteInvoker($hcfqn);
            $hc_methods = $invoker->accessibleMethods(true);
            if (isset($hc_methods[$client])) {
                // all assemblies will be embedded
                switch ($client) {
                    case 'style':
                        $data = $invoker->invoke('style') . Utils::newLine();
                        if (!$this->dataExists($client, $data)) {
                            $this->client_data->$client.= $data;
                        }
                    break;
                    case 'script':
                        $data = $invoker->invoke('script') . Utils::newLine();
                        if (!$this->dataExists($client, $data)) {
                            $this->client_data->$client.= $this->registerHCFQN($hcfqn, $data);
                        }
                    break;
                }
            } else if (!$is_generic) {
                throw new \RuntimeException('Failed to access client "' . $client . '" for Hypercell "' . $hcfqn . '" - client does not exist but was defined to load');
            }
        }
        /**
         * clientLoader
         * Loads the client-data of hypercells, defined inside the "client-data" section of config.json
         *
         * @return string - clientLoader output
         */
        public function clientLoader($assemblies) {
            $this->client_data = new \stdClass();
            $implicit = false;
            foreach ($assemblies as $client_name => $client_conf) {
                $implicit = ($client_name === 'output') ? true : false;
                $is_writeout = false;
                if (!isset($this->client_data->$client_name)) {
                    $this->client_data->$client_name = '';
                }
                if (isset($client_conf->link) && ($client_conf->link === true || is_object($client_conf->link))) {
                    // linking happens by calling a route section of hcf.web.Router which outputs all required assemblies of a given client-type
                    // the route section is the client-type with a leading dash. This section can be overridden with an custom URI by replaceing
                    // {"link":true} trough {"link":{"from":"?!-another-route"}}.
                    // You can also add "is-writeout: true" to the link-object. This will write all the client-data to the file specified inside the
                    // "from" property and link to it. In this case, the filepath must be relative to HCF_SHARED.
                    // NOTE: if the file already exists the data won't be rewritten as long as no &force-writeout argument
                    // is set on the request that creates this instance of hcf.web.Container.Autoloader
                    $route_name = '-' . $client_name;
                    $this->client_link_routes[$client_name] = '?!=' . $route_name;
                    if (is_object($client_conf->link) && isset($client_conf->link->from)) {
                        // change the route to an custom URI
                        $route_name = $this->resolveConstants($client_conf->link->from);
                        $this->client_link_routes[$client_name] = $route_name;
                        if (isset($client_conf->link->{'is-writeout'})) {
                            $is_writeout = $client_conf->link->{'is-writeout'};
                            $wo_target = HCF_SHARED . $route_name;
                            $this->client_link_routes[$client_name] = $wo_target;
                            if (isset($this->data[$wo_target])) {
                                // if the client-data is written to a directory that is also an shared-loader directory, the write-out file will appear in the shared-loader-list
                                // remove it from the shared-list to avoid double-loading this files
                                unset($this->data[$wo_target]);
                            }
                        }
                    } else if ((substr($this->client_link_routes[$client_name], 0, 3) == '?!=') && !isset(Router::config()->$route_name)) {
                        // == '?!=' -> if an internal route is meant
                        throw new \Exception(self::FQN . ' - cannot enable external autoloading for client-type "' . $client_name . '"; missing route configuration "' . $route_name . '" in ' . Router::FQN);
                    }
                    if (!$is_writeout || !$this->writeOutRequired($client_name)) {
                        $this->client_data->$client_name = 'EXTERNAL';
                        continue;
                    }
                }
                foreach ($client_conf->hypercells as $hcfqn) {
                    // regex pattern must begin (and end) with /
                    if (substr($hcfqn, 0, 1) == '/') {
                        $loaded_classes = array_keys(CoreLoader::loadByPattern($hcfqn));
                        foreach ($loaded_classes as $phpfqn) {
                            $this->invokeClientForData($phpfqn, $client_name, $implicit, true);
                        }
                    } else {
                        $this->invokeClientForData($hcfqn, $client_name, $implicit, false);
                    }
                }
                if ($is_writeout) {
                    $this->writeOut($client_name);
                    $this->client_data->$client_name = 'EXTERNAL'; // mark as EXTERNAL after writingOut to add the link to the markup
                    
                }
            }
            return $this->client_data;
        }
        private function shiftExternal($k, $v) {
            if (isset($this->client_link_routes[$k])) {
                $this->current_client_route = $this->client_link_routes[$k];
            } else {
                $this->current_client_route = '';
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
  "client":{
    "style":{
			"link": true,
			"hypercells": []
		},
    "script":{
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

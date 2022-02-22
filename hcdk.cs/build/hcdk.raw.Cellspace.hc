<?php #HYPERCELL hcdk.raw.Cellspace - BUILD 22.02.18#293
namespace hcdk\raw;
class Cellspace {
    use \hcf\core\dryver\Config, Cellspace\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.raw.Cellspace';
    const NAME = 'Cellspace';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcdkrawCellspace_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkrawCellspace_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    
    }
    namespace hcdk\raw\Cellspace\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\log\Internal as InternalLogger;
    use \hcdk\raw\Hypercell as Hypercell;
    trait Controller {
        protected $root = null;
        protected $settings = null;
        private $hypercells = null;
        public function hcdkrawCellspace_onConstruct_Controller($cellspace_root) {
            $this->init($cellspace_root);
        }
        private function init($cellspace_root) {
            $cellspace_root = realpath($cellspace_root) . '/';
            if (!is_dir($cellspace_root)) {
                throw new \Exception('Given cellspace-root "' . $cellspace_root . '" is not a directory');
            }
            if (!is_writable($cellspace_root)) {
                throw new \Exception('Given cellspace-root "' . $cellspace_root . '" is not writeable - check your directory permissions');
            }
            $this->root = $cellspace_root;
            $this->readSetup();
        }
        public static function create($root, $nsroot, $source = null, $target = null, $format = null, $ignore = null, $link = null) {
            $es = 'Unable to create new Cellspace at "' . $root . '"';
            $root = realpath($root) . '/';
            $setup_file = $root . self::config()->file->setup;
            $map_file = $root . self::config()->file->map;
            if (!is_dir($root)) {
                throw new \Exception($es . ' - not a valid directory');
            } else if (!is_writable($root)) {
                throw new \Exception($es . ' - directory is not writeable');
            } else if (!Utils::isEmptyDirectory($root)) {
                throw new \Exception('Cannot create Cellspace at "' . $root . '" - given directory is not empty');
            }
            // apply default setup file values if necessary
            if (!isset($nsroot) || !is_string($nsroot)) {
                throw new \Exception('Given namespace-root (nsroot) is not a valid string');
            }
            if (!isset($source) || !is_string($source)) {
                $source = self::config()->default->source;
            }
            if (!isset($target) || !is_string($target)) {
                $target = self::config()->default->target;
            }
            if (!isset($ignore) || !is_array($ignore)) {
                $ignore = [];
            }
            if (!isset($format) || !is_bool($format)) {
                $format = (bool)self::config()->default->format;
            }
            $setup_file = $root . self::config()->file->setup;
            $config_str = self::configStr($nsroot, $source, $target, $format, $ignore, $link);
            if (!file_put_contents($setup_file, $config_str)) {
                throw new \Exception('Writing setup file "' . $setup_file . '" failed');
            }
            // create source directory
            Utils::buildPath($root . $source);
            // create target directory
            Utils::buildPath($root . $target);
            return new self($root);
        }
        public function add($hcfqn, $assemblies = null) {
            $nsroot = $this->settings->nsroot;
            $hcfqn = trim($hcfqn, '.');
            $hcfqn_split = explode('.', $hcfqn);
            if (!isset($this->settings->source)) {
                throw new \Exception('No source-directory specified');
            }
            if (!isset($this->settings->target)) {
                throw new \Exception('No target-directory specified');
            }
            if (!is_string($hcfqn)) {
                throw new \Exception('Given HCFQN is not a valid string');
            }
            $source_dir = realpath($this->root . '/' . $this->settings->source) . '/';
            $target_dir = realpath($this->root . '/' . $this->settings->target) . '/';
            if ($hcfqn_split[0] == $nsroot) {
                // remove the leading nsroot to create the correct offset below
                array_shift($hcfqn_split);
            } else {
                InternalLogger::log()->warn('Root-package of given HCFQN ' . $hcfqn . ' did not match namespace-root of this Cellspace (' . $nsroot . ') - full HCFQN will be ' . $nsroot . '.' . $hcfqn);
            }
            $offset = implode('/', $hcfqn_split) . '/';
            if (is_dir($source_dir . $offset)) {
                throw new \Exception('Hypercell ' . $hcfqn . ' already exists');
            }
            Utils::buildPath($source_dir . $offset, 0777);
            if (is_array($assemblies)) {
                foreach ($assemblies as $assembly) {
                    $file = $source_dir . $offset . $assembly;
                    @touch($file); // create file before ::getAssemblyInstance
                    $assembly_instance = Hypercell::getAssemblyInstance($file);
                    $default_input = $assembly_instance->defaultInput();
                    if (@file_put_contents($file, $default_input) === false) {
                        InternalLogger::log()->warn('Could not write to assembly "' . $assembly . '" for Hypercell ' . $hcfqn);
                    }
                }
            }
            return new Hypercell($this, $offset);
        }
        public function readHypercells() {
            $this->hypercells = [];
            $source_dir = $this->root;
            if (!isset($this->settings->source)) {
                throw new \Exception('No source-directory specified');
            }
            $source_dir.= $this->settings->source;
            $dirs = Utils::getAllSubDirectories($source_dir);
            // TODO Skip directories which match a value inside the setup-ignore array (wildcards allowed -> fnmatch)
            foreach ($dirs as $dir) {
                $offset = Utils::getOffset($dir, $source_dir);
                $hypercell = null;
                if (!is_string($offset) || !strlen($offset) || $offset == '.' || $offset == '..') {
                    continue;
                }
                try {
                    // Hypercells will check themselfes on instantination if they are valid
                    $hypercell = new Hypercell($this, $offset);
                }
                catch(\Exception$e) {
                    InternalLogger::log()->warn(self::FQN . '@' . $this->root . ' - skipped directory "' . $dir . '" due following exception:');
                    InternalLogger::log()->warn($e);
                    continue;
                }
                $this->hypercells[$hypercell->getName()->long] = $hypercell;
            }
        }
        public function getHypercells($force_reread = false) {
            if (!isset($this->hypercells) || $force_reread) {
                $this->readHypercells();
            }
            return $this->hypercells;
        }
        public function getRoot() {
            return $this->root;
        }
        public function getSettings() {
            return $this->settings;
        }
        public function readMap($rewrite_before = false) {
            $map_file = $this->root . self::config()->file->map;
            if ($rewrite_before) {
                $this->writeMap(true);
            }
            return file_get_contents($map_file);
        }
        public function writeMap($force_reread = false) {
            if ($force_reread) {
                $this->readHypercells();
            }
            if (!is_writable($this->root)) {
                throw new \Exception('Cannot write map to cellspace-root "' . $this->root . '" directory is not writeable');
            }
            $map_file = $this->root . self::config()->file->map;
            if (file_exists($this->root . $map_file) && !is_writable($this->root . $map_file)) {
                throw new \Exception('Map file "' . $map_file . '" is not writeable');
            }
            $map = '';
            foreach ($this->hypercells as $hypercell) {
                if ($hypercell->isExecutable()) {
                    $path = $this->settings->target . '/' . $hypercell->getName()->long . '.' . Hypercell::config()->extension;
                    $map.= Utils::HCFQN2PHPFQN($hypercell->getName()->long) . '=' . $path . Utils::newLine();
                } else {
                    InternalLogger::log()->info(' - skipped non-executable Hypercell ' . $hypercell->getName()->long);
                    continue;
                }
            }
            return file_put_contents($map_file, $map);
        }
        private function readSetup() {
            $setup_file = self::config()->file->setup;
            if (!file_exists($this->root . $setup_file)) {
                throw new \FileNotFoundException('Setup file "' . $setup_file . '" does not exist at cellspace-root "' . $this->root . '"');
            }
            $parser = new \IniParser($this->root . $setup_file);
            $this->settings = $parser->parse();
            if (!isset($this->settings->link)) {
                $this->settings->link = [];
            } else if (is_string($this->settings->link)) {
                $this->settings->link = [$this->settings->link];
            }
            $this->settings->link[] = HCF_ROOT; //hcf is always active
            foreach ($this->settings->link as $link) {
                if (!is_dir($link)) {
                    throw new \Exception(self::FQN . ' - link directory ' . $link . ' is not a directory.');
                }
            }
        }
        private static function configStr($nsroot, $source = null, $target = null, $format = null, $ignore = null, $link = null) {
            $config_str = 'nsroot = "' . $nsroot . '"' . Utils::newLine();
            // SOURCE DIRECTORY
            $config_str.= 'source = "' . $source . '"' . Utils::newLine();
            // TARGET DIRECTORY
            $config_str.= 'target = "' . $target . '"' . Utils::newLine();
            // FORMAT
            $config_str.= 'format = ' . ($format ? 'true' : 'false') . Utils::newLine();
            // IGNORE
            $config_str.= 'ignore = [';
            if (is_array($ignore)) {
                foreach ($ignore as $ignore_dir) {
                    $config_str.= '"' . $ignore_dir . '",';
                }
            }
            $config_str = trim($config_str, ',') . ']' . Utils::newLine();
            // LINK
            $config_str.= 'link = [';
            if (is_array($link)) {
                foreach ($link as $link_dir) {
                    $config_str.= '"' . $link_dir . '",';
                }
            }
            $config_str = trim($config_str, ',') . ']' . Utils::newLine();
            return $config_str;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__
BEGIN[CONFIG.INI]
; name of the file which contains the configuration of the Cellspace.
; The content of this file defines, how this cellspace will be build.
; This file must be placed at the cellspace-root, which was passed to
; the constructor of each instance.

file.setup = "cellspace.ini"

; name of the file which will be created next to the build-file above.
; It contains a mapping for the Hypercells inside this Cellspace.
; This file is required at runtime, to include a Cellspace into the
; Hypercell Framework.

file.map = "cellspace.map"

[default]
; this section represents the default setting which will be add to
; the setup-file above, if no setup-file can be found inside the
; given cellspace-root directory.
	
	; directories, relative to the cellspace-root, where the HC
	; source-files come from and the finished HCs will build to
	source = "src"
	target = "build"

	; names of directories, that should be ignored while build-time
	; wildcards allowed
	ignore = ['_*']

	; use this as the root-namespace for all hypercells inside this cellspace
	nsroot = "hcdk"

	; format source inside the build Hypercell
	; if you are encountering problems with 'PEAR.php' that cannot be found
	; set this value to false for the affected cellspace.
	format = true

	; link cellspaces for building
	; useful for e.g. importing client.ts dependencies of another cellspace 
	; to avoid build errors. hcf is always included
	link = []

END[CONFIG.INI]

?>
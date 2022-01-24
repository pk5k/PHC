<?php #HYPERCELL hcdk.cli.exec.Inspect - BUILD 22.01.24#61
namespace hcdk\cli\exec;
class Inspect extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Inspect\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Inspect';
    const NAME = 'Inspect';
    public function __construct() {
        if (method_exists($this, 'hcdkcliexecInspect_onConstruct')) {
            call_user_func_array([$this, 'hcdkcliexecInspect_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function methodRow() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "
- {$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }: {$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }

";
        return $output;
    }
    protected function propertyRow() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "
- {$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) } = {$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\cli\exec\Inspect\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\log\Internal as InternalLogger;
    use \hcdk\raw\Cellspace;
    use \hcdk\raw\Hypercell;
    use \hcdk\assembly;
    trait Controller {
        private function backupFix($directory) {
            // moving directories while opened inside the terminal, will confuse it (on Mac)
            // move to another directory and from there, switch to the original
            @chdir($_SERVER['HOME']); //use the home directory
            @chdir($directory);
        }
        public function execute($argv, $argc) {
            $__arg_dir = realpath($argv[0]);
            $__arg_hcfqn = null;
            $__arg_assemblies = [];
            foreach ($argv as $arg_i => $arg) {
                switch ($arg_i) {
                    case 0:
                        continue;
                    case 1:
                        $__arg_hcfqn = $arg;
                    break;
                    default:
                        $__arg_assemblies[] = $arg;
                }
            }
            try {
                if (!is_string($__arg_hcfqn)) {
                    throw new \Exception('First argument is not a string - can\'t be used as HCFQN');
                }
                InternalLogger::log()->info('Inspecting Hypercell ' . $__arg_hcfqn . ' in Cellspace "' . $__arg_dir . '"...');
                $cs = new Cellspace($__arg_dir);
                $hcs = $cs->getHypercells();
                if (!isset($hcs[$__arg_hcfqn])) {
                    throw new \Exception('Hypercell ' . $__arg_hcfqn . ' does not exist.');
                }
                $hci = $hcs[$__arg_hcfqn];
                $as = $hci->getAssemblies();
                foreach ($as as $as_hcfqn => $assembly) {
                    $short_as_hcfqn = strtolower(str_replace(Hypercell::config()->assembly, '', $as_hcfqn));
                    if (in_array($short_as_hcfqn, $__arg_assemblies) || !count($__arg_assemblies)) {
                        $this->inspectAssembly($assembly);
                    }
                }
            }
            catch(\Exception $e) {
                InternalLogger::log()->error('Unable to inspect Hypercell ' . $__arg_hcfqn . ' at "' . $__arg_dir . '" due following exception:');
                InternalLogger::log()->error($e);
            }
        }
        private function inspectAssembly(assembly $assembly) {
            $type = 'regular';
            if ($assembly->isAttachment()) {
                $type = 'attachment';
            } else if ($assembly->isExecutable()) {
                $type = 'executable';
            }
            echo Utils::newLine() . '>' . $assembly::FQN . '[' . $type . ']:' . Utils::newLine();
            echo 'Current raw-input: ' . Utils::newLine() . $assembly->rawInput() . Utils::newLine();
            $mods = $assembly->getClassModifiers();
            $constructor = $assembly->getConstructor();
            $traits = $assembly->getTraits();
            $methods = $assembly->getMethods();
            $s_methods = $assembly->getStaticMethods();
            $props = $assembly->getProperties();
            $s_props = $assembly->getStaticProperties();
            if (is_array($mods)) {
                if (isset($mods['extends'])) {
                    echo 'Extends Hypercell ' . Utils::PHPFQN2HCFQN($mods['extends'][0]) . Utils::newLine();
                }
                if (isset($mods['implements'])) {
                    echo 'Implements ' . implode(', ', $mods['implements']) . Utils::newLine();
                }
            }
            if (is_array($traits)) {
                echo 'Traits involved: ' . implode(', ', $traits) . Utils::newLine();
            }
            if (is_array($constructor)) {
                echo 'Constructor index: ' . key($constructor) . Utils::newLine();
            }
            if (is_array($props)) {
                echo 'Properties provided: ' . Utils::newLine();
                foreach ($props as $name => $init_val) {
                    echo $this->propertyRow($name, $init_val);
                }
            }
            if (is_array($s_props)) {
                echo 'Static properties provided: ' . Utils::newLine();
                foreach ($s_props as $name => $init_val) {
                    echo $this->propertyRow($name, $init_val);
                }
            }
            if (is_array($methods)) {
                echo 'Methods provided: ' . Utils::newLine();
                foreach ($methods as $name => $method) {
                    echo $this->methodRow($name, $this->functionHeader($method));
                }
            }
            if (is_array($s_methods)) {
                echo 'Static methods provided: ' . Utils::newLine();
                foreach ($s_methods as $name => $method) {
                    echo $this->methodRow($name, $this->functionHeader($method));
                }
            }
        }
        private function functionHeader($method_str) {
            return (stripos($method_str, 'abstract') !== false) ? $method_str : substr($method_str, 0, strpos($method_str, '{'));
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



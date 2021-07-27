<?php #HYPERCELL hcdk.cli.exec.Add - BUILD 21.07.08#71
namespace hcdk\cli\exec;
class Add extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Add\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Add';
    const NAME = 'Add';
    public function __construct() {
        if (method_exists($this, 'hcdkcliexecAdd_onConstruct')) {
            call_user_func_array([$this, 'hcdkcliexecAdd_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\cli\exec\Add\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\log\Internal as InternalLogger;
    use \hcdk\raw\Cellspace as Cellspace;
    trait Controller {
        public function execute($argv, $argc) {
            $__arg_dir = realpath($argv[0]);
            $__arg_hcfqn = null;
            $__arg_assemblies = [];
            foreach ($argv as $arg_i => $arg) {
                switch ($arg_i) {
                    case 0:
                        continue 2;
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
                InternalLogger::log()->info('Adding Hypercell ' . $__arg_hcfqn . ' to Cellspace "' . $__arg_dir . '"...');
                $cellspace = new Cellspace($__arg_dir);
                $hc = $cellspace->add($__arg_hcfqn, $__arg_assemblies);
                InternalLogger::log()->info('...Hypercell ' . $__arg_hcfqn . ' created successfully');
            }
            catch(\Exception $e) {
                InternalLogger::log()->error('Unable to add Hypercell "' . $__arg_hcfqn . '" to Cellspace "' . $__arg_dir . '" due following exception:');
                InternalLogger::log()->error($e);
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



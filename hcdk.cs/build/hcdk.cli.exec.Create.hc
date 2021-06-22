<?php #HYPERCELL hcdk.cli.exec.Create - BUILD 18.06.15#59
namespace hcdk\cli\exec;
class Create extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Create\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Create';
    const NAME = 'Create';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\cli\exec\Create\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\log\Internal as InternalLogger;
    use \hcdk\raw\Cellspace as Cellspace;
    trait Controller {
        public function execute($argv, $argc) {
            $__arg_dir = realpath($argv[0]);
            $__arg_nsroot = null;
            $__arg_source = null;
            $__arg_target = null;
            $__arg_format = null;
            $__arg_ignore = [];
            $__arg_include = [];
            $__arg_verbose = null;
            foreach ($argv as $arg_i => $arg) {
                switch ($arg) {
                    case '--nsroot':
                    case '-ns':
                        $__arg_nsroot = $argv[$arg_i + 1];
                    break;
                    case '--source':
                    case '-s':
                        $__arg_source = $argv[$arg_i + 1];
                    break;
                    case '--target':
                    case '-t':
                        $__arg_target = $argv[$arg_i + 1];
                    break;
                    case '--format':
                    case '-f':
                        $__arg_format = (bool)$argv[$arg_i + 1];
                    break;
                    case '--at':
                    case '-at':
                        $__arg_dir = realpath($argv[$arg_i + 1]); //next argument must be the directory
                        
                    break;
                    case '--verbose':
                    case '-v':
                        $__arg_verbose = true;
                    break;
                }
            }
            if ($__arg_verbose) {
                InternalLogger::log()->setLevel(LoggerLevel::getLevelInfo());
            }
            try {
                InternalLogger::log()->info('Creating new Cellspace at "' . $__arg_dir . '"...');
                Cellspace::create($__arg_dir, $__arg_nsroot, $__arg_source, $__arg_target, $__arg_format, $__arg_ignore, $__arg_include);
                InternalLogger::log()->info('...Cellspace "' . $__arg_nsroot . '" created successfully');
            }
            catch(\Exception $e) {
                InternalLogger::log()->error('Unable to create Cellspace at "' . $__arg_dir . '" due following exception:');
                InternalLogger::log()->error($e);
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



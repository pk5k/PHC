<?php #HYPERCELL hcdk.cli.exec.Map - BUILD 21.07.08#68
namespace hcdk\cli\exec;
class Map extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Map\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Map';
    const NAME = 'Map';
    public function __construct() {
        if (method_exists($this, 'hcdkcliexecMap_onConstruct')) {
            call_user_func_array([$this, 'hcdkcliexecMap_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\cli\exec\Map\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\log\Internal as InternalLogger;
    use \hcf\cli\Colors as CliColors;
    use \hcdk\raw\Cellspace as Cellspace;
    trait Controller {
        public function execute($argv, $argc) {
            $__arg_dir = realpath($argv[0]);
            $__arg_wb = false;
            foreach ($argv as $arg_i => $arg) {
                switch ($arg) {
                    case '--write-before':
                    case '-wb':
                        $__arg_wb = true;
                    break;
                    case '--at':
                    case '-at':
                        $__arg_dir = realpath($argv[$arg_i + 1]); //next argument must be the directory
                        
                    break;
                }
            }
            try {
                $tree = [];
                $cellspace = new Cellspace($__arg_dir);
                $map_data = $cellspace->readMap($__arg_wb);
                echo $map_data . Utils::newLine();
            }
            catch(\Exception $e) {
                InternalLogger::log()->error('Unable to generate cellspace-tree due following exception:');
                InternalLogger::log()->error($e);
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



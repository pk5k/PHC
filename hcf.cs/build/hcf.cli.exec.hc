<?php #HYPERCELL hcf.cli.exec - BUILD 18.05.25#26
namespace hcf\cli;
abstract class exec {
    use exec\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.cli.exec';
    const NAME = 'exec';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
}
namespace hcf\cli\exec\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
trait Controller {
    public abstract function execute($argv, $argc);
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



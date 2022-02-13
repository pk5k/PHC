<?php #HYPERCELL hcdk.cli.exec.Version - BUILD 22.01.24#72
namespace hcdk\cli\exec;
class Version extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Version\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Version';
    const NAME = 'Version';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkcliexecVersion_onConstruct')) {
            call_user_func_array([$this, 'hcdkcliexecVersion_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\cli\exec\Version\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    trait Controller {
        public function execute($argv, $argc) {
            echo Utils::newLine() . '> PHP: ' . PHP_VERSION . '@' . php_sapi_name();
            echo Utils::newLine() . '> Hypercell Framework (HCF): ' . HCF_VERSION;
            echo Utils::newLine() . '> Hypercell Development Kit (HCDK): ' . HCDK_VERSION;
            echo Utils::newLine() . Utils::newLine();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



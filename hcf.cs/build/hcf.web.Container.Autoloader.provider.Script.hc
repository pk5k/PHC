<?php #HYPERCELL hcf.web.Container.Autoloader.provider.Script - BUILD 17.10.11#8
namespace hcf\web\Container\Autoloader\provider;
class Script extends \hcf\web\Container\Autoloader\provider {
    use \hcf\core\dryver\Base, Script\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container.Autoloader.provider.Script';
    const NAME = 'Script';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $output = "{$this->_call('provideAssemblies') }
";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
}
namespace hcf\web\Container\Autoloader\provider\Script\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\core\Utils;
trait Controller {
    public static function provideAssemblies() {
        parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('myscript.js'));
        return parent::provideAssembliesOfType('client');
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



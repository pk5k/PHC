<?php #HYPERCELL hcf.web.Container.Autoloader.provider.Script - BUILD 18.05.25#13
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
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "{$__CLASS__::_call('provideAssemblies', $__CLASS__, $_this) }
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
        return parent::provideAssembliesOfType('script');
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



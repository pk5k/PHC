<?php #HYPERCELL hcf.web.Container.provider.Script - BUILD 22.02.23#4
namespace hcf\web\Container\provider;
class Script extends \hcf\web\Container\provider {
    use \hcf\core\dryver\Base, Script\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container.provider.Script';
    const NAME = 'Script';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcfwebContainerproviderScript_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcfwebContainerproviderScript_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    public function __toString() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "{$__CLASS__::_call('provideAssemblies', $__CLASS__, $_this) }";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcf\web\Container\provider\Script\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils;
    use \hcf\web\Controller as WebController;
    trait Controller {
        public static function provideAssemblies() {
            parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('myscript.js'));
            if (isset($_GET['component'])) {
                return self::provideComponentScript(htmlspecialchars($_GET['component']));
            }
            return parent::provideAssembliesOfType('script');
        }
        private static function provideComponentScript($hcfqn) {
            $classes = parent::getComponents($hcfqn, WebController::class);
            $out = '';
            foreach ($classes as $class) {
                $out.= $class::wrappedClientController();
            }
            return $out;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
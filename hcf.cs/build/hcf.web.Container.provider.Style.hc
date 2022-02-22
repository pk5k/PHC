<?php #HYPERCELL hcf.web.Container.provider.Style - BUILD 22.02.20#1
namespace hcf\web\Container\provider;
class Style extends \hcf\web\Container\provider {
    use \hcf\core\dryver\Base, Style\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container.provider.Style';
    const NAME = 'Style';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcfwebContainerproviderStyle_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcfwebContainerproviderStyle_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "{$__CLASS__::_call('provideAssemblies', $__CLASS__, $_this) }";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcf\web\Container\provider\Style\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils;
    trait Controller {
        public static function provideAssemblies() {
            parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mystyle.css'));
            if (isset($_GET['component'])) {
                return self::provideComponentStyle(htmlspecialchars($_GET['component']));
            }
            return parent::provideAssembliesOfType('style');
        }
        private static function provideComponentStyle($hcfqn) {
            $classes = parent::getComponents($hcfqn);
            $out = '';
            foreach ($classes as $class) {
                $out.= $class::style();
            }
            return $out;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
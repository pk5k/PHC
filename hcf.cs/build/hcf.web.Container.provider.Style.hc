<?php #HYPERCELL hcf.web.Container.provider.Style - BUILD 22.03.18#9
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
        $__CLASS__ = get_called_class();
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
    use \hcf\web\Component as WebComponent;
    use \hcf\web\Controller as WebController;
    use \hcf\web\RenderContext;
    trait Controller {
        public static function provideAssemblies() {
            if (isset($_GET['component'])) {
                parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mystyle.js'));
                return self::provideComponentStyle(htmlspecialchars($_GET['component']));
            }
            parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mystyle.css'));
            return parent::provideAssembliesOfType('style');
        }
        private static function provideComponentStyle($hcfqn) {
            $context = (isset($_GET['context']) ? htmlspecialchars($_GET['context']) : null);
            $classes = parent::getComponents($hcfqn, WebComponent::class, WebController::class);
            $out = '';
            $first_class = null;
            foreach ($classes as $class) {
                if (is_null($first_class)) {
                    $first_class = $class;
                }
                $out.= $class::style();
            }
            if (is_null($first_class)) {
                return '';
            }
            return $first_class::wrappedStyle($context, $out); // creates only style element in client
            
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
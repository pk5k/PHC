<?php #HYPERCELL hcf.web.Container.provider.Template - BUILD 22.02.20#3
namespace hcf\web\Container\provider;
class Template extends \hcf\web\Container\provider {
    use \hcf\core\dryver\Base, Template\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container.provider.Template';
    const NAME = 'Template';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcfwebContainerproviderTemplate_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcfwebContainerproviderTemplate_onConstruct_Controller'], func_get_args());
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
    namespace hcf\web\Container\provider\Template\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils;
    use \hcf\web\Component as WebComponent;
    trait Controller {
        public static function provideAssemblies() {
            parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mytemplate.js'));
            if (!isset($_GET['component'])) {
                throw new \Exception(self::FQN . ' - no component given.');
            }
            return self::provideComponentTemplate(htmlspecialchars($_GET['component']));
        }
        private static function provideComponentTemplate($hcfqn) {
            $context = (isset($_GET['context']) ? htmlspecialchars($_GET['context']) : null);
            $classes = parent::getComponents($hcfqn);
            $out = '';
            foreach ($classes as $class) {
                $out.= $class::wrappedTemplate($context);
            }
            return $out;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
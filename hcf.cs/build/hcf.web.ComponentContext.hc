<?php #HYPERCELL hcf.web.ComponentContext - BUILD 22.02.21#22
namespace hcf\web;
class ComponentContext {
    use ComponentContext\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.ComponentContext';
    const NAME = 'ComponentContext';
    public function __construct() {
        if (method_exists($this, 'hcfwebComponentContext_onConstruct_Model')) {
            call_user_func_array([$this, 'hcfwebComponentContext_onConstruct_Model'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        if ($__CLASS__::_property('allow_global_style', $__CLASS__, $_this) == "true") {
            $output.= "<style id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }-global-base-style\">{$__CLASS__::_call('styles', $__CLASS__, $_this) }</style>";
            $output.= "<link id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }-global-component-styles\" rel=\"stylesheet\" href=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['style', $__CLASS__::_property('components', $__CLASS__, $_this) ]) }\"/>";
        }
        $output.= "<script src=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['script', $__CLASS__::_property('components', $__CLASS__, $_this) ]) }\"></script>";
        $output.= "<template id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }\" data-global=\"{$__CLASS__::_property('allow_global_style', $__CLASS__, $_this) }\">";
        $output.= "<style id=\"base-style\">{$__CLASS__::_call('styles', $__CLASS__, $_this) }</style>";
        $output.= "<link id=\"component-styles\" rel=\"stylesheet\" href=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['style', $__CLASS__::_property('components', $__CLASS__, $_this) ]) }\"/>";
        foreach ($__CLASS__::_property('components', $__CLASS__, $_this) as $fqn => $component) {
            $output.= "<div id=\"$fqn\">{$__CLASS__::_call('templateOf|map', $__CLASS__, $_this, [$component]) }</div>";
        }
        $output.= "</template>";
        return self::_postProcess($output, [], []);
    }
    protected function styles() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        foreach ($__CLASS__::_property('stylesheet_embed', $__CLASS__, $_this) as $embed) {
            $output.= "$embed";
        }
        foreach ($__CLASS__::_property('components', $__CLASS__, $_this) as $fqn => $component) {
            $output.= "{$__CLASS__::_call('styleOf|map', $__CLASS__, $_this, [$component]) }";
        }
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME VIEW.HTML
    
    }
    namespace hcf\web\ComponentContext\__EO__;
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    
    /**
     * Create instance of ComponentContext, add hcf.web.Components via ::register and pass ComponentContext to hcf.web.Container::registerComponentContext
     * to make all registered instances available in your document. Each registered component must extend hcf.web.Component
     *
     */
    use \Exception;
    use \hcf\web\Component as WebComponent;
    trait Model {
        private static $registry = [];
        private $components = [];
        private $id = null;
        private $stylesheet_embed = [];
        private $allow_global_style = 'false';
        public function hcfwebComponentContext_onConstruct_Model($id) {
            if (is_null($id) || trim($id) == '') {
                throw new Exception(self::FQN . ' - given id is invalid.');
            } else if (isset(self::$registry[$id])) {
                throw new Exception(self::FQN . ' - given id is already registered');
            }
            $this->id = $id;
            self::$registry[$id] = $this;
        }
        public static function get($id) {
            if (isset(self::$registry) && isset(self::$registry[$id])) {
                return self::$registry[$id];
            }
            return null;
        }
        public function allowGlobalStyle($allow) {
            $this->allow_global_style = ($allow) ? 'true' : 'false';
        }
        public function register( /* WebComponent::class */
        $component_class) {
            if (!is_subclass_of($component_class, WebComponent::class) && $component_class != WebComponent::class) {
                throw new Exception(self::FQN . ' - given class ' . $component_class . ' does not implement ' . WebComponent::class);
            }
            $fqn = $component_class::FQN;
            if (isset($this->components[$fqn])) {
                throw new Exception(self::FQN . ' - component ' . $fqn . ' already registered.');
            }
            $this->components[$fqn] = $component_class;
        }
        private function clientControllerOf($component) {
            return $component::wrappedClientController($this->id);
        }
        private function styleOf($component) {
            return $component::style();
        }
        private function templateOf($component) {
            return $component::template();
        }
        public function embedStylesheet($which) {
            $this->stylesheet_embed[] = $which;
        }
        private function url($target, $component) {
            if (is_array($component)) {
                $c_str = '';
                foreach ($component as $fqn => $component) {
                    $c_str.= $fqn . ',';
                }
                $component = substr($c_str, 0, -1);
            }
            $v = (defined('APP_VERSION') ? '&v=' . APP_VERSION : ''); // define APP_VERSION and increment on updates to override caches
            return '?!=-' . $target . '&context=' . $this->id . '&component=' . $component . $v;
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcf.web.ComponentContext - BUILD 22.02.17#11
namespace hcf\web;
class ComponentContext {
    use \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, ComponentContext\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.ComponentContext';
    const NAME = 'ComponentContext';
    public function __construct() {
        if (method_exists($this, 'hcfwebComponentContext_onConstruct')) {
            call_user_func_array([$this, 'hcfwebComponentContext_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "document.registerComponentController=function(hcfqn,controller_class,component_context_id,as_element,element_options){var prop_hcfqn=hcfqn;var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();var prop_name=hcfqn;for(var i in split){var part=split[i];if(!scope[part]){scope[part]={};}
scope=scope[part];}
controller_class.FQN=prop_hcfqn;controller_class.NAME=prop_name;scope[hcfqn]=controller_class;if(as_element!=undefined&&as_element!=null){if(element_options==undefined){element_options={};}
customElements.define(as_element,scope[hcfqn],element_options);if(document.componentMap==undefined){document.componentMap={};}
document.componentMap[as_element.toUpperCase()]={fqn:prop_hcfqn,context:component_context_id};}
return scope[hcfqn];};";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "<script language=\"javascript\">";
        foreach ($__CLASS__::_property('components', $__CLASS__, $_this) as $fqn => $component) {
            $output.= "{$__CLASS__::_call('clientControllerOf|map', $__CLASS__, $_this, [$component]) }";
        }
        $output.= "</script>";
        if ($__CLASS__::_property('allow_global_style', $__CLASS__, $_this) == "true") {
            $output.= "<style id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }-base-style-global\">{$__CLASS__::_call('styles', $__CLASS__, $_this) }</style>";
        }
        $output.= "<template id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }\">";
        $output.= "<style id=\"base-style\">{$__CLASS__::_call('styles', $__CLASS__, $_this) }</style>";
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
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    static public function wrappedClientController() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "document.registerComponentController('{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }', {$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) });";
        return $output;
    }
    static public function wrappedClientControllerWithElement() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "document.registerComponentController('{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }', {$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }, '{$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }', '{$__CLASS__::_arg($_func_args, 3, $__CLASS__, $_this) }', {$__CLASS__::_arg($_func_args, 4, $__CLASS__, $_this) });";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
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
        public function hcfwebComponentContext_onConstruct($id) {
            if (is_null($id) || trim($id) == '') {
                throw new Exception(self::FQN . ' - given id is invalid.');
            } else if (isset(self::$registry[$id])) {
                throw new Exception(self::FQN . ' - given id is already registered');
            }
            $this->id = $id;
            self::$registry[$id] = $this;
        }
        public function allowGlobalStyle($allow) {
            $this->allow_global_style = ($allow) ? 'true' : 'false';
        }
        public function register( /* WebComponent::class */
        $component_class) {
            if (!is_subclass_of($component_class, WebComponent::class)) {
                throw new Exception(self::FQN . ' - given class ' . $component_class . ' does not implement ' . WebComponent::class);
            }
            $fqn = $component_class::FQN;
            if (isset($this->components[$fqn])) {
                throw new Exception(self::FQN . ' - component ' . $fqn . ' already registered.');
            }
            $this->components[$fqn] = $component_class;
        }
        private function clientControllerOf($component) {
            if (is_null($component::elementName()) || $component::elementName() == WebComponent::elementName()) {
                return self::wrappedClientController($component::FQN, $component::script());
            } else {
                return self::wrappedClientControllerWithElement($component::FQN, $component::script(), $this->id, $component::elementName(), $component::elementOptions());
            }
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
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
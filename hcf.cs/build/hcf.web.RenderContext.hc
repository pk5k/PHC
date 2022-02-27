<?php #HYPERCELL hcf.web.RenderContext - BUILD 22.02.26#43
namespace hcf\web;
class RenderContext {
    use RenderContext\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.RenderContext';
    const NAME = 'RenderContext';
    public function __construct() {
        if (method_exists($this, 'hcfwebRenderContext_onConstruct_Model')) {
            call_user_func_array([$this, 'hcfwebRenderContext_onConstruct_Model'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    public function __toString() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "<template id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }\" data-global=\"{$__CLASS__::_property('allow_global_style', $__CLASS__, $_this) }\">";
        if ($__CLASS__::_call('styles', $__CLASS__, $_this) != "") {
            $output.= "<style id=\"base-style\">{$__CLASS__::_call('styles', $__CLASS__, $_this) }</style>";
        }
        if ($__CLASS__::_property('import_fonts', $__CLASS__, $_this) === true) {
            foreach ($__CLASS__::_call('importedFonts', $__CLASS__, $_this) as $path) {
                $output.= "<link class=\"container-font\" rel=\"stylesheet\" href=\"$path\"/>";
            }
        }
        if ($__CLASS__::_call('componentsLoad', $__CLASS__, $_this) === true) {
            $output.= "<link id=\"component-styles\" rel=\"stylesheet\" href=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['style', $__CLASS__::_property('components', $__CLASS__, $_this) ]) }\"/>";
        }
        $output.= "</template>";
        if ($__CLASS__::_property('allow_global_style', $__CLASS__, $_this) == "true") {
            if ($__CLASS__::_call('styles', $__CLASS__, $_this) != "") {
                $output.= "<style id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }-global-base-style\">{$__CLASS__::_call('styles', $__CLASS__, $_this) }</style>";
            }
            if ($__CLASS__::_call('componentsLoad', $__CLASS__, $_this) === true) {
                $output.= "<link id=\"{$__CLASS__::_property('id', $__CLASS__, $_this) }-global-component-styles\" rel=\"stylesheet\" href=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['style', $__CLASS__::_property('components', $__CLASS__, $_this) ]) }\"/>";
            }
        }
        if ($__CLASS__::_call('componentsLoad', $__CLASS__, $_this) === true) {
            if ($__CLASS__::_call('debugMode', $__CLASS__, $_this) === true) {
                foreach ($__CLASS__::_property('components', $__CLASS__, $_this) as $component => $class) {
                    $output.= "<script src=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['template', $component]) }\"></script>";
                }
            } else {
                $output.= "<script src=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['template', $__CLASS__::_property('components', $__CLASS__, $_this) ]) }\"></script>";
            }
            $output.= "<script src=\"{$__CLASS__::_call('url|map', $__CLASS__, $_this, ['script', $__CLASS__::_property('components', $__CLASS__, $_this) ]) }\"></script>";
        }
        return self::_postProcess($output, [], []);
    }
    protected function styles() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        foreach ($__CLASS__::_property('stylesheet_embed', $__CLASS__, $_this) as $embed) {
            $output.= "$embed";
        }
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME VIEW.HTML
    
    }
    namespace hcf\web\RenderContext\__EO__;
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    
    /**
     * Create instance of RenderContext, add hcf.web.Components via ::register and pass RenderContext to hcf.web.Container::registerRenderContext
     * to make all registered instances available in your document. Each registered component must extend hcf.web.Component
     *
     */
    use \Exception;
    use \hcf\web\Controller as WebController;
    use \hcf\web\Component as WebComponent;
    use \hcf\web\Container;
    trait Model {
        private static $registry = [];
        private $components = [];
        private $id = null;
        private $stylesheet_embed = [];
        private $allow_global_style = 'false';
        private $import_fonts = false;
        public function hcfwebRenderContext_onConstruct_Model($id) {
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
        private function debugMode() {
            return HCF_DEBUG;
        }
        private function importedFonts() {
            return Container::loadedFonts();
        }
        public function importFonts($import = true) {
            $this->import_fonts = $import; // links the configured fonts of hcf.web.Container to the shadow dom
            
        }
        public function exportStyle($allow) {
            $this->allow_global_style = ($allow) ? 'true' : 'false';
        }
        public function register( /* WebController::class */
        $component_class) {
            if (!is_subclass_of($component_class, WebController::class) && $component_class != WebController::class) {
                throw new Exception(self::FQN . ' - given class ' . $component_class . ' does not implement ' . WebController::class);
            }
            $fqn = $component_class::FQN;
            if (isset($this->components[$fqn])) {
                throw new Exception(self::FQN . ' - component ' . $fqn . ' already registered.');
            }
            $this->components[$fqn] = $component_class;
        }
        public function embedStylesheet($which) {
            $this->stylesheet_embed[] = $which;
        }
        private function componentsLoad() {
            return (count($this->components) > 0);
        }
        private static function containerBaseDir() {
            return isset(Container::config()->base) ? Container::config()->base : '/';
        }
        private function url($target, $component) {
            if (is_array($component)) {
                $c_str = '';
                foreach ($component as $fqn => $component) {
                    $c_str.= $fqn . ',';
                }
                $component = substr($c_str, 0, -1);
            }
            $context = '';
            if ($target == 'template') {
                $context = '&context=' . $this->id;
            }
            $v = (defined('APP_VERSION') ? '&v=' . APP_VERSION : ''); // define APP_VERSION and increment on updates to override caches
            return self::containerBaseDir() . '?!=-' . $target . $context . '&component=' . $component . $v;
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
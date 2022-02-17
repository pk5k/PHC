<?php #HYPERCELL hcf.web.Component - BUILD 22.02.17#13
namespace hcf\web;
class Component {
    use \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\View\Css, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Component';
    const NAME = 'Component';
    public function __construct() {
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "class extends HTMLElement{constructor(){super();this.loadElement();}
loadElement(){if(document.componentMap[this.tagName]==undefined){throw'Element '+this.tagName.toLowerCase()+' is not in the component map and thus cannot be used.';}
let component_definition=document.componentMap[this.tagName];let shadow_root=this.attachShadow({mode:'open'});let content=document.getElementById(component_definition.context).content;let tpl=content.getElementById(component_definition.fqn);shadow_root.appendChild(content.getElementById('base-style').cloneNode(true));let children=tpl.children;for(let i in children){if(children[i]instanceof HTMLElement){shadow_root.appendChild(children[i].cloneNode(true));}}}}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    static public function template() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "
	
";
        return self::_postProcess($output, [], []);
    }
    static public function elementOptions() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "{}";
        return self::_postProcess($output, [], []);
    }
    static public function elementName() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "no-component";
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME VIEW.HTML
    # BEGIN ASSEMBLY FRAME VIEW.SCSS
    public static function style($as_array = false) {
        if ($as_array) {
            return self::makeStylesheetArray();
        }
        return '';
    }
    # END ASSEMBLY FRAME VIEW.SCSS
    
    }
    namespace hcf\web\Component\__EO__;
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcf.web.Component - BUILD 22.02.28#33
namespace hcf\web;
class Component extends \hcf\web\Controller {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, Component\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\View\Css, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Component';
    const NAME = 'Component';
    public function __construct() {
        if (method_exists($this, 'hcfwebComponent_onConstruct_Model')) {
            call_user_func_array([$this, 'hcfwebComponent_onConstruct_Model'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "class extends HTMLElement{constructor(){super();this.loadTemplate();}
loadTemplate(){if(document.componentMap[this.FQN]==undefined){throw'Element '+this.tagName.toLowerCase()+' is not in the component map and thus cannot be used.';}
let render_context=document.componentMap[this.FQN];let shadow_root=this.attachShadow({mode:'open'});let context=null;let tpl=null;if(render_context=='global'){context=document.head;tpl=context.querySelector('div[id=\"'+this.FQN+'\"]');}
else{context=document.getElementById(render_context).content;tpl=context.getElementById(this.FQN);}
context.querySelectorAll('style, link').forEach((e)=>{shadow_root.appendChild(e.cloneNode(true));});let children=tpl.children;for(let i in children){if(children[i]instanceof HTMLElement){shadow_root.appendChild(children[i].cloneNode(true));}}}
bridge(to){return hcf.web.Bridge((to==undefined)?this.FQN:to);}
renderContext(){if(document.componentMap[this.FQN]==undefined){throw'Element '+this.tagName+' ('+this.FQN+') is not registered in component map - render context cannot be determined';}
return document.getElementById(document.componentMap[this.FQN]);}
runAfterDomLoad(func){hcf.web.Component.extRunAfterDomLoad(func);}
static extRunAfterDomLoad(func){if(document.readyState==='loading'){window.addEventListener('DOMContentLoaded',function(){func()});}
else{func();}}
dispatchEvent(event){let ret=super.dispatchEvent(event);const eventFire=this['on'+event.type];if(eventFire){return ret;}
else{const func=new Function('e','with(document) {'+'with(this) {'+'let attr = '+this.getAttribute('on'+event.type)+';'+'if(typeof attr === \'function\' && this instanceof HTMLElement) { return attr(e)};'+'}'+'}');let ret_own=func.call(this,event);return ret_own||ret;}}}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    static public function template() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "
	
";
        return self::_postProcess($output, [], []);
    }
    static public function elementOptions() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "{}";
        return self::_postProcess($output, [], []);
    }
    static public function elementName() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "{$__CLASS__::_call('genericElementName', $__CLASS__, $_this) }";
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
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    static public function wrappedClientControllerWithElement() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "document.registerComponentController('{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }', {$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }, '{$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }', {$__CLASS__::_arg($_func_args, 3, $__CLASS__, $_this) });";
        return $output;
    }
    static public function wrapTemplate() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "if ({$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) } == null) {
	throw 'Missing render context {$__CLASS__::_arg($_func_args, 3, $__CLASS__, $_this) }'; 
} else if ({$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }.querySelector('div[id=\"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\"]') == null) {
	document.componentMap['{$__CLASS__::_constant('FQN', $__CLASS__, $_this) }'] = '{$__CLASS__::_arg($_func_args, 3, $__CLASS__, $_this) }';
	let t_wrapper = document.createElement('div');
	t_wrapper.innerHTML = '{$__CLASS__::_call('removeLinebreaks|map', $__CLASS__, $_this, [$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) ]) }';
	t_wrapper.setAttribute('id', '{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }');
	{$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }.appendChild(t_wrapper);
}";
        return $output;
    }
    static private function targetHead() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "document.head";
        return $output;
    }
    static private function targetRenderContext() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "document.getElementById('{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }').content";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcf\web\Component\__EO__;
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    trait Model {
        // hcf.web.Components are hcf.web.Controllers with a view, represented by a html-tag in the browser which must be defined by the component itself
        public static function hasTemplate() {
            return !(is_null(static ::elementName()) || static ::elementName() == '' || static ::FQN == self::FQN);
        }
        public static function wrappedClientController() {
            if (static ::hasTemplate()) {
                return self::wrappedClientControllerWithElement(static ::FQN, static ::script(), static ::elementName(), static ::elementOptions());
            } else {
                return self::wrappedClientControllerOnly(static ::FQN, static ::script());
            }
        }
        public static function wrappedTemplate($render_context_id = null) {
            if (static ::hasTemplate()) {
                if (is_null($render_context_id)) {
                    return static ::wrapTemplate(static ::FQN, static ::escapedTemplate(), self::targetHead(), 'global');
                } else {
                    return static ::wrapTemplate(static ::FQN, static ::escapedTemplate(), self::targetRenderContext($render_context_id), $render_context_id);
                }
            } else {
                return '';
            }
        }
        protected static function genericElementName() {
            return strtolower(str_replace('.', '-', static ::FQN)); // override elementName template if you want a specific element name, otherwise the hcfqn in lowercase with dots replaced by dashes will be used.
            
        }
        protected static function escapedTemplate() {
            return str_replace("'", "\'", static ::template());
        }
        protected static function removeLinebreaks($from) {
            return trim(str_replace("\n", '', $from)); // linebreaks in javascript strings lead to invalid result. Newlines in HTML aren't neccessary anyway
            
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
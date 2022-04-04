<?php #HYPERCELL hcf.web.Component - BUILD 22.03.28#108
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
        $js = "class extends HTMLElement{constructor(){super();this.attachShadow({mode:'open'});this.loadTemplate();}
construct(){if(this._constructed){return;}
if(this._constructed===false){this.loadTemplate();}
this._constructed=true;this.linkStylesheets();this.constructedCallback();}
constructedCallback(){}
destruct(){if(!this._constructed){return;}
this._constructed=false;this.destructedCallback();this.unlinkStylesheets();this.removeEventListeners();this.shadowRoot.removeEventListeners();this.shadowRoot.innerHTML='';this.innerHTML='';}
destructedCallback(){}
connectedCallback(){if(!this._constructed){this.construct();}
this._connected=true;}
disconnectedCallback(){let c=this;setTimeout(function(){if(c.getRootNode().host==undefined&&!document.body.contains(c)&&!c.inPreservedContext()){c.destruct();}},0);this._connected=false;}
inPreservedContext(){if(this.preserve==true||this.getAttribute('preserve')=='true'){return true;}
let p=this.parentNode;while(p!=null){if(p.preserve==true||p.getAttribute('preserve')){return true;}
p=p.parentNode;}
return false;}
loadTemplate(){if(this.shadowRoot==undefined){throw'No shadow root attached to load template - in '+this.FQN;}
let tpl=this.renderContextTemplate();let children=tpl.children;for(let i in children){if(children[i]instanceof HTMLElement){this.shadowRoot.appendChild(children[i].cloneNode(true));}}}
contextStylesheets(){let context_styles=document.componentStyleMap[this.renderContextId()];let context_fonts=[];if(this.renderContext().getAttribute('data-import-fonts')=='true'){let fonts=document.importFontList();context_styles=fonts.concat(context_styles);}
return context_styles;}
linkStylesheets(){if(this._styles_setup){return;}
if(this.shadowRoot==undefined){throw'No shadowRoot initialized for '+this.FQN;}
let context_styles=this.contextStylesheets();if(context_styles!=undefined){this.shadowRoot.adoptedStyleSheets=context_styles;}
this._styles_setup=true;}
unlinkStylesheets(){if(!this._styles_setup){return;}
if(this.shadowRoot==undefined){throw'No shadowRoot initialized for '+this.FQN;}
delete this.shadowRoot.adoptedStyleSheets;this._styles_setup=null;}
view(){if(this.shadowRoot==undefined){throw'View for '+this.FQN+' was not initialized yet.';}
return this.shadowRoot;}
bridge(to){return hcf.web.Bridge((to==undefined)?this.FQN:to);}
renderContextTemplate(){let render_context_id=this.renderContextId();let rc=this.renderContext();if(render_context_id=='global'){return rc.querySelector('div[id=\"'+this.FQN+'\"]');}
else{let context=rc.content;return context.getElementById(this.FQN);}}
renderContextId(){if(document.componentMap[this.FQN]==undefined){throw'Element '+this.tagName.toLowerCase()+' is not in the component map and thus cannot be used.';}
return document.componentMap[this.FQN];}
renderContext(){if(document.componentMap[this.FQN]==undefined){throw'Element '+this.tagName+' ('+this.FQN+') is not registered in component map - render context cannot be determined';}
let render_context=this.renderContextId();if(render_context=='global'){return document.head;}
else{return document.getElementById(render_context);}}
runAfterDomLoad(func){hcf.web.Component.extRunAfterDomLoad(func);}
static extRunAfterDomLoad(func){if(document.readyState==='loading'){let loadedFunc=function(){func();window.removeEventListener('DOMContentLoaded',loadedFunc);};window.addEventListener('DOMContentLoaded',loadedFunc);}
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
    static public function wrapStyle() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "(function(){
	let css = new CSSStyleSheet();
	css.replaceSync('{$__CLASS__::_call('removeLinebreaks|map', $__CLASS__, $_this, [$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) ]) }');
	if (document.componentStyleMap['{$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }'] == undefined){ document.componentStyleMap['{$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }'] = [css] }else{ document.componentStyleMap['{$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }'].push(css) }
	document.exportStylesheet(css, '{$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }');
})();";
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
                    return static ::wrapTemplate(static ::FQN, static ::escaped(static ::template()), self::targetHead(), 'global');
                } else {
                    return static ::wrapTemplate(static ::FQN, static ::escaped(static ::template()), self::targetRenderContext($render_context_id), $render_context_id);
                }
            } else {
                return '';
            }
        }
        public static function wrappedStyle($render_context_id = null, $style_override = null) {
            if (method_exists(static ::class, 'style')) {
                if (is_null($render_context_id)) {
                    return static ::wrapStyle(static ::escaped(is_null($style_override) ? static ::style() : $style_override), 'global');
                } else {
                    return static ::wrapStyle(static ::escaped(is_null($style_override) ? static ::style() : $style_override), $render_context_id);
                }
            } else {
                return '';
            }
        }
        protected static function genericElementName() {
            return strtolower(str_replace('.', '-', static ::FQN)); // override elementName template if you want a specific element name, otherwise the hcfqn in lowercase with dots replaced by dashes will be used.
            
        }
        protected static function escaped($input) {
            return str_replace("'", "\'", $input);
        }
        protected static function removeLinebreaks($from) {
            return trim(str_replace("\n", '', $from)); // linebreaks in javascript strings lead to invalid result. Newlines in HTML aren't neccessary anyway
            
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
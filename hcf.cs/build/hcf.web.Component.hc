<?php #HYPERCELL hcf.web.Component - BUILD 22.02.22#4
namespace hcf\web;
class Component {
    use \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, Component\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\View\Css, \hcf\core\dryver\Internal;
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
loadTemplate(){if(document.componentMap[this.tagName]==undefined){throw'Element '+this.tagName.toLowerCase()+' is not in the component map and thus cannot be used.';}
let component_definition=document.componentMap[this.tagName];let shadow_root=this.attachShadow({mode:'open'});let context=null;let tpl=null;if(component_definition.context==''){context=document.head;tpl=context.querySelector('div[id=\"'+component_definition.fqn+'\"]');}
else{context=document.getElementById(component_definition.context).content;tpl=context.getElementById(component_definition.fqn);}
context.querySelectorAll('style, link').forEach((e)=>{shadow_root.appendChild(e.cloneNode(true));});let children=tpl.children;for(let i in children){if(children[i]instanceof HTMLElement){shadow_root.appendChild(children[i].cloneNode(true));}}}
runAfterDomLoad(func){hcf.web.Component.extRunAfterDomLoad(func);}
static extRunAfterDomLoad(func){if(document.readyState==='loading'){window.addEventListener('DOMContentLoaded',function(){func()});}
else{func();}}
static loadDependencies(hcfqn,to_context){let component='&component=';if(hcfqn==undefined||hcfqn==null){throw'hcfqn is invalid';}
else if(hcfqn.constructor===Array){component+=hcfqn.join(',');}
else{component+=hcfqn;}
let version=(document.APP_VERSION!=undefined)?'&v='+document.APP_VERSION:'';let context=(to_context!=null&&to_context!=undefined)?'&context='+to_context:'';let controller=new Promise((resolve,reject)=>{let elem=document.createElement('script');elem.setAttribute('src','?!=-script'+component+context+version);elem.addEventListener('load',(e)=>resolve(e));elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);});let template=new Promise((resolve,reject)=>{let elem=document.createElement('script');elem.setAttribute('src','?!=-template'+component+context+version);elem.addEventListener('load',(e)=>resolve(e));elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);});let style=new Promise((resolve,reject)=>{let elem=document.createElement('link');elem.setAttribute('href','?!=-style'+component+context+version);elem.setAttribute('type','text/css');elem.setAttribute('rel','stylesheet');if(context!=''){let c=document.getElementById(to_context);if(c==null){throw'component context '+to_context+' does not exist';}
let global_allowed=(c.getAttribute('data-global')=='true');if(global_allowed){elem.addEventListener('load',(e)=>{resolve(e);c.content.appendChild(elem.cloneNode(true));});elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);}
else{resolve();c.content.appendChild(elem);}}
else{elem.addEventListener('load',(e)=>resolve(e));elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);}});return[controller,template,style];}}";
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
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    static public function wrappedClientControllerOnly() {
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
    static public function wrapTemplate() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "if ({$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) } == null) {
	throw 'Missing component context {$__CLASS__::_arg($_func_args, 3, $__CLASS__, $_this) }'; 
} else if ({$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }.querySelector('div[id=\"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\"]') == null) {
	let t_wrapper = document.createElement('div');
	t_wrapper.innerHTML = '{$__CLASS__::_call('removeLinebreaks|map', $__CLASS__, $_this, [$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) ]) }';
	t_wrapper.setAttribute('id', '{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }');
	{$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }.appendChild(t_wrapper);
}";
        return $output;
    }
    static private function targetHead() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "document.head";
        return $output;
    }
    static private function targetComponentContext() {
        $__CLASS__ = __CLASS__;
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
        public static function hasTemplate() {
            return !(is_null(static ::elementName()) || static ::elementName() == self::elementName());
        }
        public static function wrappedClientController($component_context_id = null) {
            if (static ::hasTemplate()) {
                return self::wrappedClientControllerWithElement(static ::FQN, static ::script(), $component_context_id, static ::elementName(), static ::elementOptions());
            } else {
                return self::wrappedClientControllerOnly(static ::FQN, static ::script());
            }
        }
        public static function wrappedTemplate($component_context_id = null) {
            // Nur in der Methode die aufgerufen wird gilt static:: wirklich der referenzierten Klasse, in allen Aufrufen aus Templates usw. wird es zur Klasse in der die Methode definiert wurde
            if (static ::hasTemplate()) {
                if (is_null($component_context_id)) {
                    return static ::wrapTemplate(static ::FQN, static ::escapedTemplate(), self::targetHead(), 'global');
                } else {
                    return static ::wrapTemplate(static ::FQN, static ::escapedTemplate(), self::targetComponentContext($component_context_id), $component_context_id);
                }
            } else {
                return '';
            }
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
<?php #HYPERCELL hcf.web.Controller - BUILD 22.02.26#8
namespace hcf\web;
class Controller {
    use \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, Controller\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Controller';
    const NAME = 'Controller';
    public function __construct() {
        if (method_exists($this, 'hcfwebController_onConstruct_Model')) {
            call_user_func_array([$this, 'hcfwebController_onConstruct_Model'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "class{static _resource_cache=[];static isCached(hcfqn){let me=hcf.web.Controller;if(me._resource_cache.indexOf(hcfqn)==-1){return false;}
return true;}
static loadResources(hcfqn,to_context){let me=hcf.web.Controller;let component='&component=';let load=[];if(hcfqn==undefined||hcfqn==null){throw'hcfqn is invalid';}
else if(hcfqn.constructor===Array){hcfqn.forEach((dependency)=>{if(!me.isCached(dependency)&&load.indexOf(dependency)==-1){load.push(dependency);}});component+=load.join(',');}
else{if(!me.isCached(hcfqn)){load.push(hcfqn);component+=hcfqn;}}
if(load.length==0){return[];}
let version=(document.APP_VERSION!=undefined)?'&v='+document.APP_VERSION:'';let context=(to_context!=null&&to_context!=undefined)?'&context='+to_context:'';let base=document.head.querySelector('base');let base_href='/';if(base!=null&&base.hasAttribute('href')){base_href=base.getAttribute('href');}
let controller=new Promise((resolve,reject)=>{let elem=document.createElement('script');elem.setAttribute('src',base_href+'?!=-script'+component+version);elem.addEventListener('load',(e)=>resolve(e));elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);});let template=new Promise((resolve,reject)=>{let elem=document.createElement('script');elem.setAttribute('src',base_href+'?!=-template'+component+context+version);elem.addEventListener('load',(e)=>resolve(e));elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);});let style=new Promise((resolve,reject)=>{let elem=document.createElement('link');elem.setAttribute('href',base_href+'?!=-style'+component+version);elem.setAttribute('type','text/css');elem.setAttribute('rel','stylesheet');if(context!=''){let c=document.getElementById(to_context);if(c==null){throw'render context '+to_context+' does not exist';}
let global_allowed=(c.getAttribute('data-global')=='true');if(global_allowed){elem.addEventListener('load',(e)=>{resolve(e);c.content.appendChild(elem.cloneNode(true));});elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);}
else{resolve();c.content.appendChild(elem);}}
else{elem.addEventListener('load',(e)=>resolve(e));elem.addEventListener('error',(e)=>reject(e));document.head.appendChild(elem);}});let promises=[controller,template,style];Promise.all(promises).then(()=>{me._resource_cache=me._resource_cache.concat(load);});return promises;}}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    static public function wrappedClientControllerOnly() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "document.registerComponentController('{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }', {$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) });";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcf\web\Controller\__EO__;
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    trait Model {
        // hcf.web.Controller can be any javascript-class/-object/-function that will be added to it's namespace in the document if load
        // hcf.web.Component is the generalisation of this
        public static function wrappedClientController() {
            return self::wrappedClientControllerOnly(static ::FQN, static ::script());
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcf.web.Page - BUILD 22.02.22#26
namespace hcf\web;
class Page extends \hcf\web\Component {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, Page\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Page';
    const NAME = 'Page';
    public function __construct() {
        if (method_exists($this, 'hcfwebPage_onConstruct_Model')) {
            call_user_func_array([$this, 'hcfwebPage_onConstruct_Model'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "class extends hcf.web.Component{constructor(){super();let load_trigger=this.shadowRoot.querySelector('.hcf-load-trigger');if(this.getAttribute('autoload')=='false'){load_trigger.remove();load_trigger=null;}
if(load_trigger!=null){let load_as=load_trigger.getAttribute('data-load');this.loadView(load_as).then((data)=>{this.loaded_as=load_as;this.viewLoadSuccess(data);}).catch((code,msg)=>this.viewLoadFailed(code,msg));load_trigger.remove();}
this.addEventListener('page-rendered',(e)=>{this.ready(this.pageRoot());});}
pageRoot(){return this.page_root;}
ready(view_root){}
cacheReload(){}
beforeUnload(){}
cache(){return true;}
reload(){if(this.loaded_as==undefined||this.loaded_as==null){throw'cannot reload - page was not load yet.';}
return this.loadView(this.loaded_as).then((data)=>this.viewLoadSuccess(data)).catch((code,msg)=>this.viewLoadFailed(code,msg));}
clear(){this.page_root=null;let children=this.shadowRoot.children;let remove=[];for(let i in children){let t_name=children[i].tagName;if(children[i]instanceof HTMLElement&&t_name!='STYLE'&&t_name!='LINK'){remove.push(children[i]);}}
remove.forEach((e)=>{e.remove();});}
viewLoadSuccess(data){let e=new Event('page-load-view-success',{bubbles:true});this.dispatchEvent(e);this.render(data);}
viewLoadFailed(code,msg){let e=new Event('page-load-view-failed',{bubbles:true});this.dispatchEvent(e);this.error(code,msg);}
injectView(view_data,load_as){this.loaded_as=load_as;return this.render(view_data);}
render(view_data){this.clear();let wrapper=document.createElement('div');wrapper.innerHTML=view_data;let children=wrapper.children;let first=null;for(let i in children){if(children[i]instanceof HTMLElement){if(first==null){first=children[i];}
this.shadowRoot.appendChild(children[i].cloneNode(true));}}
this.page_root=first;let e=new Event('page-rendered',{bubbles:true});this.dispatchEvent(e);}
getOwnAttributes(){let atts=this.attributes;let out={};for(var i in atts){if(!isNaN(i)){let att_name=atts[i];let att_val=this.getAttribute(att_name);out[att_name]=att_val;}}
return out;}
loadView(which){let e=new Event('page-load-view-begin',{bubbles:true});if(which==undefined||which==null){throw'given hcfqn is invalid.';}
return new Promise((resolve,reject)=>{hcf.web.Bridge(which).render().do({arguments:[this.getOwnAttributes()],timeout:0,onSuccess:(data)=>{resolve(data)},onError:(code,msg)=>{reject(code,msg)},onTimeout:(code,msg)=>{reject(code,msg)}});});}
error(code,msg){this.loaded_as=null;console.error(code,msg);}}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "";
        return self::_postProcess($output, [], []);
    }
    static public function internalTemplate() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "<div class=\"hcf-load-trigger\" data-load=\"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\"></div>";
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME VIEW.HTML
    
    }
    namespace hcf\web\Page\__EO__;
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    trait Model {
        public function hcfwebPage_onConstruct_Model($initial_attributes) // initial_attributes = Attributes of the pages html-element on initialisation time
        {
            static ::checkPermissions();
        }
        public static function template() {
            return static ::internalTemplate(static ::FQN);
        }
        public static function elementName() {
            return static ::genericElementName();
        }
        protected static function genericElementName() {
            return strtolower(str_replace('.', '-', static ::FQN)); // override this method if you want a specific element name, otherwise the hcfqn with dots replaced by dashes will be used.
            
        }
        public static function checkPermissions() {
            return; // override this method and throw exceptions if page should not be load trough hcf.web.Router. Router will catch and reroute according to this exception (if configured)
            
        }
        protected static function fqn() {
            return static ::FQN;
        }
        public static function wrappedElementName($autoload = true) {
            $en = static ::genericElementName();
            $al = '';
            if (!$autoload) {
                $al = ' autoload="false"';
            }
            return '<' . $en . $al . '></' . $en . '>';
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
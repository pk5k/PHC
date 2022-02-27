<?php #HYPERCELL hcf.web.Page - BUILD 22.02.26#30
namespace hcf\web;
class Page extends \hcf\web\Component {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, Page\__EO__\Controller, Page\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Page';
    const NAME = 'Page';
    public function __construct() {
        if (method_exists($this, 'hcfwebPage_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcfwebPage_onConstruct_Controller'], func_get_args());
        }
        if (method_exists($this, 'hcfwebPage_onConstruct_Model')) {
            call_user_func_array([$this, 'hcfwebPage_onConstruct_Model'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "class extends hcf.web.Component{constructor(){super();this.runAfterDomLoad(()=>{let autoload=this.getAttribute('autoload');this.render_changes=this.getAttribute('render-changes');if(autoload!=null&&autoload!='false'){this.load();}});this.addEventListener('page-rendered',(e)=>{this.loaded(this.pageRoot());});}
pageRoot(){return this.page_root;}
loaded(view_root){}
cacheReload(){}
beforeUnload(){}
cache(){return true;}
load(){if(this.loaded_as!=undefined){return this.reload();}
else{let load_trigger=this.shadowRoot.querySelector('.hcf-load-trigger');if(load_trigger==null){throw'page was not loaded yet and load trigger cannot be found.';}
load_trigger.remove();return this.loadView().then((data)=>{this.loaded_as=this.FQN;this.viewLoadSuccess(data);}).catch((code,msg)=>this.viewLoadFailed(code,msg));}}
reload(){if(this.loaded_as==undefined||this.loaded_as==null){throw'cannot reload - page was not load yet.';}
return this.loadView(this.loaded_as).then((data)=>this.viewLoadSuccess(data)).catch((code,msg)=>this.viewLoadFailed(code,msg));}
static get observedAttributes(){return['render-changes'];}
attributeChangedCallback(attr,oldValue,newValue){if(attr.indexOf('-')>-1){attr=attr.replace('-','_');}
if(attr!=null&&oldValue!=newValue){this[attr]=newValue;}}
set render_changes(val){if(val!=null&&val!='false'){this.setupObserver();}
else{this.removeObserver();}}
get render_changes(){return this.getAttribute('render-changes');}
clear(){this.page_root=null;let children=this.shadowRoot.children;let remove=[];for(let i in children){let t_name=children[i].tagName;if(children[i]instanceof HTMLElement&&t_name!='STYLE'&&t_name!='LINK'){remove.push(children[i]);}}
remove.forEach((e)=>{e.remove();});}
viewLoadSuccess(data){let e=new Event('page-load-view-success',{bubbles:true});this.dispatchEvent(e);this.render(data);}
viewLoadFailed(code,msg){let e=new Event('page-load-view-failed',{bubbles:true});this.dispatchEvent(e);this.error(code,msg);}
injectView(view_data,load_as){this.loaded_as=load_as;return this.render(view_data);}
render(view_data){this.clear();this.style.visibility='hidden';let wrapper=document.createElement('div');wrapper.innerHTML=view_data;let children=wrapper.children;let first=null;for(let i in children){if(children[i]instanceof HTMLElement){if(first==null){first=children[i];}
this.shadowRoot.appendChild(children[i].cloneNode(true));}}
wrapper.remove();this.page_root=first;let me=this;setTimeout(function(){me.style.visibility=null;let e=new Event('page-rendered',{bubbles:true});me.dispatchEvent(e);},50);}
getOwnAttributes(){let atts=this.attributes;let out={};let skip=['render-changes','autoload','style'];for(var i in atts){if(!isNaN(i)){let att=atts[i];if(skip.indexOf(att.name)!=-1){continue;}
out[att.name]=att.value;}}
return out;}
loadView(){var e=new Event('page-load-view-begin',{bubbles:true});this.dispatchEvent(e);return this.bridge().render().do([this.getOwnAttributes()]);}
error(code,msg){this.loaded_as=null;console.error(code,msg);}
removeObserver(){if(this._observer!=undefined){this._observer.disconnect();delete this._observer;}}
setupObserver(){if(this._observer!=undefined){this.removeObserver();}
const config={attributes:true,childList:false,subtree:false};this._observer=new MutationObserver((e)=>{if(e[0].attributeName!='style'){this.reload()}});this._observer.observe(this,config);}}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    public function __toString() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "";
        return self::_postProcess($output, [], []);
    }
    static public function internalTemplate() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "<div class=\"hcf-load-trigger\"></div>";
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME VIEW.HTML
    
    }
    namespace hcf\web\Page\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        protected static $_ARGS = [];
        public function hcfwebPage_onConstruct_Controller($initial_attributes) // initial_attributes = Attributes of the pages html-element on initialisation time
        {
            self::initAttributes($initial_attributes);
            static ::checkPermissions();
        }
        private static function initAttributes($attrs) {
            if (is_string($attrs) && $attrs != 'null') {
                $attrs = json_decode($attrs);
            }
            if (is_null($attrs) || $attrs == 'null') {
                return;
            }
            foreach ($attrs as $key => $val) {
                $key_filtered = filter_var($key, FILTER_SANITIZE_STRING);
                $val_filtered = filter_var($val, FILTER_SANITIZE_STRING);
                self::$_ARGS[$key_filtered] = $val_filtered;
            }
        }
        public static function attribute($key = null) {
            if (!isset($key)) {
                return self::$_ARGS;
            }
            if (isset($key) && isset(self::$_ARGS[$key])) {
                return self::$_ARGS[$key];
            } else {
                return null;
            }
        }
        public static function checkPermissions() {
            return; // override this method and throw exceptions if page should not be load trough hcf.web.Router. Router will catch and reroute according to this exception (if configured)
            
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    trait Model {
        public static function template() {
            return static ::internalTemplate(static ::FQN);
        }
        public static function title() {
            return ''; // override this method to set the title of the target browser window if page gets load trough hcf.web.PageLoader
            
        }
        public static function wrappedElementName($autoload = false, $render_changes = false, $initial_attributes = null) {
            $en = static ::genericElementName();
            $args = '';
            if ($autoload) {
                $args = ' autoload="true"';
            }
            if ($render_changes) {
                $args = ' render-changes="true"';
            }
            if (!is_null($initial_attributes) && $initial_attributes != '') {
                if (is_string($initial_attributes)) {
                    $initial_attributes = json_decode($initial_attributes);
                }
                if (is_object($initial_attributes)) {
                    foreach ($initial_attributes as $key => $val) {
                        $args.= ' ' . filter_var($key, FILTER_SANITIZE_STRING) . '="' . filter_var($val, FILTER_SANITIZE_STRING) . '"';
                    }
                }
            }
            return '<' . $en . $args . '></' . $en . '>';
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
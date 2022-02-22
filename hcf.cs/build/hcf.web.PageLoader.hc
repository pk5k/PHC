<?php #HYPERCELL hcf.web.PageLoader - BUILD ?
namespace hcf\web;
class PageLoader extends \hcf\web\Component {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Config, \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, PageLoader\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\View\Css, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.PageLoader';
    const NAME = 'PageLoader';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfwebPageLoader_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcfwebPageLoader_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.JSON
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'JSON');
        self::$config = json_decode($content);
    }
    # END ASSEMBLY FRAME CONFIG.JSON
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "class extends hcf.web.Component{static instance=null;static current_request=null;static _cache={};static _map={}
static _loaded_dependencies=[];static cache(page_fqn,set){let me=hcf.web.PageLoader;if(set==undefined){if(me._cache[page_fqn]==undefined){return null;}
return me._cache[page_fqn];}
me._cache[page_fqn]=set;if(set===false){delete me._map[page_fqn];}}
static addToMap(route_name,target_page_fqn){let me=hcf.web.PageLoader;if(me._map[target_page_fqn]==undefined){me._map[target_page_fqn]=[route_name];}
else{me._map[target_page_fqn].push(route_name);}}
static pageFqnForRoute(route_name){let me=hcf.web.PageLoader;for(let i in me._map){let o=me._map[i];if(o.indexOf(route_name)>-1){return i;}}
return null;}
static activeInstance(){let me=hcf.web.PageLoader;if(me.instance!=undefined){let current=me.instance.current_page;let cached=me.cache(current);if(cached!=null&&(cached.instance!=null)&&cached.instance!=undefined){return cached.instance;}}
return null;}
constructor(){super();if(hcf.web.PageLoader.instance!=undefined){throw'only one hcf.web.PageLoader instance (= 1 page-loader element) can exist per document';}
hcf.web.PageLoader.instance=this;window.addEventListener('popstate',(e)=>this.navigationOccured(e));}
connectedCallback(){if(this.current_route==undefined){this.runAfterDomLoad(()=>{this.loader_color=this.getAttribute('loader-color');this.loader_color_error=this.getAttribute('loader-color-error');this.link_class=this.getAttribute('link-class');if(!this.hasAttribute('route')){throw'route attribute required.';}
this.initStateFragments();this.initRouterLinks();this.loadPage(this.getAttribute('route'));});super.instance=this;}}
static get observedAttributes(){return['loader-color-error','loader-color','link-class'];}
attributeChangedCallback(attr,oldValue,newValue){if(attr.indexOf('-')>-1){attr=attr.replace('-','_');}
if(attr!=null&&oldValue!=newValue){this[attr]=newValue;}}
set link_class(val){if(val==null||val==undefined){this._link_class='router-link';}
else{this._link_class=val;}}
get link_class(){return this._link_class;}
set loader_color(val){this._loader_color=val;}
get loader_color(){return this._loader_color;}
set loader_color_error(val){this._loader_color_error=val;}
get loader_color_error(){return this._loader_color_error;}
initStateFragments(){let error_slot=this.shadowRoot.querySelector('.error-fragment');let main_slot=this.shadowRoot.querySelector('.main-fragment');if(error_slot.assignedElements().length>0){let ae=error_slot.assignedElements();let elem=ae[0];this.page_error_fragment=elem.parentNode.removeChild(elem);}
error_slot.classList.add('initialized');}
addLinkListener(to_elem){if(!to_elem.classList.contains('router-link-initialized')){to_elem.addEventListener('click',(e)=>{this.routerLinkClicked(e);});to_elem.classList.add('router-link-initialized');}}
initRouterLinks(){document.querySelectorAll('.'+this._link_class+'-crawl').forEach((search_for_router_links)=>{if(search_for_router_links.shadowRoot!=null&&search_for_router_links.shadowRoot!=undefined){if(search_for_router_links.classList.contains('crawl-add-all')){search_for_router_links.shadowRoot.querySelectorAll('a[href]').forEach((shadow_router_link)=>{this.addLinkListener(shadow_router_link);});}
else{search_for_router_links.shadowRoot.querySelectorAll('.'+this._link_class).forEach((shadow_router_link)=>{this.addLinkListener(shadow_router_link);});}}});document.querySelectorAll('.'+this._link_class).forEach((router_link)=>{this.addLinkListener(router_link);});}
dispatchQuery(href){let arg=this.contentWrapperElement().getAttribute('data-router-arg');let parts=href.split('&');let route=null;let url_args={};for(var i in parts){let part=parts[i].split('=');let key=part[0];if(key==arg&&part[1]!=undefined){route=part[1];}
else{url_args[key]=part[1];}}
return{fancy:false,'route':route,'args':url_args};}
extractRouteName(href){let router_default=this.contentWrapperElement().getAttribute('data-router-default');if(href.substr(0,4)=='http'){href=href.substr(8);let qmark_i=href.indexOf('?');let slash_i=href.indexOf('/');if(qmark_i==-1&&slash_i==-1){href=router_default;}
else if(qmark_i==-1||slash_i<qmark_i){href=href.substr(slash_i);}
else if(slash_i==-1||qmark_i<slash_i){href=href.substr(qmark_i);}
else{href=router_default;}}
if(href.substr(0,1)=='?'){href=href.substr(1);return this.dispatchQuery(href);}
if(href.substr(0,1)=='/'){href=href.substr(1);}
href=href.split('?');let url_args=href[1];if(url_args!=undefined){url_args=this.dispatchQuery(url_args).args;}
else{url_args={};}
let route_parts=href[0].split('/');let route=route_parts[0];if(route==''){route=router_default;}
return{fancy:true,'route':route,'args':url_args};}
joinUrlArgs(route,args,fancy){let out='?';if(!fancy){let arg=this.contentWrapperElement().getAttribute('data-router-arg');out+=arg+'='+route+'&';}
Object.keys(args).forEach((a)=>{out+=a+'='+args[a]+'&';});if(fancy){out=route+out;}
return out.slice(0,-1);}
redirected(to_route){let href=this.extractRouteName(window.location.href);this.current_route=to_route;history.pushState(null,null,this.joinUrlArgs(to_route,href.args,href.fancy));}
navigationOccured(event){let href=this.extractRouteName(window.location.pathname).route;if(hcf.web.PageLoader.pageFqnForRoute(href)!=null){this.loadPage(href);}}
routerLinkClicked(event){event.preventDefault();let href=null;if(!event.target.hasAttribute('href')){let link_lookup=event.target.closest('a[href]');if(link_lookup==null){throw'cannot determine route for '+this._link_class+' element '+event.target;}
href=link_lookup.getAttribute('href');}
else{href=event.target.getAttribute('href');}
let parts=this.extractRouteName(href);history.pushState(null,null,this.joinUrlArgs(parts.route,parts.args,parts.fancy));this.loadPage(parts.route);}
topLoaderElement(){return this.shadowRoot.querySelector('.top-loader');}
contentWrapperElement(){return this.shadowRoot.getElementById('content-wrapper');}
reload(){let route_name=this.current_route;if(this.error_page_active||this.current_page==undefined||this.current_page==null){route_name=this.extractRouteName(window.location.pathname);}
else{if(route_name==null){route_name=this.extractRouteName(window.location.pathname);}
let me=hcf.web.PageLoader;let fqn=this.current_page;me.cache(fqn,false);}
this.hideContainer();this.loadPage(route_name);}
loadPage(route_name){if(route_name==undefined||route_name==null||route_name.trim()==''){throw'Invalid route '+route_name+' given.';}
if(this.current_request!=null){console.warn('a page-request was already running and will be aborted.');this.current_request.abort();this.current_request=null;}
this.hideContainer();this.resetTopLoader()
this.current_route=route_name;let me=hcf.web.PageLoader;let page_fqn=me.pageFqnForRoute(route_name);let e=new Event('page-load-begin',{bubbles:true});this.dispatchEvent(e);if(page_fqn!=null){let cached_page=me.cache(page_fqn);if(cached_page!=null&&cached_page!==false){this.documentReady(route_name,cached_page,true);return;}}
this.loadPageFromServer(route_name);}
loadPageFromServer(route_name){let me=this.contentWrapperElement().getAttribute('data-me');hcf.web.Bridge(me).invoke('load').do({arguments:[route_name,hcf.web.PageLoader._map],timeout:0,onBefore:(xhr)=>{this.current_request=xhr},onUpload:(e)=>this.setTopLoaderProgress((e.loaded / e.total*100)*.25),onProgress:(e)=>{this.setTopLoaderProgress(((e.loaded /(e.lengthComputable?e.total:e.loaded)*100)*.25)+25)},onSuccess:(data)=>this.preloadDependencies(route_name,data),onError:(msg,code)=>this.displayError(code,msg),onTimeout:(code,msg)=>this.displayError(code,msg)});}
hideContainer(){this.contentWrapperElement().classList.add('loading');}
showContainer(){this.contentWrapperElement().classList.remove('loading');}
resetTopLoader(){this.setTopLoaderColor(this._loader_color);this.topLoaderElement().style.width=0;}
getTopLoaderProgress(){return Number(this.topLoaderElement().style.width.replace('%',''));}
setTopLoaderProgress(to){this.topLoaderElement().style.width=to+'%';}
setTopLoaderColor(to){this.topLoaderElement().style.background=to;}
unloadCurrentPage(){if(this.initial_page_unloaded!==true){this.innerHTML='';this.initial_page_unloaded=true;return;}
if(this.error_page_active===true){this.error_page_active=false;this.page_error_fragment=this.removeChild(this.page_error_fragment);this.current_route=null;this.current_page=null;return;}
let me=hcf.web.PageLoader;let fqn=this.current_page;let c=me.cache(fqn);let store=document.createElement('div');let children=this.children;let clone=[];for(let i in children){let e=children[i];if(e instanceof hcf.web.Page){clone.push(e);}}
clone.forEach((page)=>{page.beforeUnload();store.appendChild(this.removeChild(page));});if(c===false){}
else{if(c!=null){c.view=store;}
me.cache(fqn,c);}
this.current_route=null;this.current_page=null;}
wasCached(route_name,o){if(o.is_cached_as!=undefined){let me=hcf.web.PageLoader;let cached_page=me.cache(o.is_cached_as);if(cached_page!=null){me.addToMap(route_name,o.is_cached_as);this.documentReady(route_name,cached_page,true);return true;}
else{throw'missing cache data.';}}
return false;}
preloadDependencies(route_name,data){this.current_request=null;let o=JSON.parse(data);if(this.wasCached(route_name,o)){return;}
if(o.preload!=undefined){let me=hcf.web.PageLoader;let preload_data=o.preload;let preload_promises=[];let loaded_dependencies=[];for(let component_context in o.preload){let components=o.preload[component_context];if(components.length==0){continue;}
let load=[];components.forEach((dependency)=>{if(me._loaded_dependencies.indexOf(dependency)==-1){if(load.indexOf(dependency)==-1){load.push(dependency);}
loaded_dependencies.push(dependency);}});if(load.length==0){continue;}
let context_promises=hcf.web.Component.loadDependencies(load,(component_context=='global')?undefined:component_context);preload_promises=preload_promises.concat(context_promises);}
if(preload_promises.length>0){let part=48 / preload_promises.length;for(var i in preload_promises){let cp=preload_promises[i];cp.then(()=>{this.setTopLoaderProgress(this.getTopLoaderProgress()+part);});}}
Promise.all(preload_promises).catch((e)=>this.displayError(e,'Preloading resources failed.')).then(()=>{me._loaded_dependencies=me._loaded_dependencies.concat(loaded_dependencies);this.documentReady(route_name,o);});}
else{this.documentReady(route_name,o);}}
documentReady(route_name,o,from_cache){try{this.unloadCurrentPage();let page_elem=this.addView(o);this.showContainer();this.setTopLoaderProgress(99);if(o.redirect!=undefined){this.redirected(o.redirect);}
if(from_cache===true){page_elem.cacheReload(page_elem);}
else{let me=hcf.web.PageLoader;if(page_elem.cache()){me.cache(o.which,o);me.addToMap(route_name,o.which);}
else{me.cache(o.which,false);}}
this.current_page=o.which;this.setTopLoaderProgress(100);let event=new Event('page-load-success',{bubbles:true});this.dispatchEvent(event);}
catch(e){this.displayError(0,'Failed on initialisation: '+e);}}
addView(view_data){let view=view_data.view;let which=view_data.which;let rendered=view_data.rendered;this.contentWrapperElement().style.opacity=0;if(view instanceof HTMLElement){let children=view.children;let clone=[];for(var i in children){if(children[i]instanceof hcf.web.Page){clone.push(children[i]);}}
clone.forEach((e)=>{this.appendChild(view.removeChild(e));});}
else{this.innerHTML=view;let page_elem=this.firstChild;if(!(page_elem instanceof hcf.web.Page)){throw'given element is no hcf.web.Page instance';}
if(rendered!=undefined){page_elem.injectView(rendered,which);}
this.initRouterLinks();}
this.contentWrapperElement().style.opacity=null;return this.firstChild;}
displayErrorPage(){this.unloadCurrentPage();this.error_page_active=true;if(this.page_error_fragment!=undefined&&this.page_error_fragment!=null){this.appendChild(this.page_error_fragment);}}
displayError(code,msg){this.current_request=null;this.setTopLoaderColor(this._loader_color_error);this.displayErrorPage();this.showContainer();console.error('Loading failed: Error ',code,msg);let event=new Event('page-load-failed',{bubbles:true});this.dispatchEvent(event);}}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    static public function template() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "<div class=\"primary-border top-loader\" part=\"loader\">&nbsp;</div>";
        $output.= "<div data-me=\"{$__CLASS__::_constant('FQN', $__CLASS__, $_this) }\" data-router-default=\"{$__CLASS__::_call('routerDefault', $__CLASS__, $_this) }\" data-router-arg=\"{$__CLASS__::_call('routerArg', $__CLASS__, $_this) }\" id=\"content-wrapper\" part=\"wrapper\">";
        $output.= "<slot class=\"error-fragment\" name=\"error\"></slot>";
        $output.= "<slot class=\"main-fragment initialized\"></slot>";
        $output.= "</div>";
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME VIEW.HTML
    # BEGIN ASSEMBLY FRAME VIEW.SCSS
    public static function style($as_array = false) {
        if ($as_array) {
            return self::makeStylesheetArray();
        }
        return '.primary-border{border:none !important;height:3px;width:100%;display:block;z-index:9999;position:absolute;top:0;left:0;right:0;transition-property:width;transition-duration:0.2s}#content-wrapper{transition-property:opacity;transition-duration:0.5s}#content-wrapper.loading{opacity:0.5;pointer-events:none;user-select:none}#content-wrapper:not(.loading){opacity:1}slot:not(.initialized){display:none}';
    }
    # END ASSEMBLY FRAME VIEW.SCSS
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    static public function elementName() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "page-loader";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcf\web\PageLoader\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils;
    use \hcf\web\Router;
    use \hcf\web\Page;
    trait Controller {
        public static function load($route, $cache_map, $arguments = null) {
            $cache_map = json_decode($cache_map);
            $route = htmlspecialchars($route);
            list($target, $chosen_route) = Router::routeSectionTarget($route, true);
            if (!is_subclass_of($target, Page::class)) {
                throw new \Exception(self::FQN . ' - ' . $target::FQN . ' is no hcf.web.Page instance.');
            }
            $fqn = $target::FQN;
            $out = new \stdClass();
            if ($chosen_route != $route) {
                $out->redirect = $chosen_route;
            } else if (isset($cache_map->{$fqn})) // no caching on redirects
            {
                $out->is_cached_as = $fqn;
                return json_encode($out);
            }
            $out = self::applyPreloads($out, $fqn);
            $out->which = $fqn;
            $out->view = $target::wrappedElementName(false); // disable autoload to render instance below and add it later (one request less per page and only hcf.web.PageLoader must be add to hcf.web.Bridge config)
            $instance = new $target($arguments);
            $out->rendered = $instance->toString();
            return json_encode($out);
        }
        private static function routerDefault() {
            return Router::config()->default;
        }
        private static function routerArg() {
            return Router::config()->arg;
        }
        private static function applyPreloads($out, $fqn) {
            $c = self::config();
            if (isset($c->{$fqn})) {
                $out->preload = $c->{$fqn};
                if (is_array($out->preload)) // shorthand if no context except global is required
                {
                    $old = $out->preload;
                    $out->preload = new \stdClass();
                    $out->preload->global = $old;
                }
                if (isset($out->preload->{'//'})) {
                    unset($out->preload->{'//'}); // remove comment
                    
                }
                if (!isset($out->preload->global)) {
                    $out->preload->global = [];
                }
                array_unshift($out->preload->global, $fqn);
            } else {
                $out->preload = new \stdClass();
                $out->preload->global = [$fqn];
            }
            return $out;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__
BEGIN[CONFIG.JSON]
{
	"//": "Additional resources per Page (page = hcf.web.Component Hypercell that provides a dynamic view)",
	"my.Hypercell": { 
		"//": "key = ComponentContext id, if resource should be defined in a component-context, global = light DOM",
		"global": ["my.additionialResource.Global"],
		"ui-elements": ["my.additional.WebComponent"]
	},
	"gax.web.page.retailer.Home": ["my.global.Resource", "this.is.an.alias.for.componentContext.global"]
}
END[CONFIG.JSON]

?>
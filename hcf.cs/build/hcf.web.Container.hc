<?php #HYPERCELL hcf.web.Container - BUILD 22.03.18#75
namespace hcf\web;
class Container {
    use \hcf\core\dryver\Config, \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, Container\__EO__\Controller, Container\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\View\Css, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container';
    const NAME = 'Container';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfwebContainer_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcfwebContainer_onConstruct_Controller'], func_get_args());
        }
        if (method_exists($this, 'hcfwebContainer_onConstruct_Model')) {
            call_user_func_array([$this, 'hcfwebContainer_onConstruct_Model'], func_get_args());
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
        $js = "if(document.componentMap==undefined){document.componentMap={}};if(document.componentStyleMap==undefined){document.componentStyleMap=[]};window.addEventListener('DOMContentLoaded',function(){document.APP_VERSION=document.querySelector('html').getAttribute('data-version');let utils=hcf.web.Utils;utils.registerCursorMoved();utils.registerMd5Module(utils);utils.extendHTMLElements();});document.importFontList=function(){if(document.importedFontsList!=undefined){return document.importedFontsList;}
document.importedFontsList=[];document.head.querySelectorAll('.container-font').forEach((f)=>{let css=new CSSStyleSheet();for(let i in f.sheet.cssRules){let rule=f.sheet.cssRules[i];if(rule.cssText!=undefined){css.insertRule(rule.cssText);}}
document.importedFontsList.push(css);});return document.importedFontsList;};document.exportStylesheet=function(css,context_id){if(context_id=='global'||context_id==''||!context_id){return;}
let context=document.getElementById(context_id);if(!context.hasAttribute('data-global')||context.getAttribute('data-global')!='true'){context=null;context_id=null;css=null;return;}
let es=document.createElement('style');es.setAttribute('type','text/css');es.classList.add('style-global');let body='';for(let i in css.cssRules){let rule=css.cssRules[i];if(rule.cssText!=undefined){body+=rule.cssText;}}
es.innerText=body;document.head.appendChild(es);context=null;context_id=null;css=null;};document.registerComponentController=function(hcfqn,controller_class,as_element,element_options){var prop_hcfqn=hcfqn;let target=document.objectByHcfqn(hcfqn);if(target==null){var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();var prop_name=hcfqn;for(var i in split){var part=split[i];if(!scope[part]){scope[part]={};}
scope=scope[part];}
if(controller_class.prototype!=undefined){controller_class.prototype.FQN=prop_hcfqn;controller_class.prototype.NAME=prop_name;}
target=scope[hcfqn]=controller_class;}
if(as_element!=undefined&&as_element!=null){if(element_options==undefined){element_options={};}
if(customElements.get(as_element)==undefined){if(target.prototype instanceof hcf.web.Component||(target.prototype instanceof HTMLElement&&element_options.extends!=undefined)){customElements.define(as_element,target,element_options);}
else{throw prop_hcfqn+' client-controller of '+prop_hcfqn+' must extend hcf.web.Component if elementName is given or use element_options.extend to extend another hcf.web.Component.';}}}
target=null;hcfqn=null;prop_hcfqn=null;controller_class=null;as_element=null;element_options=null;};document.objectByHcfqn=function(hcfqn){var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();for(var i in split){var part=split[i];if(!scope[part]){return null;}
scope=scope[part];}
if(scope[hcfqn]!=undefined){let expo=scope[hcfqn];scope=null;return expo;}
else{scope=null;return null;}};document.cloneRenderContext=function(which,register_to_fqn){if(which=='global'||which==''){throw'global render context cannot be cloned.';}
let clone_cc=document.getElementById(which);if(clone_cc==null){throw'render context '+which+' does not exist.';}
if(register_to_fqn==undefined||register_to_fqn==null||register_to_fqn==''){throw'render context cannot be registered without fqn';}
let dyn_cc='dyncc-'+register_to_fqn.replace(/\./g,'-').toLowerCase();let ecc=document.getElementById(dyn_cc);if(ecc!=null){return ecc;}
let registered_to=document.componentMap[register_to_fqn];if(registered_to!=undefined&&registered_to!=dyn_cc){console.warn('component '+register_to_fqn+' was already registered to context '+registered_to);}
let new_cc=clone_cc.cloneNode(true);new_cc.setAttribute('id',dyn_cc);document.componentMap[register_to_fqn]=dyn_cc;document.head.appendChild(new_cc);let base_styles=document.componentStyleMap[which];let cloned=[];if(base_styles==undefined){base_styles=[];}
document.componentStyleMap[dyn_cc]=base_styles.map((s)=>s);return new_cc;};(function(){'use strict';if(typeof document==='undefined'||'adoptedStyleSheets'in document){return;}
var hasShadyCss='ShadyCSS'in window&&!ShadyCSS.nativeShadow;var bootstrapper=document.implementation.createHTMLDocument('');var closedShadowRootRegistry=new WeakMap();var _DOMException=typeof DOMException==='object'?Error:DOMException;var defineProperty=Object.defineProperty;var forEach=Array.prototype.forEach;var importPattern=/@import.+?;?\$/gm;function rejectImports(contents){var _contents=contents.replace(importPattern,'');if(_contents!==contents){console.warn('@import rules are not allowed here. See https://github.com/WICG/construct-stylesheets/issues/119#issuecomment-588352418');}
return _contents.trim();}
function isElementConnected(element){return'isConnected'in element?element.isConnected:document.contains(element);}
function unique(arr){return arr.filter(function(value,index){return arr.indexOf(value)===index;});}
function diff(arr1,arr2){return arr1.filter(function(value){return arr2.indexOf(value)===-1;});}
function removeNode(node){node.parentNode.removeChild(node);}
function getShadowRoot(element){return element.shadowRoot||closedShadowRootRegistry.get(element);}
var cssStyleSheetMethods=['addRule','deleteRule','insertRule','removeRule',];var NonConstructedStyleSheet=CSSStyleSheet;var nonConstructedProto=NonConstructedStyleSheet.prototype;nonConstructedProto.replace=function(){return Promise.reject(new _DOMException(\"Can't call replace on non-constructed CSSStyleSheets.\"));};nonConstructedProto.replaceSync=function(){throw new _DOMException(\"Failed to execute 'replaceSync' on 'CSSStyleSheet': Can't call replaceSync on non-constructed CSSStyleSheets.\");};function isCSSStyleSheetInstance(instance){return typeof instance==='object'?proto\$1.isPrototypeOf(instance)||nonConstructedProto.isPrototypeOf(instance):false;}
function isNonConstructedStyleSheetInstance(instance){return typeof instance==='object'?nonConstructedProto.isPrototypeOf(instance):false;}
var \$basicStyleElement=new WeakMap();var \$locations=new WeakMap();var \$adoptersByLocation=new WeakMap();var \$appliedMethods=new WeakMap();function addAdopterLocation(sheet,location){var adopter=document.createElement('style');\$adoptersByLocation.get(sheet).set(location,adopter);\$locations.get(sheet).push(location);return adopter;}
function getAdopterByLocation(sheet,location){return \$adoptersByLocation.get(sheet).get(location);}
function removeAdopterLocation(sheet,location){\$adoptersByLocation.get(sheet).delete(location);\$locations.set(sheet,\$locations.get(sheet).filter(function(_location){return _location!==location;}));}
function restyleAdopter(sheet,adopter){requestAnimationFrame(function(){adopter.textContent=\$basicStyleElement.get(sheet).textContent;\$appliedMethods.get(sheet).forEach(function(command){return adopter.sheet[command.method].apply(adopter.sheet,command.args);});});}
function checkInvocationCorrectness(self){if(!\$basicStyleElement.has(self)){throw new TypeError('Illegal invocation');}}
function ConstructedStyleSheet(){var self=this;var style=document.createElement('style');bootstrapper.body.appendChild(style);\$basicStyleElement.set(self,style);\$locations.set(self,[]);\$adoptersByLocation.set(self,new WeakMap());\$appliedMethods.set(self,[]);}
var proto\$1=ConstructedStyleSheet.prototype;proto\$1.replace=function replace(contents){try{this.replaceSync(contents);return Promise.resolve(this);}
catch(e){return Promise.reject(e);}};proto\$1.replaceSync=function replaceSync(contents){checkInvocationCorrectness(this);if(typeof contents==='string'){var self_1=this;\$basicStyleElement.get(self_1).textContent=rejectImports(contents);\$appliedMethods.set(self_1,[]);\$locations.get(self_1).forEach(function(location){if(location.isConnected()){restyleAdopter(self_1,getAdopterByLocation(self_1,location));}});}};defineProperty(proto\$1,'cssRules',{configurable:true,enumerable:true,get:function cssRules(){checkInvocationCorrectness(this);return \$basicStyleElement.get(this).sheet.cssRules;},});defineProperty(proto\$1,'media',{configurable:true,enumerable:true,get:function media(){checkInvocationCorrectness(this);return \$basicStyleElement.get(this).sheet.media;},});cssStyleSheetMethods.forEach(function(method){proto\$1[method]=function(){var self=this;checkInvocationCorrectness(self);var args=arguments;\$appliedMethods.get(self).push({method:method,args:args});\$locations.get(self).forEach(function(location){if(location.isConnected()){var sheet=getAdopterByLocation(self,location).sheet;sheet[method].apply(sheet,args);}});var basicSheet=\$basicStyleElement.get(self).sheet;return basicSheet[method].apply(basicSheet,args);};});defineProperty(ConstructedStyleSheet,Symbol.hasInstance,{configurable:true,value:isCSSStyleSheetInstance,});var defaultObserverOptions={childList:true,subtree:true,};var locations=new WeakMap();function getAssociatedLocation(element){var location=locations.get(element);if(!location){location=new Location(element);locations.set(element,location);}
return location;}
function attachAdoptedStyleSheetProperty(constructor){defineProperty(constructor.prototype,'adoptedStyleSheets',{configurable:true,enumerable:true,get:function(){return getAssociatedLocation(this).sheets;},set:function(sheets){getAssociatedLocation(this).update(sheets);},});}
function traverseWebComponents(node,callback){var iter=document.createNodeIterator(node,NodeFilter.SHOW_ELEMENT,function(foundNode){return getShadowRoot(foundNode)?NodeFilter.FILTER_ACCEPT:NodeFilter.FILTER_REJECT;},null,false);for(var next=void 0;(next=iter.nextNode());){callback(getShadowRoot(next));}}
var \$element=new WeakMap();var \$uniqueSheets=new WeakMap();var \$observer=new WeakMap();function isExistingAdopter(self,element){return(element instanceof HTMLStyleElement&&\$uniqueSheets.get(self).some(function(sheet){return getAdopterByLocation(sheet,self);}));}
function getAdopterContainer(self){var element=\$element.get(self);return element instanceof Document?element.body:element;}
function adopt(self){var styleList=document.createDocumentFragment();var sheets=\$uniqueSheets.get(self);var observer=\$observer.get(self);var container=getAdopterContainer(self);observer.disconnect();sheets.forEach(function(sheet){styleList.appendChild(getAdopterByLocation(sheet,self)||addAdopterLocation(sheet,self));});container.insertBefore(styleList,null);observer.observe(container,defaultObserverOptions);sheets.forEach(function(sheet){restyleAdopter(sheet,getAdopterByLocation(sheet,self));});}
function Location(element){var self=this;self.sheets=[];\$element.set(self,element);\$uniqueSheets.set(self,[]);\$observer.set(self,new MutationObserver(function(mutations,observer){if(!document){observer.disconnect();return;}
mutations.forEach(function(mutation){if(!hasShadyCss){forEach.call(mutation.addedNodes,function(node){if(!(node instanceof Element)){return;}
traverseWebComponents(node,function(root){getAssociatedLocation(root).connect();});});}
forEach.call(mutation.removedNodes,function(node){if(!(node instanceof Element)){return;}
if(isExistingAdopter(self,node)){adopt(self);}
if(!hasShadyCss){traverseWebComponents(node,function(root){getAssociatedLocation(root).disconnect();});}});});}));}
Location.prototype={isConnected:function(){var element=\$element.get(this);return element instanceof Document?element.readyState!=='loading':isElementConnected(element.host);},connect:function(){var container=getAdopterContainer(this);\$observer.get(this).observe(container,defaultObserverOptions);if(\$uniqueSheets.get(this).length>0){adopt(this);}
traverseWebComponents(container,function(root){getAssociatedLocation(root).connect();});},disconnect:function(){\$observer.get(this).disconnect();},update:function(sheets){var self=this;var locationType=\$element.get(self)===document?'Document':'ShadowRoot';if(!Array.isArray(sheets)){throw new TypeError(\"Failed to set the 'adoptedStyleSheets' property on \"+locationType+\": Iterator getter is not callable.\");}
if(!sheets.every(isCSSStyleSheetInstance)){throw new TypeError(\"Failed to set the 'adoptedStyleSheets' property on \"+locationType+\": Failed to convert value to 'CSSStyleSheet'\");}
if(sheets.some(isNonConstructedStyleSheetInstance)){throw new TypeError(\"Failed to set the 'adoptedStyleSheets' property on \"+locationType+\": Can't adopt non-constructed stylesheets\");}
self.sheets=sheets;var oldUniqueSheets=\$uniqueSheets.get(self);var uniqueSheets=unique(sheets);var removedSheets=diff(oldUniqueSheets,uniqueSheets);removedSheets.forEach(function(sheet){removeNode(getAdopterByLocation(sheet,self));removeAdopterLocation(sheet,self);});\$uniqueSheets.set(self,uniqueSheets);if(self.isConnected()&&uniqueSheets.length>0){adopt(self);}},};window.CSSStyleSheet=ConstructedStyleSheet;attachAdoptedStyleSheetProperty(Document);if('ShadowRoot'in window){attachAdoptedStyleSheetProperty(ShadowRoot);var proto=Element.prototype;var attach_1=proto.attachShadow;proto.attachShadow=function attachShadow(init){var root=attach_1.call(this,init);if(init.mode==='closed'){closedShadowRootRegistry.set(this,root);}
return root;};}
var documentLocation=getAssociatedLocation(document);if(documentLocation.isConnected()){documentLocation.connect();}
else{document.addEventListener('DOMContentLoaded',documentLocation.connect.bind(documentLocation));}}());";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    public function __toString() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "{$__CLASS__::_call('docType', $__CLASS__, $_this) }";
        $output.= "<html lang=\"{$__CLASS__::_property('content_language', $__CLASS__, $_this) }\" data-version=\"{$__CLASS__::_call('appVersion', $__CLASS__, $_this) }\">";
        $output.= "<head>";
        $output.= "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=Edge\"/>";
        $output.= "<meta charset=\"{$__CLASS__::_property('encoding', $__CLASS__, $_this) }\"/>";
        $output.= "<title>{$__CLASS__::_property('title', $__CLASS__, $_this) }</title>";
        $output.= "<base href=\"{$__CLASS__::_property('base_href', $__CLASS__, $_this) }\"/>";
        $output.= "<link rel=\"icon\" type=\"{$__CLASS__::_property('fav_mimetype', $__CLASS__, $_this) }\" href=\"{$__CLASS__::_property('fav_path', $__CLASS__, $_this) }\"/>";
        foreach ($__CLASS__::_property('meta_http_equiv', $__CLASS__, $_this) as $metaname => $typearr) {
            foreach ($typearr as $val) {
                $output.= "<meta http-equiv=\"$metaname\" content=\"$val\"/>";
            }
        }
        foreach ($__CLASS__::_property('meta_name', $__CLASS__, $_this) as $metaname => $typearr) {
            foreach ($typearr as $val) {
                $output.= "<meta name=\"$metaname\" content=\"$val\"/>";
            }
        }
        foreach ($__CLASS__::_property('ext_js', $__CLASS__, $_this) as $src) {
            $output.= "<script type=\"text/javascript\" src=\"$src\"></script>";
        }
        $output.= "<style id=\"reset\">{$__CLASS__::_call('ownStyle', $__CLASS__, $_this) }</style>";
        foreach ($__CLASS__::_property('ext_css', $__CLASS__, $_this) as $href => $media) {
            $output.= "<link rel=\"stylesheet\" type=\"text/css\" href=\"$href\" media=\"$media\"/>";
        }
        foreach ($__CLASS__::_property('emb_js', $__CLASS__, $_this) as $emb_js_str) {
            $output.= "<script language=\"javascript\">$emb_js_str</script>";
        }
        foreach ($__CLASS__::_property('emb_css', $__CLASS__, $_this) as $emb_css_str) {
            $output.= "<style>$emb_css_str</style>";
        }
        $output.= "<script language=\"javascript\">{$__CLASS__::_call('ownScript', $__CLASS__, $_this) }</script>";
        foreach ($__CLASS__::_property('render_contexts', $__CLASS__, $_this) as $render_context) {
            $output.= "$render_context";
        }
        foreach ($__CLASS__::_property('fonts', $__CLASS__, $_this) as $path) {
            $output.= "<link rel=\"stylesheet\" class=\"container-font\" href=\"$path\"/>";
        }
        $output.= "<style id=\"default-font\">body { font-family:'{$__CLASS__::_property('font_family', $__CLASS__, $_this) }'!important; font-size:{$__CLASS__::_property('font_size', $__CLASS__, $_this) }!important;}</style>";
        $output.= "{$__CLASS__::_call('autoloader', $__CLASS__, $_this) }";
        $output.= "</head>";
        $output.= "<body>{$__CLASS__::_call('renderContent', $__CLASS__, $_this) }</body>";
        $output.= "</html>";
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME VIEW.HTML
    # BEGIN ASSEMBLY FRAME VIEW.SCSS
    public static function style($as_array = false) {
        if ($as_array) {
            return self::makeStylesheetArray();
        }
        return 'html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,details,embed,figure,figcaption,footer,header,hgroup,menu,nav,output,ruby,section,summary,time,mark,audio,video{margin:0;padding:0;border:0;font-size:100%;font:inherit;vertical-align:baseline}article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:"";content:none}table{border-collapse:collapse;border-spacing:0}*:focus,*:visited,*:active,*:hover{outline:0 !important}*::-moz-focus-inner{border:0}select:-moz-focusring{color:transparent;text-shadow:0 0 0 #000}head>div[id]{display:none}';
    }
    # END ASSEMBLY FRAME VIEW.SCSS
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    private function docType() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "<!DOCTYPE html>";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcf\web\Container\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        protected static $_ARGS = null; //$_GET parameter
        public function hcfwebContainer_onConstruct_Controller() {
            self::initUrlArgs();
        }
        public static function initUrlArgs($with = null) {
            if (is_null($with)) {
                $with = $_GET;
            }
            if (isset($with) && is_array($with)) {
                static ::$_ARGS = $with;
            } else {
                static ::$_ARGS = [];
            }
        }
        protected function argument($name, $value = null) {
            return static ::urlArg($name, $value);
        }
        public static function urlArg($name, $value = null) {
            if (is_null(static ::$_ARGS)) {
                static ::initUrlArgs();
            }
            if (!isset($value)) {
                if (isset(static ::$_ARGS[$name])) {
                    return filter_var(static ::$_ARGS[$name], FILTER_SANITIZE_STRING);
                } else {
                    return null;
                }
            } else {
                static ::$_ARGS[$name] = filter_var(static ::$_ARGS[$name], FILTER_SANITIZE_STRING);
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\web\RenderContext;
    use \hcf\web\Controller as WebController;
    use \hcf\web\Component;
    use \hcf\web\Bridge;
    use \hcf\web\PageLoader;
    use \hcf\web\Page;
    use \hcf\web\Utils as WebUtils;
    /**
     * Server
     * This is the HTML-container from the raw-merge framework
     *
     * @category HTML
     * @package web.browser.container
     * @author Philipp Kopf
     * @version 1.0.0
     */
    trait Model {
        protected $title = self::FQN;
        protected $content_language = 'en';
        protected $content = 'No content set.';
        protected $ext_js = [];
        protected $emb_js = [];
        protected $ext_css = [];
        protected $emb_css = [];
        protected $encoding = 'utf-8';
        protected $font_family = 'arial';
        protected $font_size = 12; //px
        protected $fav_mimetype = '';
        protected $fav_path = '';
        protected $meta_http_equiv = [];
        protected $meta_name = [];
        protected $autoloading = false;
        protected $render_contexts = [];
        protected $base_href = '/';
        protected static $fonts = [];
        /**
         * __construct
         *
         */
        public function hcfwebContainer_onConstruct_Model() {
            $config = self::config();
            if (isset($config)) {
                if (isset($config->{'default-font'}) && is_object($config->{'default-font'})) {
                    $this->font($config->{'default-font'}->family);
                    $this->fontSize($config->{'default-font'}->size);
                }
                if (isset($config->{'enable-autoloader'}) && is_bool($config->{'enable-autoloader'})) {
                    $this->autoloading = $config->{'enable-autoloader'};
                }
                if (isset($config->encoding) && is_string($config->encoding)) {
                    $this->encoding($config->encoding);
                }
                if (isset($config->{'fav-icon'}) && is_string($config->{'fav-icon'})) {
                    $this->favicon($config->{'fav-icon'});
                }
                if (isset($config->{'base'}) && is_string($config->{'base'})) {
                    $this->base($config->{'base'});
                }
                if (isset($config->fonts) && is_array($config->fonts)) {
                    $this->initFonts($config->fonts);
                }
            }
            $cc = new RenderContext('core');
            $cc->register(WebController::class);
            $cc->register(Component::class);
            $cc->register(Component\Polyfill::class);
            $cc->register(Bridge::class);
            $cc->register(PageLoader::class);
            $cc->register(Page::class);
            $cc->register(WebUtils::class);
            $this->registerRenderContext($cc);
        }
        private static function initFonts($font_arr) {
            if (!is_array($font_arr)) {
                return;
            }
            $out = [];
            foreach ($font_arr as $font_stylesheet) {
                if (substr($font_stylesheet, 0, 1) != '/') {
                    $out[] = HCF_SHARED . $font_stylesheet; // prepend HCF_SHARED if given path is relative
                    
                } else {
                    $out[] = $font_stylesheet;
                }
            }
            self::$fonts = $out;
        }
        public static function loadedFonts() {
            return self::$fonts;
        }
        /**
         * title
         * Set the title of your Browser-Tab/-Window
         *
         * @param $title - string - the title you want to display
         *
         * @throws RuntimeException
         * @return void
         */
        public function title($title) {
            if (!isset($title) || !is_string($title)) {
                throw new \RuntimeException('Argument $title for "' . self::FQN . '::title($title)" is not a valid string.');
            }
            $this->title = $title;
        }
        /**
         * font
         * Set the font of this document
         *
         * @param $font_family - string - the name of the font you want to use
         *
         * @throws RuntimeException
         * @return void
         */
        public function font($font_family) {
            if (!isset($font_family) || !is_string($font_family)) {
                throw new \RuntimeException('Argument $font_family for "' . self::FQN . '::font($font_family)" is not a valid string.');
            }
            $this->font_family = $font_family;
        }
        /**
         * fontSize
         * Set the base-font-size of this document
         *
         * @param $font_size - int - the font-size in pixels to use across the document
         *
         * @throws RuntimeException
         * @return void
         */
        public function fontSize($font_size = 12) {
            if (!isset($font_size)) {
                throw new \RuntimeException('Argument $font_size for "' . self::FQN . '::fontSize($font_size)" is not set');
            }
            $this->font_size = $font_size;
        }
        /**
         * content
         * Set the content between the <body></body> tags
         *
         * @param $content - string - the content you want to display
         *
         * @throws RuntimeException
         * @return void
         */
        public function content($content) {
            if (!isset($content) || !is_string($content)) {
                throw new \RuntimeException('Argument $content for "' . self::FQN . '::content($content)" is not a valid string.');
            }
            $this->content = $content;
        }
        /**
         * linkScript
         * Add an external javascript-resource you want to load inside the head of this container
         *
         * @param $url - string - the URL, where the external script is located
         *
         * @return void
         */
        public function linkScript($url) {
            $this->ext_js[] = $url;
        }
        /**
         * embedScript
         * Embed a javascript-string directly into the head of this container
         *
         * @param $js_data - string - the Javascript-string, which will be embedded to the head
         *
         * @throws RuntimeException
         * @return void
         */
        public function embedScript($js_data) {
            if (!is_string($js_data)) {
                throw new \RuntimeException('Argument $js_data for "' . self::FQN . '::embedScript($js_data)" is not a valid string.');
            }
            $this->emb_js[] = $js_data;
        }
        /**
         * linkStylesheet
         * Add an external stylesheet-resource you want to load inside the head of this container
         *
         * @param $url - string - the URL, where the external stylesheet is located
         * @param $media - string - specifies, for what media/device the target resource is optimized for
         *
         * @return void
         */
        public function linkStylesheet($url, $media = null) {
            $this->ext_css[$url] = (isset($media)) ? $media : '';
        }
        /**
         * embedStylesheet
         * Embed a stylesheet-string directly into the head of this container
         *
         * @param $css_data - string - the stylesheet-string, which will be embedded to the head
         *
         * @throws RuntimeException
         * @return void
         */
        public function embedStylesheet($css_data) {
            if (!is_string($css_data)) {
                throw new \RuntimeException('Argument $css_data for "' . self::FQN . '::embedScript($css_data)" is not a valid string.');
            }
            $this->emb_css[] = $css_data;
        }
        /**
         * contentLanguage
         *
         *
         * @param $lang - string - the value that will be used as lang-attribute on the HTML-element
         *
         * @return
         */
        public function contentLanguage($lang = null) {
            if (is_null($lang)) {
                return $this->content_language;
            }
            if (!is_string($lang)) {
                throw new \RuntimeException(self::FQN . ' - invalid content-language value passed; not a string');
            }
            $this->content_language = $lang;
        }
        /**
         * meta
         * Add a meta-tag to the head of the container
         *
         * @param $name - string - Value, which will be written inside meta-tags "name" attribute
         * @param $value - string - This will be inserted into the "content" attribute of the meta-tag
         * @param $http_equiv - boolean - If true, the "name" attribute will be changed into "http-equiv"
         *
         * @return void
         */
        public function meta($name, $value, $http_equiv = false) {
            if ($http_equiv) {
                $this->meta_http_equiv[$name][] = $value;
            } else {
                $this->meta_name[$name][] = $value;
            }
        }
        /**
         * encoding
         * Set the encoding of your page
         *
         * @param $encoding - string - the encoding, this page is using
         *
         * @return void
         */
        public function encoding($encoding) {
            $this->encoding = $encoding;
        }
        /**
         * favicon
         * Adds a fav-icon to your browser-window
         *
         * @param $image_path - string - the path to the fav-icon, you want to use
         *
         * @return void
         */
        public function favicon($image_path) {
            $this->fav_mimetype = Utils::getMimeTypeByExtension($image_path);
            $this->fav_path = $image_path;
        }
        public function base($base_url) {
            $this->base_href = $base_url;
        }
        /**
         * fqn
         *
         * @return self::FQN
         */
        public function fqn() {
            return self::FQN;
        }
        /**
         * autoloader
         * Loads the Autoloader - if enabled (over the constructor of this instance)
         *
         * @return string - Autoloader output-channel
         */
        public function autoloader() {
            if ($this->autoloading) {
                try {
                    $class = __CLASS__ . '\\Autoloader';
                    $autoloader = new $class();
                    return $autoloader->toString();
                }
                catch(\FileNotFoundException$e) {
                    header(Utils::getHTTPHeader(404));
                    throw $e;
                }
            }
            return '';
        }
        public function registerRenderContext(RenderContext $cc) {
            $this->render_contexts[] = $cc;
        }
        protected function renderContent() {
            return $this->content;
        }
        protected function ownScript() {
            return self::script();
        }
        protected function ownStyle() {
            return self::style();
        }
        private function appVersion() {
            return (defined('APP_VERSION') ? APP_VERSION : '');
        }
    }
    # END EXECUTABLE FRAME OF MODEL.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__
BEGIN[CONFIG.JSON]
{
  "enable-autoloader": true,
  "encoding":"utf-8",
  "base":"/",
  "fonts": ["fonts/Roboto/roboto.css", "fonts/FontAwesome/font-awesome.min.css", "fonts/FontAwesome/fa-arithmetic-extension.css"],
  "default-font":{
    "family":"robotoregular",
    "size":16
  }
}

END[CONFIG.JSON]

?>
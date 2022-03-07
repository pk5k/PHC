<?php #HYPERCELL hcf.web.Container - BUILD 22.02.28#24
namespace hcf\web;
class Container {
    use \hcf\core\dryver\Config, \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, Container\__EO__\Model, \hcf\core\dryver\View, \hcf\core\dryver\View\Html, \hcf\core\dryver\View\Css, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container';
    const NAME = 'Container';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
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
        $js = "if(document.componentMap==undefined){document.componentMap={}}
window.addEventListener('DOMContentLoaded',function(){document.APP_VERSION=document.querySelector('html').getAttribute('data-version');let utils=hcf.web.Utils;utils.registerCursorMoved();utils.registerMd5Module(utils);utils.extendHTMLElements();});document.registerComponentController=function(hcfqn,controller_class,as_element,element_options){var prop_hcfqn=hcfqn;let target=document.objectByHcfqn(hcfqn);if(target==null){var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();var prop_name=hcfqn;for(var i in split){var part=split[i];if(!scope[part]){scope[part]={};}
scope=scope[part];}
controller_class.prototype.FQN=prop_hcfqn;controller_class.prototype.NAME=prop_name;target=scope[hcfqn]=controller_class;}
if(as_element!=undefined&&as_element!=null){if(element_options==undefined){element_options={};}
if(customElements.get(as_element)==undefined){if(target.prototype instanceof hcf.web.Component||(target.prototype instanceof HTMLElement&&element_options.extends!=undefined)){customElements.define(as_element,target,element_options);}
else{throw prop_hcfqn+' client-controller of '+prop_hcfqn+' must extend hcf.web.Component if elementName is given or use element_options.extend to extend another hcf.web.Component.';}}}
return target;};document.objectByHcfqn=function(hcfqn){var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();for(var i in split){var part=split[i];if(!scope[part]){return null;}
scope=scope[part];}
if(scope[hcfqn]!=undefined){return scope[hcfqn];}
else{return null;}};document.cloneRenderContext=function(which,register_to_fqn){if(which=='global'||which==''){throw'global render context cannot be cloned.';}
let clone_cc=document.getElementById(which);if(clone_cc==null){throw'render context '+which+' does not exist.';}
if(register_to_fqn==undefined||register_to_fqn==null||register_to_fqn==''){throw'render context cannot be registered without fqn';}
let dyn_cc='dyncc-'+register_to_fqn.replace(/\./g,'-').toLowerCase();let ecc=document.getElementById(dyn_cc);if(ecc!=null){return ecc;}
let registered_to=document.componentMap[register_to_fqn];if(registered_to!=undefined&&registered_to!=dyn_cc){console.warn('component '+register_to_fqn+' was already registered to context '+registered_to);}
let new_cc=clone_cc.cloneNode(true);new_cc.setAttribute('id',dyn_cc);document.componentMap[register_to_fqn]=dyn_cc;document.head.appendChild(new_cc);return new_cc;};!function(){\"use strict\";var e=Promise,t=(e,t)=>{const n=e=>{for(let t=0,{length:n}=e;t<n;t++)r(e[t])},r=({target:e,attributeName:t,oldValue:n})=>{e.attributeChangedCallback(t,n,e.getAttribute(t))};return(o,l)=>{const{observedAttributes:s}=o.constructor;return s&&e(l).then((()=>{new t(n).observe(o,{attributes:!0,attributeOldValue:!0,attributeFilter:s});for(let e=0,{length:t}=s;e<t;e++)o.hasAttribute(s[e])&&r({target:o,attributeName:s[e],oldValue:null})})),o}};const n=!0,r=!1,o=\"querySelectorAll\";function l(e){this.observe(e,{subtree:n,childList:n})}const s=\"querySelectorAll\",{document:c,Element:a,MutationObserver:i,Set:u,WeakMap:f}=self,h=e=>s in e,{filter:d}=[];var g=e=>{const t=new f,g=(n,r)=>{let o;if(r)for(let l,s=(e=>e.matches||e.webkitMatchesSelector||e.msMatchesSelector)(n),c=0,{length:a}=w;c<a;c++)s.call(n,l=w[c])&&(t.has(n)||t.set(n,new u),o=t.get(n),o.has(l)||(o.add(l),e.handle(n,r,l)));else t.has(n)&&(o=t.get(n),t.delete(n),o.forEach((t=>{e.handle(n,r,t)})))},p=(e,t=!0)=>{for(let n=0,{length:r}=e;n<r;n++)g(e[n],t)},{query:w}=e,y=e.root||c,m=((e,t,s)=>{const c=(t,r,l,s,a)=>{for(let i=0,{length:u}=t;i<u;i++){const u=t[i];(a||o in u)&&(s?r.has(u)||(r.add(u),l.delete(u),e(u,s)):l.has(u)||(l.add(u),r.delete(u),e(u,s)),a||c(u[o](\"*\"),r,l,s,n))}},a=new(s||MutationObserver)((e=>{for(let t=new Set,o=new Set,l=0,{length:s}=e;l<s;l++){const{addedNodes:s,removedNodes:a}=e[l];c(a,t,o,r,r),c(s,t,o,n,r)}}));return a.add=l,a.add(t||document),a})(g,y,i),{attachShadow:b}=a.prototype;return b&&(a.prototype.attachShadow=function(e){const t=b.call(this,e);return m.add(t),t}),w.length&&p(y[s](w)),{drop:e=>{for(let n=0,{length:r}=e;n<r;n++)t.delete(e[n])},flush:()=>{const e=m.takeRecords();for(let t=0,{length:n}=e;t<n;t++)p(d.call(e[t].removedNodes,h),!1),p(d.call(e[t].addedNodes,h),!0)},observer:m,parse:p}};const{document:p,Map:w,MutationObserver:y,Object:m,Set:b,WeakMap:E,Element:v,HTMLElement:S,Node:M,Error:O,TypeError:N,Reflect:A}=self,q=self.Promise||e,{defineProperty:C,keys:T,getOwnPropertyNames:D,setPrototypeOf:L}=m;let P=!self.customElements;const k=e=>{const t=T(e),n=[],{length:r}=t;for(let o=0;o<r;o++)n[o]=e[t[o]],delete e[t[o]];return()=>{for(let o=0;o<r;o++)e[t[o]]=n[o]}};if(P){const{createElement:n}=p,r=new w,o=new w,l=new w,s=new w,c=[],a=(e,t,n)=>{const r=l.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);u=L(e,r);try{new r.constructor}finally{u=null,t()}}const o=(t?\"\":\"dis\")+\"connectedCallback\";o in r&&e[o]()},{parse:i}=g({query:c,handle:a});let u=null;const f=t=>{if(!o.has(t)){let n,r=new e((e=>{n=e}));o.set(t,{\$:r,_:n})}return o.get(t).\$},h=t(f,y);function \$(){const{constructor:e}=this;if(!r.has(e))throw new N(\"Illegal constructor\");const t=r.get(e);if(u)return h(u,t);const o=n.call(p,t);return h(L(o,e.prototype),t)}C(self,\"customElements\",{configurable:!0,value:{define:(e,t)=>{if(s.has(e))throw new O(`the name \"\${e}\" has already been used with this registry`);r.set(t,e),l.set(e,t.prototype),s.set(e,t),c.push(e),f(e).then((()=>{i(p.querySelectorAll(e))})),o.get(e)._(t)},get:e=>s.get(e),whenDefined:f}}),C(\$.prototype=S.prototype,\"constructor\",{value:\$}),C(self,\"HTMLElement\",{configurable:!0,value:\$}),C(p,\"createElement\",{configurable:!0,value(e,t){const r=t&&t.is,o=r?s.get(r):s.get(e);return o?new o:n.call(p,e)}}),\"isConnected\"in M.prototype||C(M.prototype,\"isConnected\",{configurable:!0,get(){return!(this.ownerDocument.compareDocumentPosition(this)&this.DOCUMENT_POSITION_DISCONNECTED)}})}else try{function I(){return self.Reflect.construct(HTMLLIElement,[],I)}I.prototype=HTMLLIElement.prototype;const e=\"extends-li\";self.customElements.define(\"extends-li\",I,{extends:\"li\"}),P=p.createElement(\"li\",{is:e}).outerHTML.indexOf(e)<0;const{get:t,whenDefined:n}=self.customElements;C(self.customElements,\"whenDefined\",{configurable:!0,value(e){return n.call(this,e).then((n=>n||t.call(this,e)))}})}catch(e){P=!P}if(P){const e=self.customElements,{attachShadow:n}=v.prototype,{createElement:r}=p,{define:o,get:l}=e,{construct:s}=A||{construct(e){return e.call(this)}},c=new E,a=new b,i=new w,u=new w,f=new w,h=new w,d=[],m=[],S=t=>h.get(t)||l.call(e,t),M=(e,t,n)=>{const r=f.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);_=L(e,r);try{new r.constructor}finally{_=null,t()}}const o=(t?\"\":\"dis\")+\"connectedCallback\";o in r&&e[o]()},{parse:T}=g({query:m,handle:M}),{parse:P}=g({query:d,handle(e,t){c.has(e)&&(t?a.add(e):a.delete(e),m.length&&H.call(m,e))}}),\$=e=>{if(!u.has(e)){let t,n=new q((e=>{t=e}));u.set(e,{\$:n,_:t})}return u.get(e).\$},I=t(\$,y);let _=null;function H(e){const t=c.get(e);T(t.querySelectorAll(this),e.isConnected)}D(self).filter((e=>/^HTML/.test(e))).forEach((e=>{const t=self[e];function n(){const{constructor:e}=this;if(!i.has(e))throw new N(\"Illegal constructor\");const{is:n,tag:o}=i.get(e);if(n){if(_)return I(_,n);const t=r.call(p,o);return t.setAttribute(\"is\",n),I(L(t,e.prototype),n)}return s.call(this,t,[],e)}L(n,t),C(n.prototype=t.prototype,\"constructor\",{value:n}),C(self,e,{value:n})})),C(p,\"createElement\",{configurable:!0,value(e,t){const n=t&&t.is;if(n){const t=h.get(n);if(t&&i.get(t).tag===e)return new t}const o=r.call(p,e);return n&&o.setAttribute(\"is\",n),o}}),n&&(v.prototype.attachShadow=function(e){const t=n.call(this,e);return c.set(this,t),t}),C(e,\"get\",{configurable:!0,value:S}),C(e,\"whenDefined\",{configurable:!0,value:\$}),C(e,\"define\",{configurable:!0,value(t,n,r){if(S(t))throw new O(`'\${t}' has already been defined as a custom element`);let l;const s=r&&r.extends;i.set(n,s?{is:t,tag:s}:{is:\"\",tag:t}),s?(l=`\${s}[is=\"\${t}\"]`,f.set(l,n.prototype),h.set(t,n),m.push(l)):(o.apply(e,arguments),d.push(l=t)),\$(t).then((()=>{s?(T(p.querySelectorAll(l)),a.forEach(H,[l])):P(p.querySelectorAll(l))})),u.get(t)._(n)}})}}();";
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
    # BEGIN EXECUTABLE FRAME OF MODEL.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\web\RenderContext;
    use \hcf\web\Controller;
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
            $cc->register(Controller::class);
            $cc->register(Component::class);
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
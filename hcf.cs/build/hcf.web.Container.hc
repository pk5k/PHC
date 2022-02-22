<?php #HYPERCELL hcf.web.Container - BUILD 22.02.22#16
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
        $js = "window.addEventListener('DOMContentLoaded',function(){document.APP_VERSION=document.querySelector('html').getAttribute('data-version');});document.registerComponentController=function(hcfqn,controller_class,component_context_id,as_element,element_options){var prop_hcfqn=hcfqn;let target=document.objectByHcfqn(hcfqn);if(target==null){var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();var prop_name=hcfqn;for(var i in split){var part=split[i];if(!scope[part]){scope[part]={};}
scope=scope[part];}
controller_class.FQN=prop_hcfqn;controller_class.NAME=prop_name;target=scope[hcfqn]=controller_class;}
if(as_element!=undefined&&as_element!=null){if(element_options==undefined){element_options={};}
if(customElements.get(as_element)==undefined){if(target.prototype instanceof hcf.web.Component||(target.prototype instanceof HTMLElement&&element_options.extends!=undefined)){customElements.define(as_element,target,element_options);}
else{throw prop_hcfqn+' client-controller of '+prop_hcfqn+' must extend hcf.web.Component if elementName is given.';}}
if(document.componentMap==undefined){document.componentMap={};}
document.componentMap[as_element.toUpperCase()]={fqn:prop_hcfqn,context:component_context_id};}
return target;};document.objectByHcfqn=function(hcfqn){var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();for(var i in split){var part=split[i];if(!scope[part]){return null;}
scope=scope[part];}
if(scope[hcfqn]!=undefined){return scope[hcfqn];}
else{return null;}}
document.recursiveOffset=function(aobj){var currOffset={x:0,y:0}
var newOffset={x:0,y:0}
if(aobj!==null){if(aobj.scrollLeft){currOffset.x=aobj.scrollLeft;}
if(aobj.scrollTop){currOffset.y=aobj.scrollTop;}
if(aobj.offsetLeft){currOffset.x-=aobj.offsetLeft;}
if(aobj.offsetTop){currOffset.y-=aobj.offsetTop;}
if(aobj.parentNode!==undefined){newOffset=document.recursiveOffset(aobj.parentNode);}
currOffset.x=currOffset.x+newOffset.x;currOffset.y=currOffset.y+newOffset.y;}
return currOffset;}
function mouseMoved(e){if(typeof e=='undefined'||e==null){document.mouse={x:0,y:0};return;}
if(document.mouse_timeout==null||document.mouse_timeout==undefined){var doc=document.documentElement||document.body;var target=e.srcElement||e.target;var offsetpos=document.recursiveOffset(doc);pos_x=e.clientX+offsetpos.x;pos_y=e.clientY+offsetpos.y;document.mouse={x:pos_x,y:pos_y};document.mouse_timeout=setTimeout(function(){document.mouse_timeout=null;},100);}}
document.onmousemove=mouseMoved;(function(\$){'use strict'
function safeAdd(x,y){var lsw=(x&0xFFFF)+(y&0xFFFF)
var msw=(x>>16)+(y>>16)+(lsw>>16)
return(msw<<16)|(lsw&0xFFFF)}
function bitRotateLeft(num,cnt){return(num<<cnt)|(num>>>(32-cnt))}
function md5cmn(q,a,b,x,s,t){return safeAdd(bitRotateLeft(safeAdd(safeAdd(a,q),safeAdd(x,t)),s),b)}
function md5ff(a,b,c,d,x,s,t){return md5cmn((b&c)|((~b)&d),a,b,x,s,t)}
function md5gg(a,b,c,d,x,s,t){return md5cmn((b&d)|(c&(~d)),a,b,x,s,t)}
function md5hh(a,b,c,d,x,s,t){return md5cmn(b^c^d,a,b,x,s,t)}
function md5ii(a,b,c,d,x,s,t){return md5cmn(c^(b|(~d)),a,b,x,s,t)}
function binlMD5(x,len){x[len>>5]|=0x80<<(len%32)
x[(((len+64)>>>9)<<4)+14]=len
var i
var olda
var oldb
var oldc
var oldd
var a=1732584193
var b=-271733879
var c=-1732584194
var d=271733878
for(i=0;i<x.length;i+=16){olda=a
oldb=b
oldc=c
oldd=d
a=md5ff(a,b,c,d,x[i],7,-680876936)
d=md5ff(d,a,b,c,x[i+1],12,-389564586)
c=md5ff(c,d,a,b,x[i+2],17,606105819)
b=md5ff(b,c,d,a,x[i+3],22,-1044525330)
a=md5ff(a,b,c,d,x[i+4],7,-176418897)
d=md5ff(d,a,b,c,x[i+5],12,1200080426)
c=md5ff(c,d,a,b,x[i+6],17,-1473231341)
b=md5ff(b,c,d,a,x[i+7],22,-45705983)
a=md5ff(a,b,c,d,x[i+8],7,1770035416)
d=md5ff(d,a,b,c,x[i+9],12,-1958414417)
c=md5ff(c,d,a,b,x[i+10],17,-42063)
b=md5ff(b,c,d,a,x[i+11],22,-1990404162)
a=md5ff(a,b,c,d,x[i+12],7,1804603682)
d=md5ff(d,a,b,c,x[i+13],12,-40341101)
c=md5ff(c,d,a,b,x[i+14],17,-1502002290)
b=md5ff(b,c,d,a,x[i+15],22,1236535329)
a=md5gg(a,b,c,d,x[i+1],5,-165796510)
d=md5gg(d,a,b,c,x[i+6],9,-1069501632)
c=md5gg(c,d,a,b,x[i+11],14,643717713)
b=md5gg(b,c,d,a,x[i],20,-373897302)
a=md5gg(a,b,c,d,x[i+5],5,-701558691)
d=md5gg(d,a,b,c,x[i+10],9,38016083)
c=md5gg(c,d,a,b,x[i+15],14,-660478335)
b=md5gg(b,c,d,a,x[i+4],20,-405537848)
a=md5gg(a,b,c,d,x[i+9],5,568446438)
d=md5gg(d,a,b,c,x[i+14],9,-1019803690)
c=md5gg(c,d,a,b,x[i+3],14,-187363961)
b=md5gg(b,c,d,a,x[i+8],20,1163531501)
a=md5gg(a,b,c,d,x[i+13],5,-1444681467)
d=md5gg(d,a,b,c,x[i+2],9,-51403784)
c=md5gg(c,d,a,b,x[i+7],14,1735328473)
b=md5gg(b,c,d,a,x[i+12],20,-1926607734)
a=md5hh(a,b,c,d,x[i+5],4,-378558)
d=md5hh(d,a,b,c,x[i+8],11,-2022574463)
c=md5hh(c,d,a,b,x[i+11],16,1839030562)
b=md5hh(b,c,d,a,x[i+14],23,-35309556)
a=md5hh(a,b,c,d,x[i+1],4,-1530992060)
d=md5hh(d,a,b,c,x[i+4],11,1272893353)
c=md5hh(c,d,a,b,x[i+7],16,-155497632)
b=md5hh(b,c,d,a,x[i+10],23,-1094730640)
a=md5hh(a,b,c,d,x[i+13],4,681279174)
d=md5hh(d,a,b,c,x[i],11,-358537222)
c=md5hh(c,d,a,b,x[i+3],16,-722521979)
b=md5hh(b,c,d,a,x[i+6],23,76029189)
a=md5hh(a,b,c,d,x[i+9],4,-640364487)
d=md5hh(d,a,b,c,x[i+12],11,-421815835)
c=md5hh(c,d,a,b,x[i+15],16,530742520)
b=md5hh(b,c,d,a,x[i+2],23,-995338651)
a=md5ii(a,b,c,d,x[i],6,-198630844)
d=md5ii(d,a,b,c,x[i+7],10,1126891415)
c=md5ii(c,d,a,b,x[i+14],15,-1416354905)
b=md5ii(b,c,d,a,x[i+5],21,-57434055)
a=md5ii(a,b,c,d,x[i+12],6,1700485571)
d=md5ii(d,a,b,c,x[i+3],10,-1894986606)
c=md5ii(c,d,a,b,x[i+10],15,-1051523)
b=md5ii(b,c,d,a,x[i+1],21,-2054922799)
a=md5ii(a,b,c,d,x[i+8],6,1873313359)
d=md5ii(d,a,b,c,x[i+15],10,-30611744)
c=md5ii(c,d,a,b,x[i+6],15,-1560198380)
b=md5ii(b,c,d,a,x[i+13],21,1309151649)
a=md5ii(a,b,c,d,x[i+4],6,-145523070)
d=md5ii(d,a,b,c,x[i+11],10,-1120210379)
c=md5ii(c,d,a,b,x[i+2],15,718787259)
b=md5ii(b,c,d,a,x[i+9],21,-343485551)
a=safeAdd(a,olda)
b=safeAdd(b,oldb)
c=safeAdd(c,oldc)
d=safeAdd(d,oldd)}
return[a,b,c,d]}
function binl2rstr(input){var i
var output=''
var length32=input.length*32
for(i=0;i<length32;i+=8){output+=String.fromCharCode((input[i>>5]>>>(i%32))&0xFF)}
return output}
function rstr2binl(input){var i
var output=[]
output[(input.length>>2)-1]=undefined
for(i=0;i<output.length;i+=1){output[i]=0}
var length8=input.length*8
for(i=0;i<length8;i+=8){output[i>>5]|=(input.charCodeAt(i / 8)&0xFF)<<(i%32)}
return output}
function rstrMD5(s){return binl2rstr(binlMD5(rstr2binl(s),s.length*8))}
function rstrHMACMD5(key,data){var i
var bkey=rstr2binl(key)
var ipad=[]
var opad=[]
var hash
ipad[15]=opad[15]=undefined
if(bkey.length>16){bkey=binlMD5(bkey,key.length*8)}
for(i=0;i<16;i+=1){ipad[i]=bkey[i]^0x36363636
opad[i]=bkey[i]^0x5C5C5C5C}
hash=binlMD5(ipad.concat(rstr2binl(data)),512+data.length*8)
return binl2rstr(binlMD5(opad.concat(hash),512+128))}
function rstr2hex(input){var hexTab='0123456789abcdef'
var output=''
var x
var i
for(i=0;i<input.length;i+=1){x=input.charCodeAt(i)
output+=hexTab.charAt((x>>>4)&0x0F)+
hexTab.charAt(x&0x0F)}
return output}
function str2rstrUTF8(input){return unescape(encodeURIComponent(input))}
function rawMD5(s){return rstrMD5(str2rstrUTF8(s))}
function hexMD5(s){return rstr2hex(rawMD5(s))}
function rawHMACMD5(k,d){return rstrHMACMD5(str2rstrUTF8(k),str2rstrUTF8(d))}
function hexHMACMD5(k,d){return rstr2hex(rawHMACMD5(k,d))}
function md5(string,key,raw){if(!key){if(!raw){return hexMD5(string)}
return rawMD5(string)}
if(!raw){return hexHMACMD5(key,string)}
return rawHMACMD5(key,string)}
if(typeof define==='function'&&define.amd){define(function(){return md5})}else if(typeof module==='object'&&module.exports){module.exports=md5}else{\$.md5=md5}}(this));!function(){\"use strict\";var e=Promise,t=(e,t)=>{const n=e=>{for(let t=0,{length:n}=e;t<n;t++)r(e[t])},r=({target:e,attributeName:t,oldValue:n})=>{e.attributeChangedCallback(t,n,e.getAttribute(t))};return(o,l)=>{const{observedAttributes:s}=o.constructor;return s&&e(l).then((()=>{new t(n).observe(o,{attributes:!0,attributeOldValue:!0,attributeFilter:s});for(let e=0,{length:t}=s;e<t;e++)o.hasAttribute(s[e])&&r({target:o,attributeName:s[e],oldValue:null})})),o}};const n=!0,r=!1,o=\"querySelectorAll\";function l(e){this.observe(e,{subtree:n,childList:n})}const s=\"querySelectorAll\",{document:c,Element:a,MutationObserver:i,Set:u,WeakMap:f}=self,h=e=>s in e,{filter:d}=[];var g=e=>{const t=new f,g=(n,r)=>{let o;if(r)for(let l,s=(e=>e.matches||e.webkitMatchesSelector||e.msMatchesSelector)(n),c=0,{length:a}=w;c<a;c++)s.call(n,l=w[c])&&(t.has(n)||t.set(n,new u),o=t.get(n),o.has(l)||(o.add(l),e.handle(n,r,l)));else t.has(n)&&(o=t.get(n),t.delete(n),o.forEach((t=>{e.handle(n,r,t)})))},p=(e,t=!0)=>{for(let n=0,{length:r}=e;n<r;n++)g(e[n],t)},{query:w}=e,y=e.root||c,m=((e,t,s)=>{const c=(t,r,l,s,a)=>{for(let i=0,{length:u}=t;i<u;i++){const u=t[i];(a||o in u)&&(s?r.has(u)||(r.add(u),l.delete(u),e(u,s)):l.has(u)||(l.add(u),r.delete(u),e(u,s)),a||c(u[o](\"*\"),r,l,s,n))}},a=new(s||MutationObserver)((e=>{for(let t=new Set,o=new Set,l=0,{length:s}=e;l<s;l++){const{addedNodes:s,removedNodes:a}=e[l];c(a,t,o,r,r),c(s,t,o,n,r)}}));return a.add=l,a.add(t||document),a})(g,y,i),{attachShadow:b}=a.prototype;return b&&(a.prototype.attachShadow=function(e){const t=b.call(this,e);return m.add(t),t}),w.length&&p(y[s](w)),{drop:e=>{for(let n=0,{length:r}=e;n<r;n++)t.delete(e[n])},flush:()=>{const e=m.takeRecords();for(let t=0,{length:n}=e;t<n;t++)p(d.call(e[t].removedNodes,h),!1),p(d.call(e[t].addedNodes,h),!0)},observer:m,parse:p}};const{document:p,Map:w,MutationObserver:y,Object:m,Set:b,WeakMap:E,Element:v,HTMLElement:S,Node:M,Error:O,TypeError:N,Reflect:A}=self,q=self.Promise||e,{defineProperty:C,keys:T,getOwnPropertyNames:D,setPrototypeOf:L}=m;let P=!self.customElements;const k=e=>{const t=T(e),n=[],{length:r}=t;for(let o=0;o<r;o++)n[o]=e[t[o]],delete e[t[o]];return()=>{for(let o=0;o<r;o++)e[t[o]]=n[o]}};if(P){const{createElement:n}=p,r=new w,o=new w,l=new w,s=new w,c=[],a=(e,t,n)=>{const r=l.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);u=L(e,r);try{new r.constructor}finally{u=null,t()}}const o=(t?\"\":\"dis\")+\"connectedCallback\";o in r&&e[o]()},{parse:i}=g({query:c,handle:a});let u=null;const f=t=>{if(!o.has(t)){let n,r=new e((e=>{n=e}));o.set(t,{\$:r,_:n})}return o.get(t).\$},h=t(f,y);function \$(){const{constructor:e}=this;if(!r.has(e))throw new N(\"Illegal constructor\");const t=r.get(e);if(u)return h(u,t);const o=n.call(p,t);return h(L(o,e.prototype),t)}C(self,\"customElements\",{configurable:!0,value:{define:(e,t)=>{if(s.has(e))throw new O(`the name \"\${e}\" has already been used with this registry`);r.set(t,e),l.set(e,t.prototype),s.set(e,t),c.push(e),f(e).then((()=>{i(p.querySelectorAll(e))})),o.get(e)._(t)},get:e=>s.get(e),whenDefined:f}}),C(\$.prototype=S.prototype,\"constructor\",{value:\$}),C(self,\"HTMLElement\",{configurable:!0,value:\$}),C(p,\"createElement\",{configurable:!0,value(e,t){const r=t&&t.is,o=r?s.get(r):s.get(e);return o?new o:n.call(p,e)}}),\"isConnected\"in M.prototype||C(M.prototype,\"isConnected\",{configurable:!0,get(){return!(this.ownerDocument.compareDocumentPosition(this)&this.DOCUMENT_POSITION_DISCONNECTED)}})}else try{function I(){return self.Reflect.construct(HTMLLIElement,[],I)}I.prototype=HTMLLIElement.prototype;const e=\"extends-li\";self.customElements.define(\"extends-li\",I,{extends:\"li\"}),P=p.createElement(\"li\",{is:e}).outerHTML.indexOf(e)<0;const{get:t,whenDefined:n}=self.customElements;C(self.customElements,\"whenDefined\",{configurable:!0,value(e){return n.call(this,e).then((n=>n||t.call(this,e)))}})}catch(e){P=!P}if(P){const e=self.customElements,{attachShadow:n}=v.prototype,{createElement:r}=p,{define:o,get:l}=e,{construct:s}=A||{construct(e){return e.call(this)}},c=new E,a=new b,i=new w,u=new w,f=new w,h=new w,d=[],m=[],S=t=>h.get(t)||l.call(e,t),M=(e,t,n)=>{const r=f.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);_=L(e,r);try{new r.constructor}finally{_=null,t()}}const o=(t?\"\":\"dis\")+\"connectedCallback\";o in r&&e[o]()},{parse:T}=g({query:m,handle:M}),{parse:P}=g({query:d,handle(e,t){c.has(e)&&(t?a.add(e):a.delete(e),m.length&&H.call(m,e))}}),\$=e=>{if(!u.has(e)){let t,n=new q((e=>{t=e}));u.set(e,{\$:n,_:t})}return u.get(e).\$},I=t(\$,y);let _=null;function H(e){const t=c.get(e);T(t.querySelectorAll(this),e.isConnected)}D(self).filter((e=>/^HTML/.test(e))).forEach((e=>{const t=self[e];function n(){const{constructor:e}=this;if(!i.has(e))throw new N(\"Illegal constructor\");const{is:n,tag:o}=i.get(e);if(n){if(_)return I(_,n);const t=r.call(p,o);return t.setAttribute(\"is\",n),I(L(t,e.prototype),n)}return s.call(this,t,[],e)}L(n,t),C(n.prototype=t.prototype,\"constructor\",{value:n}),C(self,e,{value:n})})),C(p,\"createElement\",{configurable:!0,value(e,t){const n=t&&t.is;if(n){const t=h.get(n);if(t&&i.get(t).tag===e)return new t}const o=r.call(p,e);return n&&o.setAttribute(\"is\",n),o}}),n&&(v.prototype.attachShadow=function(e){const t=n.call(this,e);return c.set(this,t),t}),C(e,\"get\",{configurable:!0,value:S}),C(e,\"whenDefined\",{configurable:!0,value:\$}),C(e,\"define\",{configurable:!0,value(t,n,r){if(S(t))throw new O(`'\${t}' has already been defined as a custom element`);let l;const s=r&&r.extends;i.set(n,s?{is:t,tag:s}:{is:\"\",tag:t}),s?(l=`\${s}[is=\"\${t}\"]`,f.set(l,n.prototype),h.set(t,n),m.push(l)):(o.apply(e,arguments),d.push(l=t)),\$(t).then((()=>{s?(T(p.querySelectorAll(l)),a.forEach(H,[l])):P(p.querySelectorAll(l))})),u.get(t)._(n)}})}}();";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    # BEGIN ASSEMBLY FRAME VIEW.HTML
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "{$__CLASS__::_call('docType', $__CLASS__, $_this) }";
        $output.= "<html lang=\"{$__CLASS__::_property('content_language', $__CLASS__, $_this) }\" data-version=\"{$__CLASS__::_call('appVersion', $__CLASS__, $_this) }\">";
        $output.= "<head>";
        $output.= "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=Edge\"/>";
        $output.= "<meta charset=\"{$__CLASS__::_property('encoding', $__CLASS__, $_this) }\"/>";
        $output.= "<title>{$__CLASS__::_property('title', $__CLASS__, $_this) }</title>";
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
        foreach ($__CLASS__::_property('ext_css', $__CLASS__, $_this) as $href => $media) {
            $output.= "<link rel=\"stylesheet\" type=\"text/css\" href=\"$href\" media=\"$media\"/>";
        }
        $output.= "<script language=\"javascript\">{$__CLASS__::_call('ownScript', $__CLASS__, $_this) } {$__CLASS__::_property('component_reg_data', $__CLASS__, $_this) }</script>";
        $output.= "<style>{$__CLASS__::_call('ownStyle', $__CLASS__, $_this) }</style>";
        foreach ($__CLASS__::_property('component_contexts', $__CLASS__, $_this) as $component_context) {
            $output.= "$component_context";
        }
        foreach ($__CLASS__::_property('emb_js', $__CLASS__, $_this) as $emb_js_str) {
            $output.= "<script language=\"javascript\">$emb_js_str</script>";
        }
        foreach ($__CLASS__::_property('emb_css', $__CLASS__, $_this) as $emb_css_str) {
            $output.= "<style>$emb_css_str</style>";
        }
        $output.= "<style>body { font-family:'{$__CLASS__::_property('font_family', $__CLASS__, $_this) }'!important; font-size:{$__CLASS__::_property('font_size', $__CLASS__, $_this) }!important;}</style>";
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
        return 'html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,details,embed,figure,figcaption,footer,header,hgroup,menu,nav,output,ruby,section,summary,time,mark,audio,video{margin:0;padding:0;border:0;font-size:100%;font:inherit;vertical-align:baseline}article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:"";content:none}table{border-collapse:collapse;border-spacing:0}*:focus,*:visited,*:active,*:hover{outline:0 !important}*::-moz-focus-inner{border:0}select:-moz-focusring{color:transparent;text-shadow:0 0 0 #000}';
    }
    # END ASSEMBLY FRAME VIEW.SCSS
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    private function docType() {
        $__CLASS__ = __CLASS__;
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
    use \hcf\web\ComponentContext;
    use \hcf\web\Component;
    use \hcf\web\Bridge;
    use \hcf\web\PageLoader;
    use \hcf\web\Page;
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
        protected $component_reg_data = '';
        protected $component_reg_data_initialized = false;
        protected $component_contexts = [];
        /**
         * __construct
         *
         */
        public function hcfwebContainer_onConstruct_Model() {
            $config = self::config();
            if (isset($config)) {
                if (isset($config->font) && is_object($config->font)) {
                    $this->font($config->font->family);
                    $this->fontSize($config->font->size);
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
            }
            $cc = new ComponentContext('core');
            $cc->register(Component::class);
            $cc->register(Bridge::class);
            $cc->register(PageLoader::class);
            $cc->register(Page::class);
            $this->registerComponentContext($cc);
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
        public function registerComponentContext(ComponentContext $cc) {
            $this->component_contexts[] = $cc;
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
  "encoding":"utf-8",
  "enable-autoloader": true,
  "font":{
    "family":"robotoregular",
    "size":16
  }
}

END[CONFIG.JSON]

?>
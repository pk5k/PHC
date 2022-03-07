if (document.componentMap == undefined){document.componentMap = {}}
window.addEventListener('DOMContentLoaded', function() 
{
  document.APP_VERSION = document.querySelector('html').getAttribute('data-version');
  
  // setup util
  let utils = hcf.web.Utils;
  utils.registerCursorMoved();
  utils.registerMd5Module(utils);// results in function at hcf.web.Utils.md5(str)
  utils.extendHTMLElements();
});

document.registerComponentController = function(hcfqn, controller_class, as_element, element_options)
{
  var prop_hcfqn = hcfqn;
  let target = document.objectByHcfqn(hcfqn);

  if (target == null)
  {
    // register controller
    var split = hcfqn.split('.')
    var scope = window;
    var hcfqn = split.pop();
    var prop_name = hcfqn;

    for (var i in split)
    {
      var part = split[i];

      if (!scope[part])
      {
        scope[part] = {};
      }

      scope = scope[part];
    }

    controller_class.prototype.FQN = prop_hcfqn;// this.FQN can be used in each hcf.web.Controller instance
    controller_class.prototype.NAME = prop_name; // same with this.NAME for the name only
    
    target = scope[hcfqn] = controller_class;
  }
  
  if (as_element != undefined && as_element != null)
  {
    if (element_options == undefined)
    {
      element_options = {};
    }

    if (customElements.get(as_element) == undefined)
    {
      if (target.prototype instanceof hcf.web.Component || (target.prototype instanceof HTMLElement && element_options.extends != undefined))
      {
        // HTMLElement check is required due to elements that just can be used trough the "is" attribute
        customElements.define(as_element, target, element_options);
      }
      else 
      {
        throw prop_hcfqn + ' client-controller of ' + prop_hcfqn + ' must extend hcf.web.Component if elementName is given or use element_options.extend to extend another hcf.web.Component.';
      }
    }
  }

  return target;
};

document.objectByHcfqn = function(hcfqn)
{
  var split = hcfqn.split('.')
  var scope = window;
  var hcfqn = split.pop();

  for (var i in split)
  {
    var part = split[i];

    if (!scope[part])
    {
      return null;
    }

    scope = scope[part];
  }

  if (scope[hcfqn] != undefined)
  {
    return scope[hcfqn];
  }
  else 
  {
    return null;
  }
};

document.cloneRenderContext = function(which, register_to_fqn)
{
    if (which == 'global' || which == '')
    {
      throw 'global render context cannot be cloned.';
    }
    
    let clone_cc = document.getElementById(which);

    if (clone_cc == null)
    {
      throw 'render context ' + which + ' does not exist.';
    }

    if (register_to_fqn == undefined || register_to_fqn == null || register_to_fqn == '')
    {
      throw 'render context cannot be registered without fqn';
    }

    let dyn_cc = 'dyncc-' + register_to_fqn.replace(/\./g, '-').toLowerCase();// name for dynamically created context
    let ecc = document.getElementById(dyn_cc);

    if (ecc != null)
    {
      return ecc;
    }

    let registered_to = document.componentMap[register_to_fqn];

    if (registered_to != undefined && registered_to != dyn_cc)
    {
      console.warn('component ' + register_to_fqn + ' was already registered to context ' + registered_to);
    }

    let new_cc = clone_cc.cloneNode(true);
    new_cc.setAttribute('id', dyn_cc);

    document.componentMap[register_to_fqn] = dyn_cc;
    document.head.appendChild(new_cc);

    return new_cc;
  };

// custom-elements-v1-polyfill:
!function(){"use strict";var e=Promise,t=(e,t)=>{const n=e=>{for(let t=0,{length:n}=e;t<n;t++)r(e[t])},r=({target:e,attributeName:t,oldValue:n})=>{e.attributeChangedCallback(t,n,e.getAttribute(t))};return(o,l)=>{const{observedAttributes:s}=o.constructor;return s&&e(l).then((()=>{new t(n).observe(o,{attributes:!0,attributeOldValue:!0,attributeFilter:s});for(let e=0,{length:t}=s;e<t;e++)o.hasAttribute(s[e])&&r({target:o,attributeName:s[e],oldValue:null})})),o}};const n=!0,r=!1,o="querySelectorAll";function l(e){this.observe(e,{subtree:n,childList:n})}const s="querySelectorAll",{document:c,Element:a,MutationObserver:i,Set:u,WeakMap:f}=self,h=e=>s in e,{filter:d}=[];var g=e=>{const t=new f,g=(n,r)=>{let o;if(r)for(let l,s=(e=>e.matches||e.webkitMatchesSelector||e.msMatchesSelector)(n),c=0,{length:a}=w;c<a;c++)s.call(n,l=w[c])&&(t.has(n)||t.set(n,new u),o=t.get(n),o.has(l)||(o.add(l),e.handle(n,r,l)));else t.has(n)&&(o=t.get(n),t.delete(n),o.forEach((t=>{e.handle(n,r,t)})))},p=(e,t=!0)=>{for(let n=0,{length:r}=e;n<r;n++)g(e[n],t)},{query:w}=e,y=e.root||c,m=((e,t,s)=>{const c=(t,r,l,s,a)=>{for(let i=0,{length:u}=t;i<u;i++){const u=t[i];(a||o in u)&&(s?r.has(u)||(r.add(u),l.delete(u),e(u,s)):l.has(u)||(l.add(u),r.delete(u),e(u,s)),a||c(u[o]("*"),r,l,s,n))}},a=new(s||MutationObserver)((e=>{for(let t=new Set,o=new Set,l=0,{length:s}=e;l<s;l++){const{addedNodes:s,removedNodes:a}=e[l];c(a,t,o,r,r),c(s,t,o,n,r)}}));return a.add=l,a.add(t||document),a})(g,y,i),{attachShadow:b}=a.prototype;return b&&(a.prototype.attachShadow=function(e){const t=b.call(this,e);return m.add(t),t}),w.length&&p(y[s](w)),{drop:e=>{for(let n=0,{length:r}=e;n<r;n++)t.delete(e[n])},flush:()=>{const e=m.takeRecords();for(let t=0,{length:n}=e;t<n;t++)p(d.call(e[t].removedNodes,h),!1),p(d.call(e[t].addedNodes,h),!0)},observer:m,parse:p}};const{document:p,Map:w,MutationObserver:y,Object:m,Set:b,WeakMap:E,Element:v,HTMLElement:S,Node:M,Error:O,TypeError:N,Reflect:A}=self,q=self.Promise||e,{defineProperty:C,keys:T,getOwnPropertyNames:D,setPrototypeOf:L}=m;let P=!self.customElements;const k=e=>{const t=T(e),n=[],{length:r}=t;for(let o=0;o<r;o++)n[o]=e[t[o]],delete e[t[o]];return()=>{for(let o=0;o<r;o++)e[t[o]]=n[o]}};if(P){const{createElement:n}=p,r=new w,o=new w,l=new w,s=new w,c=[],a=(e,t,n)=>{const r=l.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);u=L(e,r);try{new r.constructor}finally{u=null,t()}}const o=(t?"":"dis")+"connectedCallback";o in r&&e[o]()},{parse:i}=g({query:c,handle:a});let u=null;const f=t=>{if(!o.has(t)){let n,r=new e((e=>{n=e}));o.set(t,{$:r,_:n})}return o.get(t).$},h=t(f,y);function $(){const{constructor:e}=this;if(!r.has(e))throw new N("Illegal constructor");const t=r.get(e);if(u)return h(u,t);const o=n.call(p,t);return h(L(o,e.prototype),t)}C(self,"customElements",{configurable:!0,value:{define:(e,t)=>{if(s.has(e))throw new O(`the name "${e}" has already been used with this registry`);r.set(t,e),l.set(e,t.prototype),s.set(e,t),c.push(e),f(e).then((()=>{i(p.querySelectorAll(e))})),o.get(e)._(t)},get:e=>s.get(e),whenDefined:f}}),C($.prototype=S.prototype,"constructor",{value:$}),C(self,"HTMLElement",{configurable:!0,value:$}),C(p,"createElement",{configurable:!0,value(e,t){const r=t&&t.is,o=r?s.get(r):s.get(e);return o?new o:n.call(p,e)}}),"isConnected"in M.prototype||C(M.prototype,"isConnected",{configurable:!0,get(){return!(this.ownerDocument.compareDocumentPosition(this)&this.DOCUMENT_POSITION_DISCONNECTED)}})}else try{function I(){return self.Reflect.construct(HTMLLIElement,[],I)}I.prototype=HTMLLIElement.prototype;const e="extends-li";self.customElements.define("extends-li",I,{extends:"li"}),P=p.createElement("li",{is:e}).outerHTML.indexOf(e)<0;const{get:t,whenDefined:n}=self.customElements;C(self.customElements,"whenDefined",{configurable:!0,value(e){return n.call(this,e).then((n=>n||t.call(this,e)))}})}catch(e){P=!P}if(P){const e=self.customElements,{attachShadow:n}=v.prototype,{createElement:r}=p,{define:o,get:l}=e,{construct:s}=A||{construct(e){return e.call(this)}},c=new E,a=new b,i=new w,u=new w,f=new w,h=new w,d=[],m=[],S=t=>h.get(t)||l.call(e,t),M=(e,t,n)=>{const r=f.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);_=L(e,r);try{new r.constructor}finally{_=null,t()}}const o=(t?"":"dis")+"connectedCallback";o in r&&e[o]()},{parse:T}=g({query:m,handle:M}),{parse:P}=g({query:d,handle(e,t){c.has(e)&&(t?a.add(e):a.delete(e),m.length&&H.call(m,e))}}),$=e=>{if(!u.has(e)){let t,n=new q((e=>{t=e}));u.set(e,{$:n,_:t})}return u.get(e).$},I=t($,y);let _=null;function H(e){const t=c.get(e);T(t.querySelectorAll(this),e.isConnected)}D(self).filter((e=>/^HTML/.test(e))).forEach((e=>{const t=self[e];function n(){const{constructor:e}=this;if(!i.has(e))throw new N("Illegal constructor");const{is:n,tag:o}=i.get(e);if(n){if(_)return I(_,n);const t=r.call(p,o);return t.setAttribute("is",n),I(L(t,e.prototype),n)}return s.call(this,t,[],e)}L(n,t),C(n.prototype=t.prototype,"constructor",{value:n}),C(self,e,{value:n})})),C(p,"createElement",{configurable:!0,value(e,t){const n=t&&t.is;if(n){const t=h.get(n);if(t&&i.get(t).tag===e)return new t}const o=r.call(p,e);return n&&o.setAttribute("is",n),o}}),n&&(v.prototype.attachShadow=function(e){const t=n.call(this,e);return c.set(this,t),t}),C(e,"get",{configurable:!0,value:S}),C(e,"whenDefined",{configurable:!0,value:$}),C(e,"define",{configurable:!0,value(t,n,r){if(S(t))throw new O(`'${t}' has already been defined as a custom element`);let l;const s=r&&r.extends;i.set(n,s?{is:t,tag:s}:{is:"",tag:t}),s?(l=`${s}[is="${t}"]`,f.set(l,n.prototype),h.set(t,n),m.push(l)):(o.apply(e,arguments),d.push(l=t)),$(t).then((()=>{s?(T(p.querySelectorAll(l)),a.forEach(H,[l])):P(p.querySelectorAll(l))})),u.get(t)._(n)}})}}();
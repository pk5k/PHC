document.recursiveOffset = function(aobj)
{
 var currOffset = {
   x: 0,
   y: 0
 }

 var newOffset = {
     x: 0,
     y: 0
 }

 if(aobj !== null)
 {

   if(aobj.scrollLeft)
   {
     currOffset.x = aobj.scrollLeft;
   }

   if(aobj.scrollTop)
   {
     currOffset.y = aobj.scrollTop;
   }

   if(aobj.offsetLeft)
   {
     currOffset.x -= aobj.offsetLeft;
   }

   if(aobj.offsetTop)
   {
     currOffset.y -= aobj.offsetTop;
   }

   if (aobj.parentNode !== undefined)
   {
      newOffset = document.recursiveOffset(aobj.parentNode);
   }

   currOffset.x = currOffset.x + newOffset.x;
   currOffset.y = currOffset.y + newOffset.y;
   //console.log (aobj.id+' x'+currOffset.x+' y'+currOffset.y);
 }

 return currOffset;
}

//provide X/Y coordinates of the mouse over document.mouse(.x/.y)
function mouseMoved(e)
{
  if (typeof e == 'undefined' || e == null)
  {
    document.mouse = {x:0,y:0};
    return;
  }

  if (document.mouse_timeout == null || document.mouse_timeout == undefined)
  {
    var doc = document.documentElement || document.body;
    var target = e.srcElement || e.target;
    var offsetpos = document.recursiveOffset(doc);

    pos_x = e.clientX+offsetpos.x;
    pos_y = e.clientY+offsetpos.y;

    document.mouse = {
      x: pos_x,
      y: pos_y
    };

    document.mouse_timeout = setTimeout(function() 
    {

      document.mouse_timeout = null;
    }, 100);
  }
}

document.onmousemove = mouseMoved;

// add an md5-suite to our container, to not transport passwords in plain-text
/*
 * JavaScript MD5
 * https://github.com/blueimp/JavaScript-MD5
 *
 * Copyright 2011, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * https://opensource.org/licenses/MIT
 *
 * Based on
 * A JavaScript implementation of the RSA Data Security, Inc. MD5 Message
 * Digest Algorithm, as defined in RFC 1321.
 * Version 2.2 Copyright (C) Paul Johnston 1999 - 2009
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for more info.
 */

/* global define */

(function ($) {
  'use strict'

  /*
  * Add integers, wrapping at 2^32. This uses 16-bit operations internally
  * to work around bugs in some JS interpreters.
  */
  function safeAdd (x, y) {
    var lsw = (x & 0xFFFF) + (y & 0xFFFF)
    var msw = (x >> 16) + (y >> 16) + (lsw >> 16)
    return (msw << 16) | (lsw & 0xFFFF)
  }

  /*
  * Bitwise rotate a 32-bit number to the left.
  */
  function bitRotateLeft (num, cnt) {
    return (num << cnt) | (num >>> (32 - cnt))
  }

  /*
  * These functions implement the four basic operations the algorithm uses.
  */
  function md5cmn (q, a, b, x, s, t) {
    return safeAdd(bitRotateLeft(safeAdd(safeAdd(a, q), safeAdd(x, t)), s), b)
  }
  function md5ff (a, b, c, d, x, s, t) {
    return md5cmn((b & c) | ((~b) & d), a, b, x, s, t)
  }
  function md5gg (a, b, c, d, x, s, t) {
    return md5cmn((b & d) | (c & (~d)), a, b, x, s, t)
  }
  function md5hh (a, b, c, d, x, s, t) {
    return md5cmn(b ^ c ^ d, a, b, x, s, t)
  }
  function md5ii (a, b, c, d, x, s, t) {
    return md5cmn(c ^ (b | (~d)), a, b, x, s, t)
  }

  /*
  * Calculate the MD5 of an array of little-endian words, and a bit length.
  */
  function binlMD5 (x, len) {
    /* append padding */
    x[len >> 5] |= 0x80 << (len % 32)
    x[(((len + 64) >>> 9) << 4) + 14] = len

    var i
    var olda
    var oldb
    var oldc
    var oldd
    var a = 1732584193
    var b = -271733879
    var c = -1732584194
    var d = 271733878

    for (i = 0; i < x.length; i += 16) {
      olda = a
      oldb = b
      oldc = c
      oldd = d

      a = md5ff(a, b, c, d, x[i], 7, -680876936)
      d = md5ff(d, a, b, c, x[i + 1], 12, -389564586)
      c = md5ff(c, d, a, b, x[i + 2], 17, 606105819)
      b = md5ff(b, c, d, a, x[i + 3], 22, -1044525330)
      a = md5ff(a, b, c, d, x[i + 4], 7, -176418897)
      d = md5ff(d, a, b, c, x[i + 5], 12, 1200080426)
      c = md5ff(c, d, a, b, x[i + 6], 17, -1473231341)
      b = md5ff(b, c, d, a, x[i + 7], 22, -45705983)
      a = md5ff(a, b, c, d, x[i + 8], 7, 1770035416)
      d = md5ff(d, a, b, c, x[i + 9], 12, -1958414417)
      c = md5ff(c, d, a, b, x[i + 10], 17, -42063)
      b = md5ff(b, c, d, a, x[i + 11], 22, -1990404162)
      a = md5ff(a, b, c, d, x[i + 12], 7, 1804603682)
      d = md5ff(d, a, b, c, x[i + 13], 12, -40341101)
      c = md5ff(c, d, a, b, x[i + 14], 17, -1502002290)
      b = md5ff(b, c, d, a, x[i + 15], 22, 1236535329)

      a = md5gg(a, b, c, d, x[i + 1], 5, -165796510)
      d = md5gg(d, a, b, c, x[i + 6], 9, -1069501632)
      c = md5gg(c, d, a, b, x[i + 11], 14, 643717713)
      b = md5gg(b, c, d, a, x[i], 20, -373897302)
      a = md5gg(a, b, c, d, x[i + 5], 5, -701558691)
      d = md5gg(d, a, b, c, x[i + 10], 9, 38016083)
      c = md5gg(c, d, a, b, x[i + 15], 14, -660478335)
      b = md5gg(b, c, d, a, x[i + 4], 20, -405537848)
      a = md5gg(a, b, c, d, x[i + 9], 5, 568446438)
      d = md5gg(d, a, b, c, x[i + 14], 9, -1019803690)
      c = md5gg(c, d, a, b, x[i + 3], 14, -187363961)
      b = md5gg(b, c, d, a, x[i + 8], 20, 1163531501)
      a = md5gg(a, b, c, d, x[i + 13], 5, -1444681467)
      d = md5gg(d, a, b, c, x[i + 2], 9, -51403784)
      c = md5gg(c, d, a, b, x[i + 7], 14, 1735328473)
      b = md5gg(b, c, d, a, x[i + 12], 20, -1926607734)

      a = md5hh(a, b, c, d, x[i + 5], 4, -378558)
      d = md5hh(d, a, b, c, x[i + 8], 11, -2022574463)
      c = md5hh(c, d, a, b, x[i + 11], 16, 1839030562)
      b = md5hh(b, c, d, a, x[i + 14], 23, -35309556)
      a = md5hh(a, b, c, d, x[i + 1], 4, -1530992060)
      d = md5hh(d, a, b, c, x[i + 4], 11, 1272893353)
      c = md5hh(c, d, a, b, x[i + 7], 16, -155497632)
      b = md5hh(b, c, d, a, x[i + 10], 23, -1094730640)
      a = md5hh(a, b, c, d, x[i + 13], 4, 681279174)
      d = md5hh(d, a, b, c, x[i], 11, -358537222)
      c = md5hh(c, d, a, b, x[i + 3], 16, -722521979)
      b = md5hh(b, c, d, a, x[i + 6], 23, 76029189)
      a = md5hh(a, b, c, d, x[i + 9], 4, -640364487)
      d = md5hh(d, a, b, c, x[i + 12], 11, -421815835)
      c = md5hh(c, d, a, b, x[i + 15], 16, 530742520)
      b = md5hh(b, c, d, a, x[i + 2], 23, -995338651)

      a = md5ii(a, b, c, d, x[i], 6, -198630844)
      d = md5ii(d, a, b, c, x[i + 7], 10, 1126891415)
      c = md5ii(c, d, a, b, x[i + 14], 15, -1416354905)
      b = md5ii(b, c, d, a, x[i + 5], 21, -57434055)
      a = md5ii(a, b, c, d, x[i + 12], 6, 1700485571)
      d = md5ii(d, a, b, c, x[i + 3], 10, -1894986606)
      c = md5ii(c, d, a, b, x[i + 10], 15, -1051523)
      b = md5ii(b, c, d, a, x[i + 1], 21, -2054922799)
      a = md5ii(a, b, c, d, x[i + 8], 6, 1873313359)
      d = md5ii(d, a, b, c, x[i + 15], 10, -30611744)
      c = md5ii(c, d, a, b, x[i + 6], 15, -1560198380)
      b = md5ii(b, c, d, a, x[i + 13], 21, 1309151649)
      a = md5ii(a, b, c, d, x[i + 4], 6, -145523070)
      d = md5ii(d, a, b, c, x[i + 11], 10, -1120210379)
      c = md5ii(c, d, a, b, x[i + 2], 15, 718787259)
      b = md5ii(b, c, d, a, x[i + 9], 21, -343485551)

      a = safeAdd(a, olda)
      b = safeAdd(b, oldb)
      c = safeAdd(c, oldc)
      d = safeAdd(d, oldd)
    }
    return [a, b, c, d]
  }

  /*
  * Convert an array of little-endian words to a string
  */
  function binl2rstr (input) {
    var i
    var output = ''
    var length32 = input.length * 32
    for (i = 0; i < length32; i += 8) {
      output += String.fromCharCode((input[i >> 5] >>> (i % 32)) & 0xFF)
    }
    return output
  }

  /*
  * Convert a raw string to an array of little-endian words
  * Characters >255 have their high-byte silently ignored.
  */
  function rstr2binl (input) {
    var i
    var output = []
    output[(input.length >> 2) - 1] = undefined
    for (i = 0; i < output.length; i += 1) {
      output[i] = 0
    }
    var length8 = input.length * 8
    for (i = 0; i < length8; i += 8) {
      output[i >> 5] |= (input.charCodeAt(i / 8) & 0xFF) << (i % 32)
    }
    return output
  }

  /*
  * Calculate the MD5 of a raw string
  */
  function rstrMD5 (s) {
    return binl2rstr(binlMD5(rstr2binl(s), s.length * 8))
  }

  /*
  * Calculate the HMAC-MD5, of a key and some data (raw strings)
  */
  function rstrHMACMD5 (key, data) {
    var i
    var bkey = rstr2binl(key)
    var ipad = []
    var opad = []
    var hash
    ipad[15] = opad[15] = undefined
    if (bkey.length > 16) {
      bkey = binlMD5(bkey, key.length * 8)
    }
    for (i = 0; i < 16; i += 1) {
      ipad[i] = bkey[i] ^ 0x36363636
      opad[i] = bkey[i] ^ 0x5C5C5C5C
    }
    hash = binlMD5(ipad.concat(rstr2binl(data)), 512 + data.length * 8)
    return binl2rstr(binlMD5(opad.concat(hash), 512 + 128))
  }

  /*
  * Convert a raw string to a hex string
  */
  function rstr2hex (input) {
    var hexTab = '0123456789abcdef'
    var output = ''
    var x
    var i
    for (i = 0; i < input.length; i += 1) {
      x = input.charCodeAt(i)
      output += hexTab.charAt((x >>> 4) & 0x0F) +
      hexTab.charAt(x & 0x0F)
    }
    return output
  }

  /*
  * Encode a string as utf-8
  */
  function str2rstrUTF8 (input) {
    return unescape(encodeURIComponent(input))
  }

  /*
  * Take string arguments and return either raw or hex encoded strings
  */
  function rawMD5 (s) {
    return rstrMD5(str2rstrUTF8(s))
  }
  function hexMD5 (s) {
    return rstr2hex(rawMD5(s))
  }
  function rawHMACMD5 (k, d) {
    return rstrHMACMD5(str2rstrUTF8(k), str2rstrUTF8(d))
  }
  function hexHMACMD5 (k, d) {
    return rstr2hex(rawHMACMD5(k, d))
  }

  function md5 (string, key, raw) {
    if (!key) {
      if (!raw) {
        return hexMD5(string)
      }
      return rawMD5(string)
    }
    if (!raw) {
      return hexHMACMD5(key, string)
    }
    return rawHMACMD5(key, string)
  }

  if (typeof define === 'function' && define.amd) {
    define(function () {
      return md5
    })
  } else if (typeof module === 'object' && module.exports) {
    module.exports = md5
  } else {
    $.md5 = md5
  }
}(this)); 

// custom-elements-v1-polyfill:
!function(){"use strict";var e=Promise,t=(e,t)=>{const n=e=>{for(let t=0,{length:n}=e;t<n;t++)r(e[t])},r=({target:e,attributeName:t,oldValue:n})=>{e.attributeChangedCallback(t,n,e.getAttribute(t))};return(o,l)=>{const{observedAttributes:s}=o.constructor;return s&&e(l).then((()=>{new t(n).observe(o,{attributes:!0,attributeOldValue:!0,attributeFilter:s});for(let e=0,{length:t}=s;e<t;e++)o.hasAttribute(s[e])&&r({target:o,attributeName:s[e],oldValue:null})})),o}};const n=!0,r=!1,o="querySelectorAll";function l(e){this.observe(e,{subtree:n,childList:n})}const s="querySelectorAll",{document:c,Element:a,MutationObserver:i,Set:u,WeakMap:f}=self,h=e=>s in e,{filter:d}=[];var g=e=>{const t=new f,g=(n,r)=>{let o;if(r)for(let l,s=(e=>e.matches||e.webkitMatchesSelector||e.msMatchesSelector)(n),c=0,{length:a}=w;c<a;c++)s.call(n,l=w[c])&&(t.has(n)||t.set(n,new u),o=t.get(n),o.has(l)||(o.add(l),e.handle(n,r,l)));else t.has(n)&&(o=t.get(n),t.delete(n),o.forEach((t=>{e.handle(n,r,t)})))},p=(e,t=!0)=>{for(let n=0,{length:r}=e;n<r;n++)g(e[n],t)},{query:w}=e,y=e.root||c,m=((e,t,s)=>{const c=(t,r,l,s,a)=>{for(let i=0,{length:u}=t;i<u;i++){const u=t[i];(a||o in u)&&(s?r.has(u)||(r.add(u),l.delete(u),e(u,s)):l.has(u)||(l.add(u),r.delete(u),e(u,s)),a||c(u[o]("*"),r,l,s,n))}},a=new(s||MutationObserver)((e=>{for(let t=new Set,o=new Set,l=0,{length:s}=e;l<s;l++){const{addedNodes:s,removedNodes:a}=e[l];c(a,t,o,r,r),c(s,t,o,n,r)}}));return a.add=l,a.add(t||document),a})(g,y,i),{attachShadow:b}=a.prototype;return b&&(a.prototype.attachShadow=function(e){const t=b.call(this,e);return m.add(t),t}),w.length&&p(y[s](w)),{drop:e=>{for(let n=0,{length:r}=e;n<r;n++)t.delete(e[n])},flush:()=>{const e=m.takeRecords();for(let t=0,{length:n}=e;t<n;t++)p(d.call(e[t].removedNodes,h),!1),p(d.call(e[t].addedNodes,h),!0)},observer:m,parse:p}};const{document:p,Map:w,MutationObserver:y,Object:m,Set:b,WeakMap:E,Element:v,HTMLElement:S,Node:M,Error:O,TypeError:N,Reflect:A}=self,q=self.Promise||e,{defineProperty:C,keys:T,getOwnPropertyNames:D,setPrototypeOf:L}=m;let P=!self.customElements;const k=e=>{const t=T(e),n=[],{length:r}=t;for(let o=0;o<r;o++)n[o]=e[t[o]],delete e[t[o]];return()=>{for(let o=0;o<r;o++)e[t[o]]=n[o]}};if(P){const{createElement:n}=p,r=new w,o=new w,l=new w,s=new w,c=[],a=(e,t,n)=>{const r=l.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);u=L(e,r);try{new r.constructor}finally{u=null,t()}}const o=(t?"":"dis")+"connectedCallback";o in r&&e[o]()},{parse:i}=g({query:c,handle:a});let u=null;const f=t=>{if(!o.has(t)){let n,r=new e((e=>{n=e}));o.set(t,{$:r,_:n})}return o.get(t).$},h=t(f,y);function $(){const{constructor:e}=this;if(!r.has(e))throw new N("Illegal constructor");const t=r.get(e);if(u)return h(u,t);const o=n.call(p,t);return h(L(o,e.prototype),t)}C(self,"customElements",{configurable:!0,value:{define:(e,t)=>{if(s.has(e))throw new O(`the name "${e}" has already been used with this registry`);r.set(t,e),l.set(e,t.prototype),s.set(e,t),c.push(e),f(e).then((()=>{i(p.querySelectorAll(e))})),o.get(e)._(t)},get:e=>s.get(e),whenDefined:f}}),C($.prototype=S.prototype,"constructor",{value:$}),C(self,"HTMLElement",{configurable:!0,value:$}),C(p,"createElement",{configurable:!0,value(e,t){const r=t&&t.is,o=r?s.get(r):s.get(e);return o?new o:n.call(p,e)}}),"isConnected"in M.prototype||C(M.prototype,"isConnected",{configurable:!0,get(){return!(this.ownerDocument.compareDocumentPosition(this)&this.DOCUMENT_POSITION_DISCONNECTED)}})}else try{function I(){return self.Reflect.construct(HTMLLIElement,[],I)}I.prototype=HTMLLIElement.prototype;const e="extends-li";self.customElements.define("extends-li",I,{extends:"li"}),P=p.createElement("li",{is:e}).outerHTML.indexOf(e)<0;const{get:t,whenDefined:n}=self.customElements;C(self.customElements,"whenDefined",{configurable:!0,value(e){return n.call(this,e).then((n=>n||t.call(this,e)))}})}catch(e){P=!P}if(P){const e=self.customElements,{attachShadow:n}=v.prototype,{createElement:r}=p,{define:o,get:l}=e,{construct:s}=A||{construct(e){return e.call(this)}},c=new E,a=new b,i=new w,u=new w,f=new w,h=new w,d=[],m=[],S=t=>h.get(t)||l.call(e,t),M=(e,t,n)=>{const r=f.get(n);if(t&&!r.isPrototypeOf(e)){const t=k(e);_=L(e,r);try{new r.constructor}finally{_=null,t()}}const o=(t?"":"dis")+"connectedCallback";o in r&&e[o]()},{parse:T}=g({query:m,handle:M}),{parse:P}=g({query:d,handle(e,t){c.has(e)&&(t?a.add(e):a.delete(e),m.length&&H.call(m,e))}}),$=e=>{if(!u.has(e)){let t,n=new q((e=>{t=e}));u.set(e,{$:n,_:t})}return u.get(e).$},I=t($,y);let _=null;function H(e){const t=c.get(e);T(t.querySelectorAll(this),e.isConnected)}D(self).filter((e=>/^HTML/.test(e))).forEach((e=>{const t=self[e];function n(){const{constructor:e}=this;if(!i.has(e))throw new N("Illegal constructor");const{is:n,tag:o}=i.get(e);if(n){if(_)return I(_,n);const t=r.call(p,o);return t.setAttribute("is",n),I(L(t,e.prototype),n)}return s.call(this,t,[],e)}L(n,t),C(n.prototype=t.prototype,"constructor",{value:n}),C(self,e,{value:n})})),C(p,"createElement",{configurable:!0,value(e,t){const n=t&&t.is;if(n){const t=h.get(n);if(t&&i.get(t).tag===e)return new t}const o=r.call(p,e);return n&&o.setAttribute("is",n),o}}),n&&(v.prototype.attachShadow=function(e){const t=n.call(this,e);return c.set(this,t),t}),C(e,"get",{configurable:!0,value:S}),C(e,"whenDefined",{configurable:!0,value:$}),C(e,"define",{configurable:!0,value(t,n,r){if(S(t))throw new O(`'${t}' has already been defined as a custom element`);let l;const s=r&&r.extends;i.set(n,s?{is:t,tag:s}:{is:"",tag:t}),s?(l=`${s}[is="${t}"]`,f.set(l,n.prototype),h.set(t,n),m.push(l)):(o.apply(e,arguments),d.push(l=t)),$(t).then((()=>{s?(T(p.querySelectorAll(l)),a.forEach(H,[l])):P(p.querySelectorAll(l))})),u.get(t)._(n)}})}}();

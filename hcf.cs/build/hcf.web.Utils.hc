<?php #HYPERCELL hcf.web.Utils - BUILD 22.03.28#32
namespace hcf\web;
class Utils extends \hcf\web\Controller {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Utils';
    const NAME = 'Utils';
    public function __construct() {
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "class{static extendHTMLElements(){HTMLElement.prototype.find=function(elem_with_id){if(elem_with_id==null||elem_with_id==undefined||elem_with_id==''){return null;}
return this.getRootNode().getElementById(elem_with_id);}
HTMLElement.prototype.elemHost=function(){return this.getRootNode().host;}
let addEventListenerFunc=function(a,b,c){if(c==undefined){c=false;}
this._addEventListener(a,b,c);if(!this._event_registry){this._event_registry={};}
if(!this._event_registry[a]){this._event_registry[a]=[];}
this._event_registry[a].push({type:a,listener:b,options:c});};let removeEventListenerFunc=function(a,b,c){if(c==undefined){c=false;}
this._removeEventListener(a,b,c);let reg=this.eventRegistry(a);for(let i in reg){let event=reg[i];if(event.listener==b&&event.options==c){if(this instanceof Document){console.log('remove',a,b,c);}
this._event_registry[a][i].type=null;this._event_registry[a][i].listener=null;this._event_registry[a][i].options=null;this._event_registry[a][i]=null;delete this._event_registry[a][i];if(this._event_registry[a].length==0){delete this._event_registry[a];}}}};let eventRegistryFunc=function(for_event){if(this._event_registry==undefined){return[];}
if(for_event==undefined){let ev_arr=this._event_registry;let list=[];for(let ev_type in ev_arr){ev_arr[ev_type].forEach((ev)=>list.push(ev));}
return list;}
if(this._event_registry[for_event]==undefined){return[];}
return this._event_registry[for_event];};let removeEventListenersFunc=function(for_event){this.eventRegistry(for_event).forEach((ev_data)=>{this.removeEventListener(ev_data.type,ev_data.listener,ev_data.options);});};Window.prototype._addEventListener=Window.prototype.addEventListener;Window.prototype.addEventListener=addEventListenerFunc;Window.prototype._removeEventListener=Window.prototype.removeEventListener;Window.prototype.removeEventListener=removeEventListenerFunc;Window.prototype.eventRegistry=eventRegistryFunc;Window.prototype.removeEventListeners=removeEventListenersFunc;EventTarget.prototype._addEventListener=EventTarget.prototype.addEventListener;EventTarget.prototype.addEventListener=addEventListenerFunc;EventTarget.prototype._removeEventListener=EventTarget.prototype.removeEventListener;EventTarget.prototype.removeEventListener=removeEventListenerFunc;EventTarget.prototype.eventRegistry=eventRegistryFunc;EventTarget.prototype.removeEventListeners=removeEventListenersFunc;}
static registerMd5Module(\$){function safeAdd(x,y){var lsw=(x&0xFFFF)+(y&0xFFFF)
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
if(typeof define==='function'&&define.amd){define(function(){return md5})}else if(typeof module==='object'&&module.exports){module.exports=md5}else{\$.md5=md5}}
static recursiveOffset(aobj){let me=hcf.web.Utils;var currOffset={x:0,y:0}
var newOffset={x:0,y:0}
if(aobj!==null){if(aobj.scrollLeft){currOffset.x=aobj.scrollLeft;}
if(aobj.scrollTop){currOffset.y=aobj.scrollTop;}
if(aobj.offsetLeft){currOffset.x-=aobj.offsetLeft;}
if(aobj.offsetTop){currOffset.y-=aobj.offsetTop;}
if(aobj.parentNode!==undefined){newOffset=me.recursiveOffset(aobj.parentNode);}
currOffset.x=currOffset.x+newOffset.x;currOffset.y=currOffset.y+newOffset.y;}
return currOffset;}
static cursor(){return hcf.web.Utils._cursor;}
static registerCursorMoved(){document.onmousemove=hcf.web.Utils.cursorMoved;}
static cursorMoved(e){let me=hcf.web.Utils;if(typeof e=='undefined'||e==null){me._cursor={x:0,y:0};return;}
if(me.cursor_timeout==null||me.cursor_timeout==undefined){var doc=document.documentElement||document.body;var target=e.srcElement||e.target;var offsetpos=me.recursiveOffset(doc);let pos_x=e.clientX+offsetpos.x;let pos_y=e.clientY+offsetpos.y;me._cursor={x:pos_x,y:pos_y};me.cursor_timeout=setTimeout(function(){me.cursor_timeout=null;},100);}}
static getUrlVars(){var vars={};var parts=window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,function(m,key,value){vars[key]=value;});return vars;}}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    
    }
    namespace hcf\web\Utils\__EO__;
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
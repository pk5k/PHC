<?php #HYPERCELL hcf.web.Bridge.Worker.FormDataPolyfill - BUILD 22.01.26#11
namespace hcf\web\Bridge\Worker;
class FormDataPolyfill {
    use \hcf\core\dryver\Controller, \hcf\core\dryver\Controller\Js, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Bridge.Worker.FormDataPolyfill';
    const NAME = 'FormDataPolyfill';
    public function __construct() {
    }
    # BEGIN ASSEMBLY FRAME CONTROLLER.JS
    public static function script() {
        $js = "if(typeof Blob!=='undefined'&&(typeof FormData==='undefined'||!FormData.prototype.keys)){const global=typeof window==='object'?window:typeof self==='object'?self:this
const _FormData=global.FormData
const _send=global.XMLHttpRequest&&global.XMLHttpRequest.prototype.send
const _fetch=global.Request&&global.fetch
const _sendBeacon=global.navigator&&global.navigator.sendBeacon
const stringTag=global.Symbol&&Symbol.toStringTag
if(stringTag){if(!Blob.prototype[stringTag]){Blob.prototype[stringTag]='Blob'}
if('File'in global&&!File.prototype[stringTag]){File.prototype[stringTag]='File'}}
try{new File([],'')}catch(a){global.File=function File(b,d,c){const blob=new Blob(b,c)
const t=c&&void 0!==c.lastModified?new Date(c.lastModified):new Date()
Object.defineProperties(blob,{name:{value:d},lastModifiedDate:{value:t},lastModified:{value:+t},toString:{value(){return'[object File]'}}})
if(stringTag){Object.defineProperty(blob,stringTag,{value:'File'})}
return blob}}
function normalizeValue([name,value,filename]){if(value instanceof Blob){value=new File([value],filename,{type:value.type,lastModified:value.lastModified})}
return[name,value]}
function ensureArgs(args,expected){if(args.length<expected){throw new TypeError(`\${expected} argument required, but only \${args.length} present.`)}}
function normalizeArgs(name,value,filename){return value instanceof Blob?[String(name),value,filename!==undefined?filename+'':typeof value.name==='string'?value.name:'blob']:[String(name),String(value)]}
function normalizeLinefeeds(value){return value.replace(/\\r\\n/g,'\\n').replace(/\\n/g,'\\r\\n')}
function each(arr,cb){for(let i=0;i<arr.length;i++){cb(arr[i])}}
class FormDataPolyfill{constructor(form){this._data=[]
if(!form)return this
const self=this
each(form.elements,elm=>{if(!elm.name||elm.disabled||elm.type==='submit'||elm.type==='button')return
if(elm.type==='file'){const files=elm.files&&elm.files.length?elm.files:[new File([],'',{type:'application/octet-stream'})]
each(files,file=>{self.append(elm.name,file)})}else if(elm.type==='select-multiple'||elm.type==='select-one'){each(elm.options,opt=>{!opt.disabled&&opt.selected&&self.append(elm.name,opt.value)})}else if(elm.type==='checkbox'||elm.type==='radio'){if(elm.checked)self.append(elm.name,elm.value)}else{const value=elm.type==='textarea'?normalizeLinefeeds(elm.value):elm.value
self.append(elm.name,value)}})}
append(name,value,filename){ensureArgs(arguments,2)
var[a,s,d]=normalizeArgs.apply(null,arguments)
this._data.push([a,s,d])}
delete(name){ensureArgs(arguments,1)
const res=[]
name=String(name)
each(this._data,entry=>{if(entry[0]!==name){res.push(entry)}})
this._data=res}*entries(){for(var i=0;i<this._data.length;i++){yield normalizeValue(this._data[i])}}
forEach(callback,thisArg){ensureArgs(arguments,1)
for(const[name,value]of this){callback.call(thisArg,value,name,this)}}
get(name){ensureArgs(arguments,1)
const entries=this._data
name=String(name)
for(let i=0;i<entries.length;i++){if(entries[i][0]===name){return normalizeValue(this._data[i])[1]}}
return null}
getAll(name){ensureArgs(arguments,1)
const result=[]
name=String(name)
for(let i=0;i<this._data.length;i++){if(this._data[i][0]===name){result.push(normalizeValue(this._data[i])[1])}}
return result}
has(name){ensureArgs(arguments,1)
name=String(name)
for(let i=0;i<this._data.length;i++){if(this._data[i][0]===name){return true}}
return false}*keys(){for(const[name]of this){yield name}}
set(name,value,filename){ensureArgs(arguments,2)
name=String(name)
const result=[]
let replaced=false
for(let i=0;i<this._data.length;i++){const match=this._data[i][0]===name
if(match){if(!replaced){result[i]=normalizeArgs.apply(null,arguments)
replaced=true}}else{result.push(this._data[i])}}
if(!replaced){result.push(normalizeArgs.apply(null,arguments))}
this._data=result}*values(){for(const[,value]of this){yield value}}
['_asNative'](){const fd=new _FormData()
for(const[name,value]of this){fd.append(name,value)}
return fd}
['_blob'](){const boundary='----formdata-polyfill-'+Math.random()
const chunks=[]
for(const[name,value]of this){chunks.push(`--\${boundary}\\r\\n`)
if(value instanceof Blob){chunks.push(`Content-Disposition: form-data; name=\"\${name}\"; filename=\"\${value.name}\"\\r\\n`,`Content-Type: \${value.type || 'application/octet-stream'}\\r\\n\\r\\n`,value,'\\r\\n')}else{chunks.push(`Content-Disposition: form-data; name=\"\${name}\"\\r\\n\\r\\n\${value}\\r\\n`)}}
chunks.push(`--\${boundary}--`)
return new Blob(chunks,{type:'multipart/form-data; boundary='+boundary})}
[Symbol.iterator](){return this.entries()}
toString(){return'[object FormData]'}}
if(stringTag){FormDataPolyfill.prototype[stringTag]='FormData'}
if(_send){const setRequestHeader=global.XMLHttpRequest.prototype.setRequestHeader
global.XMLHttpRequest.prototype.setRequestHeader=function(name,value){setRequestHeader.call(this,name,value)
if(name.toLowerCase()==='content-type')this._hasContentType=true}
global.XMLHttpRequest.prototype.send=function(data){if(data instanceof FormDataPolyfill){const blob=data['_blob']()
if(!this._hasContentType)this.setRequestHeader('Content-Type',blob.type)
_send.call(this,blob)}else{_send.call(this,data)}}}
if(_fetch){const _fetch=global.fetch
global.fetch=function(input,init){if(init&&init.body&&init.body instanceof FormDataPolyfill){init.body=init.body['_blob']()}
return _fetch.call(this,input,init)}}
if(_sendBeacon){global.navigator.sendBeacon=function(url,data){if(data instanceof FormDataPolyfill){data=data['_asNative']()}
return _sendBeacon.call(this,url,data)}}
global['FormData']=FormDataPolyfill}";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.JS
    
    }
    namespace hcf\web\Bridge\Worker\FormDataPolyfill\__EO__;
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



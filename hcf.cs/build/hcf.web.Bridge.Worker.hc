<?php #HYPERCELL hcf.web.Bridge.Worker - BUILD 22.01.24#29
namespace hcf\web\Bridge;
class Worker {
    use \hcf\core\dryver\Client, \hcf\core\dryver\Client\Js, Worker\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Bridge.Worker';
    const NAME = 'Worker';
    public function __construct() {
        if (method_exists($this, 'hcfwebBridgeWorker_onConstruct')) {
            call_user_func_array([$this, 'hcfwebBridgeWorker_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CLIENT.JS
    public static function script() {
        $js = "onmessage=function(e){var data=e.data;var http_request=false;var timeout=4000;var info=false;var http_request=new XMLHttpRequest();timeout=(!isNaN(data.overwrites.timeout))?data.overwrites.timeout:timeout;http_request.ontimeout=function(){returnToHost('timeout',0,null);}
http_request.onreadystatechange=function(){if(http_request.readyState==4&&http_request.status<=300&&http_request.status>=100){var response=http_request.responseText;if(info){console.log('Request was successful - response data:');console.log((response.length>0)?response:'no data was sent');}
if(data.overwrites.eval){_eval(response,false);}
returnToHost('success',http_request.status,response);}
else if(http_request.readyState==4&&http_request.status>=400){if(info){console.log('Request failed - Server returned code '+http_request.status+' with following response data:');console.log((http_request.responseText.length>0)?http_request.responseText:'no data was sent');}
returnToHost('error',http_request.status,http_request.responseText);}}
var send_data=argsToFormData(data.args,data.files);http_request.open('POST',data._.route,true);http_request.setRequestHeader(data._.header.action,data._.action);http_request.setRequestHeader(data._.header.target,data._.target);http_request.setRequestHeader(data._.header.method,data._.method);http_request.timeout=timeout;http_request.send(send_data);function returnToHost(result,code,response_data){var ret_obj={token:data._.token};switch(result){case'timeout':case'error':case'success':ret_obj.result=result;ret_obj.code=code;ret_obj.data=response_data;break;default:throw'Invalid result \"'+result+'\" given.';}
postMessage(ret_obj);}
function argsToFormData(args,files){var fd=new FormData();for(var key in args){if(args.hasOwnProperty(key)&&args[key]!==undefined){var value=args[key];if(value!==null&&value.constructor==Object){value=JSON.stringify(value);}
fd.append(key,value);}}
for(var i in files){var file=files[i];fd.append(file.name,file);}
return fd;}
function _eval(scripts,plain){try{if(scripts!=''){var script=\"\";if(plain!==undefined&&plain===true){script=scripts;}
else{scripts=scripts.replace(/<script[^>]*>([\s\S]*?)<\/script>/gi,function(){if(scripts!==null){script+=arguments[1]+'\\n';}
return'';});}
if(script){if(execScript){execScript(script);}
else{eval(script);}
return true;}}
return false;}
catch(e){console.error('Eval error in following data: '+scripts);}}};";
        return $js;
    }
    # END ASSEMBLY FRAME CLIENT.JS
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "{$__CLASS__::_call('render', $__CLASS__, $_this) }";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
    }
    namespace hcf\web\Bridge\Worker\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\web\Bridge\Worker\FormDataPolyfill;
    trait Controller {
        public static function render() {
            header('Content-Type: ' . Utils::getMimeTypeByExtension('iAmJavascript.js'));
            // we need the FormData-Polyfill until Browsers like Safari support them inside workers
            return FormDataPolyfill::script() . self::script();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



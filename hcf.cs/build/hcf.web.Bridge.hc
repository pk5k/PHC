<?php #HYPERCELL hcf.web.Bridge - BUILD 22.01.24#3310
namespace hcf\web;
class Bridge {
    use \hcf\core\dryver\Client, \hcf\core\dryver\Client\Js, \hcf\core\dryver\Config, Bridge\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Bridge';
    const NAME = 'Bridge';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfwebBridge_onConstruct')) {
            call_user_func_array([$this, 'hcfwebBridge_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CLIENT.JS
    public static function script() {
        $js = "document.Bridge=function(to){var self=this;var _internal_route='?!=-bridge';var _worker_address='hcf.web.Bridge.Worker';var _worker_store=_worker_address+'.Store';var _header={action:\"X-Bridge-Action\",target:\"X-Bridge-Target\",method:\"X-Bridge-Method\"};self._target=to;self._action=undefined;self._method=undefined;if(document[_worker_address]==undefined&&window.Worker){document[_worker_address]=new Worker(_internal_route);document[_worker_address].onmessage=receiveWorkerMessage;}
else if(!window.Worker){console.warn('Your Browser does not support WebWorkers - all requests will be executed on the main-thread.');}
if(document[_worker_store]==undefined){document[_worker_store]={};}
self.do=function(arg_obj){var prepared_data=prepareSend(arg_obj,false);send(prepared_data.url_args,prepared_data.passed_files,prepared_data.overwrites,prepared_data.callbacks);return self;}
self.letDo=function(arg_obj){if(!window.Worker||!document[_worker_address]){return self.do(arg_obj);}
var prepared_data=prepareSend(arg_obj,true);var req_token=new Date().getTime();document[_worker_store][req_token]=prepared_data;document[_worker_address].postMessage({_:{token:req_token,route:_internal_route,header:_header,target:self.target(),action:self.action(),method:self.method()},overwrites:prepared_data.overwrites,args:prepared_data.url_args,files:prepared_data.passed_files});return self;}
function receiveWorkerMessage(e){var token=e.data.token;if(document[_worker_store]==undefined){throw'Missing worker-store at document['+_worker_store+']';}
else if(document[_worker_store][token]==undefined){throw'Missing worker-store-data at document['+_worker_store+']['+token+']';}
var stored_data=document[_worker_store][token];var callbacks=stored_data.callbacks;var overwrites=stored_data.overwrites;switch(e.data.result){case'success':if(callbacks.success){callbacks.success(e.data.data);}
break;case'error':if(callbacks.error){callbacks.error(e.data.data, e.data.code);}
else{throw'WebWorker-request failed with response-code '+e.data.code+'.';}
break;case'timeout':if(callbacks.timeout){callbacks.timeout(e.data.data);}
else{throw'WebWorker-request timed out.';}
break;default:throw'WebWorker-request returned unknown result \"'+e.data.result+'\"';}
delete document[_worker_store][token];}
function prepareSend(arg_obj,for_worker){if(arg_obj===undefined){arg_obj={};}
if(self.action()===undefined){throw'No action specified';}
var prepared_data={callbacks:getCallbacks(arg_obj,for_worker),overwrites:getOverwrites(arg_obj,for_worker),passed_files:getFiles(arg_obj),url_args:{}};var passed_args=getArguments(arg_obj);for(var key in passed_args){if(prepared_data.url_args.hasOwnProperty(key)){throw'Cannot use argument '+key+' - this argument is used by the bridge for internally routing';}
prepared_data.url_args[key]=passed_args[key];}
return prepared_data;}
self.invoke=function(method,implicit_constructor){if(method===undefined){throw'No method specified that should be invoked in '+self.target;}
if(implicit_constructor===true){method=method+'#implicit';}
return self.action('invoke').method(method);}
self.render=function(){return self.action('render').method(null);}
self.action=function(action){if(action===undefined){return self._action;}
self._action=action;return self;}
self.target=function(target){if(target===undefined){return self._target;}
self._target=target;return self;}
self.method=function(method){if(method===undefined){return self._method;}
self._method=method;return self;}
function getArguments(p_obj){var passed_args=[];if(p_obj.arguments!=undefined&&p_obj.arguments.constructor!=Array&&p_obj.arguments.constructor!=Object){throw'Passed argument list is not of type array nor object';}
else if(p_obj!=undefined){passed_args=p_obj.arguments;}
return passed_args;}
function getFiles(p_obj){var passed_files=[];if(p_obj.files!=undefined&&p_obj.files.constructor!=Array){throw'Passed file list is not of type array';}
else if(p_obj!=undefined){passed_files=p_obj.files;}
return passed_files;}
function getCallbacks(p_obj,for_worker){var callbacks={};if(p_obj!==undefined){var success=p_obj.onSuccess||false;var error=p_obj.onError||false;var timeout=p_obj.onTimeout||false;var upload=p_obj.onUpload||false;var download=p_obj.onDownload||false;var before=p_obj.onBefore||false;if(success){callbacks.success=success;}
if(error){callbacks.error=error;}
if(timeout){callbacks.timeout=timeout;}
if(upload){callbacks.upload=upload;if(for_worker){throw'WebWorker requests can\'t use the upload-callback';}}
if(download){callbacks.download=download;if(for_worker){throw'WebWorker requests can\'t use the download-callback';}}
if(before){callbacks.before=before;if(for_worker){throw'WebWorker requests can\'t use the before-callback';}}}
return callbacks;}
function getOverwrites(p_obj,for_worker){var overwrites={};if(p_obj!==undefined){var xhr=p_obj.xhr||false;var method=p_obj.method||false;var eval=p_obj.eval||false;var timeout=undefined;if(!isNaN(p_obj.timeout)){timeout=Number(p_obj.timeout);}
if(p_obj.async!==undefined&&p_obj.async!==null){overwrites.async=p_obj.async;}
if(xhr){overwrites.xhr=xhr;if(for_worker){throw'WebWorker requests cant override the XHR-object';}}
if(method){overwrites.method=method;if(for_worker){throw'WebWorker requests cant override the request-method';}}
if(!isNaN(timeout)){overwrites.timeout=timeout;}
if(eval){overwrites.eval=eval;}}
return overwrites;}
function argsToFormData(args,files){var fd=new FormData();for(var key in args){if(args.hasOwnProperty(key)&&args[key]!==undefined){var value=args[key];if(value!==null&&value.constructor==Object){value=JSON.stringify(value);}
fd.append(key,value);}}
for(var i in files){var file=files[i];fd.append(file.name,file);}
return fd;}
function send(args,files,overwrites,callbacks){var http_request=false;var async=true;var req_method='POST';var timeout=4000;var eval_reponse=false;var info=false;if(overwrites!==undefined&&overwrites!==null){http_request=overwrites.xhr||http_request;req_method=overwrites.method||req_method;timeout=(!isNaN(overwrites.timeout))?overwrites.timeout:timeout;eval=overwrites.eval||eval;if(overwrites.async!==undefined&&overwrites.async!==null){async=overwrites.async;}}
if(callbacks===undefined||callbacks===null){callbacks={};}
if(!http_request){if(window.XMLHttpRequest){http_request=new XMLHttpRequest();}
else{http_request=new ActiveXObject('Microsoft.XMLHTTP');}}
if(http_request.ontimeout===undefined||http_request.ontimeout===null){http_request.ontimeout=function(){if(callbacks.timeout){callbacks.timeout(http_request);}
else{throw'Request timed out';}}}
if(callbacks.upload){http_request.upload.onprogress=function(e){callbacks.upload(e,http_request);}}
var evalClosure=null;if(eval_reponse){evalClosure=eval;}
if(http_request.onreadystatechange===null){http_request.onreadystatechange=function(){if(http_request.readyState==4&&http_request.status<=300&&http_request.status>=100){var response=http_request.responseText;if(info){console.log('Request was successful - response data:');console.log((response.length>0)?response:'no data was sent');}
if(eval_reponse){evalClosure(response,false);}
if(callbacks.success){callbacks.success(response);}}
else if(http_request.readyState==4&&http_request.status>=400){if(info){console.log('Request failed - Server returned code '+http_request.status+' with following response data:');console.log((http_request.responseText.length>0)?http_request.responseText:'no data was sent');}
if(callbacks.error){callbacks.error(http_request.responseText,http_request.status);}}
else if(http_request.readyState==3){if(callbacks.download){callbacks.download(http_request.responseText);}
if(info){console.log('Receiving response-part:');console.log(http_request.responseText);}}}}
else{if(callbacks.success||callbacks.error){console.warn('Useless callback given in send - XMLHttpRequest.onreadystatechange is overwritten by custom XHR in overwrites-object - callbacks inside the callback-object will be ignored');}}
if(callbacks.before){var before_ret=callbacks.before(http_request);if(before_ret!==undefined){if(before_ret===false){return;}
else if(before_ret.constructor===XMLHttpRequest){http_request=before_ret;}}}
var data=argsToFormData(args,files);http_request.open(req_method,_internal_route,async);http_request.setRequestHeader(_header.action,self.action());http_request.setRequestHeader(_header.target,self.target());http_request.setRequestHeader(_header.method,self.method());if(async){http_request.timeout=timeout;}
http_request.send(data);}
function eval(scripts,plain){try{if(scripts!=''){var script=\"\";if(plain!==undefined&&plain===true){script=scripts;}
else{scripts=scripts.replace(/<script[^>]*>([\s\S]*?)<\/script>/gi,function(){if(scripts!==null){script+=arguments[1]+'\\n';}
return'';});}
if(script){if(window.execScript){window.execScript(script);}
else{window.eval(script);}
return true;}}
return false;}
catch(e){console.error('Eval error in following data: '+scripts);}}
return self;}";
        return $js;
    }
    # END ASSEMBLY FRAME CLIENT.JS
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "{$__CLASS__::_property('output', $__CLASS__, $_this) }";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
    }
    namespace hcf\web\Bridge\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\log\Internal as InternalLogger;
    use \hcf\core\remote\Invoker as RemoteInvoker;
    use \hcf\core\Utils as Utils;
    /**
     * Server
     * This is the Bridge from http to the Hypercell framework
     *
     * @category Remote method invocation / http communication
     * @package hcf.access.http.Bridge
     * @author Philipp Kopf
     * @version 1.0.0
     */
    trait Controller {
        private $output = '';
        private $header_sent = false;
        /**
         * __construct
         * Sets up the instance and defines the http-response by a given list of arguments
         *
         * @param args - array - arguments which decide the target-Hypercell and what happens with it
         */
        public function hcfwebBridge_onConstruct() {
            try {
                $this->setup();
                $args = self::getArgs();
                if (!isset($args) || !is_array($args)) {
                    throw new \RuntimeException('Passed argument-array for Hypercell ' . self::FQN . ' is not a valid array');
                }
                $this->action($args);
            }
            catch(\Exception $e) {
                $this->sendHeader(500);
                throw $e;
            }
        }
        /**
         * getArgs
         * Get the arguments, the bridge should work with
         *
         * @throws RuntimeException
         * @return array - the arguments, the bridge should work with
         */
        private static function getArgs() {
            if (!isset($_POST)) {
                return [];
            }
            return $_POST;
        }
        /**
         * setup
         * checks if the config.ini is ok for further processing
         *
         * @throws RuntimeException
         * @return void
         */
        private function setup() {
            if (Utils::parseByteString(ini_get('post_max_size')) > 0 && Utils::parseByteString(ini_get('post_max_size')) < Utils::parseByteString(ini_get('upload_max_filesize'))) {
                InternalLogger::log()->warn(self::FQN . ' - your php.ini setting "post_max_size" is neither set to 0 nor is it higher than the allowed "upload_max_filesize" configuration - this may lead to a loss of information when uploading big files trough ' . self::FQN);
            }
            $config = self::config();
            if (!isset($config)) {
                throw new \RuntimeException('Cannot find config for Hypercell ' . self::FQN);
            }
            if (!isset($config->header->target)) {
                throw new \RuntimeException('Hypercell ' . self::FQN . ' does not contain configuration for "header.target" - cannot proceed');
            }
            if (!isset($config->header->method)) {
                throw new \RuntimeException('Hypercell ' . self::FQN . ' does not contain configuration for "header.target" - cannot proceed');
            }
        }
        /**
         * action
         * Triggers an action, decided by a list of passed arguments
         * if target can't be decided, a 404 http-response will be sent
         *
         * @param args - array which decides the action that should be performed
         *
         * @throws RuntimeException
         * @return void
         */
        public function action($args) {
            $config = self::config();
            $action = null;
            $section = null;
            $whitelist = null;
            $target = null;
            $method_header = 'HTTP_' . strtoupper(str_replace('-', '_', $config->header->method));
            $target_header = 'HTTP_' . strtoupper(str_replace('-', '_', $config->header->target));
            if (!isset($_SERVER[$target_header])) {
                $this->sendHeader(400);
                throw new \Exception(self::FQN . ' - unable to find "target" http-header "' . $target_header . '"');
            }
            if (!isset($_SERVER[$method_header])) {
                $this->sendHeader(400);
                throw new \Exception(self::FQN . ' - unable to find "method" http-header "' . $method_header . '"');
            }
            $target = $_SERVER[$target_header];
            $method = $_SERVER[$method_header];
            if (!isset($config->allow) || !is_array($config->allow)) {
                throw new \RuntimeException(self::FQN . ' - missing whitelist "allow" in configuration.');
            }
            $allow = false;
            foreach ($config->allow as $allowed_pattern) {
                if (fnmatch($allowed_pattern, $target)) {
                    $allow = true;
                    break;
                }
            }
            if (!$allow) {
                $this->sendHeader(403);
                throw new \RuntimeException(self::FQN . ' - target-Hypercell "' . $target . '" is not on the whitelist');
            }
            $output = $this->httpInvoke($target, $method, $args);
            $this->setOutput($output);
            // now output this Hypercell to send the response
            
        }
        /**
         * setOutput
         * Converts a given value to it's string-representation and defines the output property for the http-response
         *
         * @param data - mixed - the data which should be converted to a string
         *
         * @return void
         */
        private function setOutput($data) {
            if (is_numeric($data) || is_string($data)) {
                $this->output = $data;
            } else if (is_bool($data)) {
                $this->output = ($data) ? 'true' : 'false';
            } else if (is_object($data)) {
                $this->output = serialize($data);
            } else if (is_array($data)) {
                $this->output = '[' . implode(', ', $data) . ']';
            } else {
                $type = gettype($data);
                throw new \RuntimeException('data-type "' . $data . '" cannot be converted into string');
            }
        }
        /**
         * sendHeader
         * sends a given http-header via header(...)
         *
         * @param header_code - int - the code-number of the http-header (e.g. 500 for Internal Server Error)
         *
         * @return void
         */
        private function sendHeader($header_code) {
            if (!$this->header_sent) {
                $header = Utils::getHTTPHeader($header_code);
                header($header);
                $this->header_sent = true;
            }
        }
        /**
         * httpInvoke
         * Invokes a given method of the target
         *
         * @param section - object - the config-section which leads to this method
         * @param target - string - the target-Hypercell for this action
         * @param args - array - the argument array which was used for this routing
         *
         * @return mixed - data, which should be send as http-response
         */
        private function httpInvoke($target, $method, $args) {
            if (strpos($method, '#') === false) {
                // dont trigger the constructor for this
                RemoteInvoker::implicitConstructor(false);
            } else {
                list($method, $flag) = explode('#', $method);
                switch (strtolower($flag)) {
                    case 'implicit':
                        RemoteInvoker::implicitConstructor(true);
                    break;
                    default:
                        InternalLogger::log()->warn(self::FQN . ' - found flag offset, but given flag "' . $flag . '" is unknown.');
                        RemoteInvoker::implicitConstructor(false);
                }
            }
            $invoker = new RemoteInvoker($target, $args);
            return $invoker->invoke($method, $args);
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

; name of a http header, which indicates the hypercell which should be used
header.target = 'X-Bridge-Target'

; name of a http header, which indicates the method which should be executed
header.method = 'X-Bridge-Method'

; fqns which can be accessed by this action - if the target is not inside this list,
; the action will fail (with HTTP-response code 403 - forbidden)
; this is for security-reasons, to avoid executing any class somebody wants
; wildcards are possible to match fqn patterns
allow = ['your_package.*']



END[CONFIG.INI]


?>



<?php #HYPERCELL hcf.web.Bridge - BUILD 21.07.11#3308
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
    # BEGIN ASSEMBLY FRAME CLIENT.TS
    public static function script() {
        $js = "define(\"hcf.web.Bridge\",[\"require\",\"exports\"],function(require,exports){\"use strict\";Object.defineProperty(exports,\"__esModule\",{value:true});exports.BridgeRequest=void 0;function setup(to){return new BridgeRequest(to);}
exports.default=setup;class BridgeRequest extends XMLHttpRequest{constructor(to){super();this.internal_route='?!=-bridge';this._target='';this._method='';this.header={target:\"X-Bridge-Target\",method:\"X-Bridge-Method\"};this.to(to);}
to(hypercell){this.target(hypercell);return this;}
do(arg_obj){var prepared_data=this.prepareSend(arg_obj);return this.executeRequest(prepared_data.url_args,prepared_data.passed_files,prepared_data.overwrites,prepared_data.callbacks);}
prepareSend(arg_obj){if(this._method==''){throw'No action specified, use .invoke or .render';}
let prepared_data={callbacks:this.getCallbacks(arg_obj),overwrites:this.getOverwrites(arg_obj),passed_files:this.getFiles(arg_obj),url_args:this.getArguments(arg_obj)};return prepared_data;}
method(method){this._method=method;return this;}
invoke(method,implicit_constructor){if(implicit_constructor===true){method=method+'#implicit';}
return this.method(method);}
render(){return this.invoke('toString',true);}
target(target){this._target=target;return this;}
getArguments(p_obj){let passed_args=[];if(p_obj.arguments!=undefined&&p_obj.arguments.constructor!=Array&&p_obj.arguments.constructor!=Object){throw'Passed argument list is not of type array nor object';}
else if(p_obj.arguments!=undefined){passed_args=p_obj.arguments;}
return passed_args;}
getFiles(p_obj){let passed_files=[];if(p_obj.files!=undefined&&p_obj.files.constructor!=Array){throw'Passed file list is not of type array';}
else if(p_obj.files!=undefined){passed_files=p_obj.files;}
return passed_files;}
getCallbacks(p_obj){let cbs={success:p_obj.success,error:p_obj.error,timeout:p_obj.timeout,upload:p_obj.upload,download:p_obj.download,before:p_obj.before};return cbs;}
getOverwrites(p_obj){return{xhr:p_obj.xhr,method:p_obj.method,timeoutSeconds:p_obj.timeoutSeconds,eval:p_obj.eval};}
argsToFormData(args,files){var fd=new FormData();for(var key in args){if(args.hasOwnProperty(key)){let value;Object.keys(args).forEach(dataKey=>{if(dataKey==key){value=args[dataKey];}});if(value!==null&&value.constructor==Object){value=JSON.stringify(value);}
fd.append(key,value);}}
for(var i in files){var file=files[i];fd.append(file.name,file);}
return fd;}
executeRequest(args,files,overwrites,callbacks){var http_request=false;var async=true;var req_method=overwrites.method||'POST';var timeout=overwrites.timeoutSeconds||0;var eval_reponse=overwrites.eval||true;var info=false;if(this.ontimeout===undefined||this.ontimeout===null){this.ontimeout=function(){if(callbacks.timeout){callbacks.timeout(this);}
else{throw'Request timed out';}};}
if(callbacks.upload){this.upload.onprogress=function(e){if(callbacks.upload!=undefined){callbacks.upload(e,this);}};}
let evalClosure=null;if(eval_reponse){evalClosure=this.eval;}
if(this.onreadystatechange===null){this.onreadystatechange=()=>{if(this.readyState==4&&this.status<=300&&this.status>=100){var response=this.responseText;if(info){console.log('Request was successful - response data:');console.log((response.length>0)?response:'no data was sent');}
if(eval_reponse){this.eval(response,false);}
if(callbacks.success){callbacks.success(response);}}
else if(this.readyState==4&&this.status>=400){if(info){console.log('Request failed - Server returned code '+this.status+' with following response data:');console.log((this.responseText.length>0)?this.responseText:'no data was sent');}
if(callbacks.error){callbacks.error(this.responseText,this.status);}}
else if(this.readyState==3){if(callbacks.download){callbacks.download(this.responseText);}
if(info){console.log('Receiving response-part:');console.log(this.responseText);}}};}
else{if(callbacks.success||callbacks.error){console.warn('Useless callback given in send - XMLHttpRequest.onreadystatechange is overwritten by custom XHR in overwrites-object - callbacks inside the callback-object will be ignored');}}
let target_xhr=this;if(callbacks.before){let before_ret=callbacks.before(http_request);let override=null;if(before_ret!==undefined){if(before_ret===false){this.abort();return this;}
else if(before_ret.constructor===XMLHttpRequest){target_xhr=before_ret;}}}
let data=this.argsToFormData(args,files);target_xhr.open(req_method,this.internal_route,async);target_xhr.setRequestHeader(this.header.target,this._target);target_xhr.setRequestHeader(this.header.method,this._method);target_xhr.timeout=timeout;target_xhr.send(data);return this;}
eval(scripts,plain){try{if(scripts!=''){var script=\"\";if(plain!==undefined&&plain===true){script=scripts;}
else{scripts=scripts.replace(/<script[^>]*>([\s\S]*?)<\/script>/gi,function(){if(scripts!==null){script+=arguments[1]+'\\n';}
return'';});}
if(script){window.eval(script);return true;}}
return false;}
catch(e){console.error('Eval error in following data: '+scripts);}}}
exports.BridgeRequest=BridgeRequest;});";
        return $js;
    }
    # END ASSEMBLY FRAME CLIENT.TS
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



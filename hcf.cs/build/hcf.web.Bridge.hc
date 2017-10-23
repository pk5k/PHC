<?php #HYPERCELL hcf.web.Bridge - BUILD 17.10.11#3141
namespace hcf\web;
class Bridge {
    use \hcf\core\dryver\Client, \hcf\core\dryver\Config, Bridge\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Bridge';
    const NAME = 'Bridge';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CLIENT.JS
    public static function client() {
        $js = "function(to)
{var self=this;self._target=to;self._action=undefined;self._method=undefined;self.do=function(arg_obj)
{if(arg_obj===undefined)
{arg_obj={};}
if(self.action()===undefined)
{throw'No action specified';}
var callbacks=getCallbacks(arg_obj);var overwrites=getOverwrites(arg_obj);var passed_args=getArguments(arg_obj);var passed_files=getFiles(arg_obj);var url_args={method:self.method(),};for(var key in passed_args)
{if(url_args.hasOwnProperty(key))
{throw'Cannot use argument '+key+' - this argument is used by the bridge for internally routing';}
url_args[key]=passed_args[key];}
send(url_args,passed_files,overwrites,callbacks);return self;}
self.invoke=function(method,implicit_constructor)
{if(method===undefined)
{throw'No method specified that should be invoked in '+self.target;}
if(implicit_constructor===true)
{method=method+'#implicit';}
return self.action('invoke').method(method);}
self.render=function()
{return self.action('render').method(null);}
self.action=function(action)
{if(action===undefined)
{return self._action;}
self._action=action;return self;}
self.target=function(target)
{if(target===undefined)
{return self._target;}
self._target=target;return self;}
self.method=function(method)
{if(method===undefined)
{return self._method;}
self._method=method;return self;}
function getArguments(p_obj)
{var passed_args=[];if(p_obj.arguments!=undefined&&p_obj.arguments.constructor!=Array&&p_obj.arguments.constructor!=Object)
{throw'Passed argument list is not of type array nor object';}
else if(p_obj!=undefined)
{passed_args=p_obj.arguments;}
return passed_args;}
function getFiles(p_obj)
{var passed_files=[];if(p_obj.files!=undefined&&p_obj.files.constructor!=Array)
{throw'Passed file list is not of type array';}
else if(p_obj!=undefined)
{passed_files=p_obj.files;}
return passed_files;}
function getCallbacks(p_obj)
{var callbacks={};if(p_obj!==undefined)
{var success=p_obj.onSuccess||false;var error=p_obj.onError||false;var timeout=p_obj.onTimeout||false;var upload=p_obj.onUpload||false;var download=p_obj.onDownload||false;var before=p_obj.onBefore||false;if(success)
{callbacks.success=success;}
if(error)
{callbacks.error=error;}
if(timeout)
{callbacks.timeout=timeout;}
if(upload)
{callbacks.upload=upload;}
if(download)
{callbacks.download=download;}
if(before)
{callbacks.before=before;}}
return callbacks;}
function getOverwrites(p_obj)
{var overwrites={};if(p_obj!==undefined)
{var xhr=p_obj.xhr||false;var method=p_obj.method||false;var eval=p_obj.eval||false;var timeout=undefined;if(!isNaN(p_obj.timeout))
{timeout=Number(p_obj.timeout);}
if(p_obj.async!==undefined&&p_obj.async!==null)
{overwrites.async=p_obj.async;}
if(xhr)
{overwrites.xhr=xhr;}
if(method)
{overwrites.method=method;}
if(!isNaN(timeout))
{overwrites.timeout=timeout;}
if(eval)
{overwrites.eval=eval;}}
return overwrites;}
function argsToFormData(args,files)
{var fd=new FormData();for(var key in args)
{if(args.hasOwnProperty(key)&&args[key]!==undefined)
{var value=args[key];if(value!==null&&value.constructor==Object)
{value=JSON.stringify(value);}
fd.append(key,value);}}
for(var i in files)
{var file=files[i];fd.append(file.name,file);}
return fd;}
function send(args,files,overwrites,callbacks)
{var http_request=false;var async=true;var req_method='POST';var timeout=4000;var eval=false;var info=false;if(overwrites!==undefined&&overwrites!==null)
{http_request=overwrites.xhr||http_request;req_method=overwrites.method||req_method;timeout=(!isNaN(overwrites.timeout))?overwrites.timeout:timeout;eval=overwrites.eval||eval;if(overwrites.async!==undefined&&overwrites.async!==null)
{async=overwrites.async;}}
if(callbacks===undefined||callbacks===null)
{callbacks={};}
if(!http_request)
{if(window.XMLHttpRequest)
{http_request=new XMLHttpRequest();}
else
{http_request=new ActiveXObject('Microsoft.XMLHTTP');}}
if(http_request.ontimeout===undefined||http_request.ontimeout===null)
{http_request.ontimeout=function()
{if(callbacks.timeout)
{callbacks.timeout(http_request);}
else
{throw'Request timed out';}}}
if(callbacks.upload)
{http_request.upload.onprogress=function(e)
{callbacks.upload(e,http_request);}}
var evalClosure=null;if(eval)
{evalClosure=this.eval;}
if(http_request.onreadystatechange===null)
{http_request.onreadystatechange=function()
{if(http_request.readyState==4&&http_request.status<=300&&http_request.status>=100)
{var response=http_request.responseText;if(info)
{console.log('Request was successful - response data:');console.log((response.length>0)?response:'no data was sent');}
if(eval)
{response=evalClosure(response,false);}
if(callbacks.success)
{callbacks.success(http_request.responseText);}}
else if(http_request.readyState==4&&http_request.status>=400)
{if(info)
{console.log('Request failed - Server returned code '+http_request.status+' with following response data:');console.log((http_request.responseText.length>0)?http_request.responseText:'no data was sent');}
if(callbacks.error)
{callbacks.error(http_request.responseText,http_request.status);}}
else if(http_request.readyState==3)
{if(callbacks.download)
{callbacks.download(http_request.responseText);}
if(info)
{console.log('Receiving response-part:');console.log(http_request.responseText);}}}}
else
{if(callbacks.success||callbacks.error)
{console.warn('Useless callback given in send - XMLHttpRequest.onreadystatechange is overwritten by custom XHR in overwrites-object - callbacks inside the callback-object will be ignored');}}
if(callbacks.before)
{old_request=http_request;http_request=callbacks.before(old_request);if(!http_request)
{http_request=old_request;}}
var data=argsToFormData(args,files);http_request.open(req_method,'?!=-bridge',async);http_request.setRequestHeader(\"X-Bridge-Action\",self.action());http_request.setRequestHeader(\"X-Bridge-Target\",self.target());if(async)
{http_request.timeout=timeout;}
http_request.send(data);}
function eval(scripts,plain)
{try
{if(scripts!='')
{var script=\"\";if(plain!==undefined&&plain===true)
{script=scripts;}
else
{scripts=scripts.replace(/<script[^>]*>([\s\S]*?)<\/script>/gi,function()
{if(scripts!==null)
{script+=arguments[1]+'\\n';}
return'';});}
if(script)
{if(window.execScript)
{window.execScript(script);}
else
{window.eval(script);}
return true;}}
return false;}
catch(e)
{console.error('Eval error in following data: '+scripts);}}
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
        $output = "{$this->_property('output') }";
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
    public function onConstruct() {
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
            throw new \RuntimeException('No arguments received - bridge "' . self::FQN . '" can\'t be executed');
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
        if (!isset($config->header->action)) {
            throw new \RuntimeException('Hypercell ' . self::FQN . ' does not contain configuration for "header.action" - cannot proceed');
        }
        if (!isset($config->header->target)) {
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
        $action_header = 'HTTP_' . strtoupper(str_replace('-', '_', $config->header->action));
        $target_header = 'HTTP_' . strtoupper(str_replace('-', '_', $config->header->target));
        if (!isset($_SERVER[$action_header])) {
            $this->sendHeader(400);
            throw new \Exception(self::FQN . ' - unable to find "action" http-header "' . $action_header . '"');
        }
        $action = $_SERVER[$action_header];
        if (!isset($_SERVER[$target_header])) {
            $this->sendHeader(400);
            throw new \Exception(self::FQN . ' - unable to find "target" http-header "' . $target_header . '"');
        }
        $target = $_SERVER[$target_header];
        if (!isset($config->$action)) {
            throw new \Exception(self::FQN . ' - unable to find section for action "' . $action . '"');
        }
        $section = $config->$action;
        if (!isset($section->action) || !is_string($section->action)) {
            throw new \RuntimeException('missing action-method in configuration for action "' . $action . '"');
        }
        if (!is_callable([$this, $section->action])) {
            throw new \RuntimeException('action-method for action "' . $action . '" is not callable');
        }
        if (!isset($section->allow) || !is_array($section->allow)) {
            throw new \RuntimeException('missing whitelist "allow" in configuration for action "' . $action . '"');
        }
        $allow = false;
        foreach ($section->allow as $allowed_pattern) {
            if (fnmatch($allowed_pattern, $target)) {
                $allow = true;
            }
        }
        if (!$allow) {
            $this->sendHeader(403);
            throw new \RuntimeException('target-Hypercell "' . $target . '" is not on the whitelist for action "' . $action . '"');
        }
        $action_method = $section->action;
        $output = $this->$action_method($section, $target, $args);
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
    private function httpInvoke($section, $target, $args) {
        if (!isset($section->method_key)) {
            throw new \RuntimeException('missing method-key in configuration for action "' . __METHOD__ . '"');
        }
        $method_key = $section->method_key;
        if (!isset($args[$method_key])) {
            throw new \RuntimeException('missing method-key in arguments for action "' . __METHOD__ . '"');
        }
        // clean arguments
        $method = $args[$method_key];
        $method_args = [];
        foreach ($args as $key => $value) {
            if ($key !== $method_key) {
                $method_args[$key] = $value;
            }
        }
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
        $invoker = new RemoteInvoker($target, $method_args);
        return $invoker->invoke($method, $method_args);
    }
    /**
     * httpRender
     * Invokes the output channel of a Hypercell
     *
     * @param section - object - the config-section which lead to this method
     * @param target - string - the target-Hypercell for this action
     * @param args - array - the argument array which was used for this routing
     *
     * @return mixed - data, which should be send as http-response
     */
    private function httpRender($section, $target, $args) {
        // trigger the constructor for this
        RemoteInvoker::implicitConstructor(true);
        $invoker = new RemoteInvoker($target, $args); // pass the arguments to it's constructor
        return $invoker->invoke('toString');
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

; name of a http header, which indicates the action that should be performed
action_key = 'action'
header.action = 'X-Bridge-Action'

; name of a http header, which indicates the hypercell which should be used for the action
header.target = 'X-Bridge-Target'

; if the bridge-indicator matches one of the section-names below, the action-method inside the server-channel will be executed
; the target_key will be passed as first argument to this method
[invoke]

; raw-merge fqns which can be accessed by this action - if the target raw-merge is not inside this list,
; the action will fail (with HTTP-response code 403 - forbidden)
; this is for security-reasons, to avoid executing any raw-merge somebody wants
; wildcards are possible to match rmfqn patterns
allow = ['your_package.*']

; this is the method, which will be called inside the server-channel to perform this action
; this configuration section will be passed to the method as argument
action = 'httpInvoke'

; this is a custom setting for the invoke-action
; an additional key of the argument-array-key, which defines the method which should be invoked inside the target-raw-merge
method_key = 'method'

[render:invoke]

; copy invoke-actions config and overwrite just the action-method, keep the whitelist and ignore the custom method_key setting
action = 'httpRender'
method_key = null


END[CONFIG.INI]


?>



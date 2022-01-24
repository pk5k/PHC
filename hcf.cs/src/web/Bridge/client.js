document.Bridge = function (to)
{
	var self = this;
	var _internal_route = '?!=-bridge';
	var _worker_address = 'hcf.web.Bridge.Worker';
	var _worker_store = _worker_address+'.Store';

	var _header = {
		action: "X-Bridge-Action",
		target: "X-Bridge-Target",
		method: "X-Bridge-Method"
	};

	self._target = to;
	self._action = undefined;
	self._method = undefined;

	if (document[_worker_address] == undefined && window.Worker)
	{
		document[_worker_address] = new Worker(_internal_route);
		document[_worker_address].onmessage = receiveWorkerMessage;
	}
	else if (!window.Worker)
	{
		console.warn('Your Browser does not support WebWorkers - all requests will be executed on the main-thread.');
	}

	if (document[_worker_store] == undefined) 
	{
		document[_worker_store] = {};// store data here, that can't be serialized, until worker calls back
	}

	self.do = function (arg_obj)
	{
		var prepared_data = prepareSend(arg_obj, false);
		send(prepared_data.url_args, prepared_data.passed_files, prepared_data.overwrites, prepared_data.callbacks);

		return self;
	}

	self.letDo = function (arg_obj)
	{
		if (!window.Worker || !document[_worker_address])
		{
			// no WebWorker-support -> fallback
			return self.do(arg_obj);
		}

		var prepared_data = prepareSend(arg_obj, true);
		var req_token = new Date().getTime();

		document[_worker_store][req_token] = prepared_data;

		document[_worker_address].postMessage({
			// internal
			_: {
				token: req_token,
				route: _internal_route,
				header: _header,
				target: self.target(),
				action: self.action(),
				method: self.method()
			},
			// user-data
			overwrites: prepared_data.overwrites,
			args: prepared_data.url_args, 
			files: prepared_data.passed_files
		});

		return self;
	}

	function receiveWorkerMessage(e)
	{
		var token = e.data.token;

		if (document[_worker_store] == undefined)
		{
			throw 'Missing worker-store at document[' + _worker_store + ']';
		}
		else if (document[_worker_store][token] == undefined)
		{
			throw 'Missing worker-store-data at document[' + _worker_store + '][' + token + ']'; 
		}

		var stored_data = document[_worker_store][token];
		var callbacks = stored_data.callbacks;
		var overwrites = stored_data.overwrites;

		switch (e.data.result)
		{
			case 'success':
				if (callbacks.success)
				{
					callbacks.success(e.data.data);
				}
				break;

			case 'error':
				if (callbacks.error)
				{
					callbacks.error(e.data.data, e.data.code);
				}
				else 
				{
					throw 'WebWorker-request failed with response-code ' + e.data.code + '.';
				}
				break;

			case 'timeout':
				if (callbacks.timeout)
				{
					callbacks.timeout(e.data.data);
				}
				else
				{
					throw 'WebWorker-request timed out.';
				}
				break;

			default:
				throw 'WebWorker-request returned unknown result "' + e.data.result + '"';
		}

		delete document[_worker_store][token];
	}

	function prepareSend(arg_obj, for_worker)
	{
		if (arg_obj === undefined)
		{
			arg_obj = {};
		}

		if (self.action() === undefined)
		{
			throw 'No action specified';
		}

		var prepared_data = {
			callbacks: getCallbacks(arg_obj, for_worker),
			overwrites: getOverwrites(arg_obj, for_worker),
			passed_files: getFiles(arg_obj),
			url_args: {}
		};

		var passed_args = getArguments(arg_obj);
		
		for (var key in passed_args)
		{
			if (prepared_data.url_args.hasOwnProperty(key))
			{
				throw 'Cannot use argument ' + key + ' - this argument is used by the bridge for internally routing';
			}

			prepared_data.url_args[key] = passed_args[key];
		}

		return prepared_data;
	}

	self.invoke = function(method, implicit_constructor)
	{
		if (method === undefined)
		{
			throw 'No method specified that should be invoked in '+self.target;
		}

		if (implicit_constructor === true)
		{
			method = method + '#implicit';
		}

		return self.action('invoke').method(method);
	}

	self.render = function()
	{
		return self.action('render').method(null);
	}

	self.action = function(action)
	{
		if (action === undefined)
		{
			return self._action;
		}

		self._action = action;

		return self;
	}

	self.target = function(target)
	{
		if (target === undefined)
		{
			return self._target;
		}

		self._target = target;

		return self;
	}

	self.method = function(method)
	{
		if (method === undefined)
		{
			return self._method;
		}

		self._method = method;

		return self;
	}

	/*
	Function: getArguments

		Extracts the arguments out of an parameter-object

	Parameters:

		p_obj - An parameter-object, which may contains arguments for it's target

   	Returns:

    	An array, containing all given arguments
	*/
	function getArguments(p_obj)
	{
		var passed_args = [];

		if (p_obj.arguments != undefined && p_obj.arguments.constructor != Array && p_obj.arguments.constructor != Object)
		{
			throw 'Passed argument list is not of type array nor object';
		}
		else if (p_obj != undefined)
		{
			passed_args = p_obj.arguments;
		}

		return passed_args;
	}

	/*
	Function: getFiles

		Extracts the files out of an parameter-object

	Parameters:

		p_obj - An parameter-object, which may contains Files for it's target

   	Returns:

    	An array, containing all given File objects
	*/
	function getFiles(p_obj)
	{
		var passed_files = [];

		if (p_obj.files != undefined && p_obj.files.constructor != Array)
		{
			throw 'Passed file list is not of type array';
		}
		else if (p_obj != undefined)
		{
			passed_files = p_obj.files;
		}

		return passed_files;
	}

	/*
	Function: getCallbacks

		Extracts the callbacks out of an parameter-object

	Parameters:

		p_obj - An parameter-object, which may contains callbacks

   	Returns:

    	An object, containing the callbacks
	*/
	function getCallbacks(p_obj, for_worker)
	{
		var callbacks = {};

		if (p_obj !== undefined)
		{
			var success = p_obj.onSuccess || false;
			var error	= p_obj.onError || false;
			var timeout = p_obj.onTimeout || false;
			var upload	= p_obj.onUpload || false;
			var download = p_obj.onDownload || false;
			var before	= p_obj.onBefore || false;

			if (success)
			{
				callbacks.success = success;
			}

			if (error)
			{
				callbacks.error = error;
			}

			if (timeout)
			{
				callbacks.timeout = timeout;
			}

			if (upload)
			{
				callbacks.upload = upload;

				if (for_worker)
				{
					throw 'WebWorker requests can\'t use the upload-callback';
				}
			}

			if (download)
			{
				callbacks.download = download;

				if (for_worker)
				{
					throw 'WebWorker requests can\'t use the download-callback';
				}
			}

			if (before)
			{
				callbacks.before = before;

				if (for_worker)
				{
					throw 'WebWorker requests can\'t use the before-callback';
				}
			}
		}

		return callbacks;
	}

	/*
	Function: getOverwrites

		Extracts values out of an parameter-object, which should overwrite the default xmlhttprequest-settings

	Parameters:

		p_obj - An parameter-object, which may contains overwrites

   	Returns:

    	An object, containing the overwrites for the xmlhttprequest-settings
	*/

	function getOverwrites(p_obj, for_worker)
	{
		var overwrites = {};

		if (p_obj !== undefined)
		{
			var xhr = p_obj.xhr || false;
			var method = p_obj.method || false;
			var eval = p_obj.eval || false;
			var timeout = undefined;

			if (!isNaN(p_obj.timeout))
			{
				timeout = Number(p_obj.timeout);
			}

			if (p_obj.async !== undefined && p_obj.async!==null)
			{
				overwrites.async = p_obj.async;
			}

			if (xhr)
			{
				overwrites.xhr = xhr;

				if (for_worker)
				{
					throw 'WebWorker requests cant override the XHR-object';
				}
			}

			if (method)
			{
				overwrites.method = method;

				if (for_worker)
				{
					throw 'WebWorker requests cant override the request-method';
				}
			}

			if (!isNaN(timeout))
			{
				overwrites.timeout = timeout;
			}

			if (eval)
			{
				overwrites.eval = eval;
			}
		}

		return overwrites;
	}

	function argsToFormData(args, files)
	{
		var fd = new FormData();

		for(var key in args)
		{
			if (args.hasOwnProperty(key) && args[key] !== undefined)
			{
				var value = args[key];

				if (value !== null && value.constructor == Object)
				{
					value = JSON.stringify(value);
				}

				fd.append(key, value);
			}
		}

		for (var i in files)
		{
			var file = files[i];
			fd.append(file.name, file);
		}

		return fd;
	}

	function send(args, files, overwrites, callbacks)
	{
		var http_request = false;
		var async = true;
		var req_method = 'POST';//use POST so the POST-HOOK will be executed
		var timeout = 4000;// 4 seconds for timeout as default
		var eval_reponse = false;//eval http-response on success for possible javascript content
		var info = false;//log infos to console

		if (overwrites !== undefined && overwrites !== null)
		{
			//load overwrites
			http_request	= overwrites.xhr || http_request;
			req_method = overwrites.method || req_method;
			timeout	= (!isNaN(overwrites.timeout)) ? overwrites.timeout : timeout;
			eval = overwrites.eval || eval;

			if (overwrites.async!==undefined && overwrites.async!==null)
			{
				async = overwrites.async;
			}
		}

		if (callbacks === undefined || callbacks === null)
		{
			callbacks = {};
		}

		if (!http_request)
		{
			if (window.XMLHttpRequest)
			{
				http_request = new XMLHttpRequest();
			}
			else
			{
				http_request = new ActiveXObject('Microsoft.XMLHTTP');
			}
		}

		if (http_request.ontimeout === undefined || http_request.ontimeout === null) //if a given XHR-Object already contains a ontimeout function, don't add ours
		{
			http_request.ontimeout = function()
			{
				if (callbacks.timeout)
				{
					callbacks.timeout(http_request);
				}
				else
				{
					throw 'Request timed out';
				}
			}
		}

		if (callbacks.upload) //if an upload-callback was given, add it to the xhr
		{
			http_request.upload.onprogress = function(e)
			{
				callbacks.upload(e, http_request);
			}
		}

		var evalClosure = null;

		if (eval_reponse)
		{
			evalClosure = eval;
		}

		if (http_request.onreadystatechange === null) //if a given XHR-Object already contains a onreadystatechange function, don't add ours
		{
			http_request.onreadystatechange = function()
			{
				if (http_request.readyState==4 && http_request.status <= 300 && http_request.status >= 100)// response codes => 100 <= 300 counts as successful
				{
					var response = http_request.responseText;

					if (info)
					{
						console.log('Request was successful - response data:');
						console.log((response.length > 0) ? response : 'no data was sent');
					}

					if (eval_reponse)
					{
						evalClosure(response, false);
					}

					if (callbacks.success)
					{
						callbacks.success(response);
					}
				}
				else if (http_request.readyState == 4 && http_request.status >= 400)// every http-response-code equal or higher 400 counts as error
				{
					if (info)
					{
						console.log('Request failed - Server returned code ' + http_request.status + ' with following response data:');
						console.log((http_request.responseText.length > 0) ? http_request.responseText : 'no data was sent');
					}

					if (callbacks.error)
					{
						callbacks.error(http_request.responseText, http_request.status);
					}
				}
				else if (http_request.readyState == 3)
				{
					if (callbacks.download)
					{
						callbacks.download(http_request.responseText);
					}

					if (info)
					{
						console.log('Receiving response-part:');
						console.log(http_request.responseText);
					}
				}
			}
		}
		else
		{
			if (callbacks.success || callbacks.error)
			{
				console.warn('Useless callback given in send - XMLHttpRequest.onreadystatechange is overwritten by custom XHR in overwrites-object - callbacks inside the callback-object will be ignored');
			}
		}

		if (callbacks.before)
		{
			// the http_request must be returned from the before-callback to overwrite it. There you have the possibility to manipulate or abort the request before sending it
			// return an XMLHttpRequest Object to override and false to abort it
			var before_ret = callbacks.before(http_request);

			if (before_ret !== undefined)
			{
				if (before_ret === false)
				{
					return;// returning false aborts the request completely
				}
				else if (before_ret.constructor === XMLHttpRequest)
				{
					http_request = before_ret;// returning an XMLHttpRequest instance overrides the current one
				}
			}
		}

		var data = argsToFormData(args, files);
		
		//Send request here
		http_request.open(req_method, _internal_route, async);// if you override config.ini@hcf.web.Router, don't forget to add the internal -bridge route
		http_request.setRequestHeader(_header.action, self.action());
		http_request.setRequestHeader(_header.target, self.target());
		http_request.setRequestHeader(_header.method, self.method());

		if (async)
		{
			http_request.timeout = timeout;
		}

		http_request.send(data);
	}

	/*
	Function: evalScripts(scripts)

		Executes javascript-tags inside of new loaded data

   	Parameters:

    	scripts - Markup which may contains script-tags
    	plain 	- Assume, scripts contain plain javascript (no html markup etc.)

   	Returns:

    	true - on success.
    	false - on failure.
	*/
	function eval(scripts, plain)
	{
		try
		{
			if (scripts != '')
			{
				var script = "";

				if (plain !== undefined && plain === true)
				{
					script = scripts;
				}
				else
				{
					scripts = scripts.replace(/<script[^>]*>([\s\S]*?)<\/script>/gi, function()
					{
						if (scripts !== null)
						{
							script += arguments[1] + '\\n';
						}

						return '';
					});
				}

				if (script)
				{
					 if (window.execScript)
					 {
					 	window.execScript(script);
					 }
					 else
					 {
					 	window.eval(script);
					 }

					 return true;
				}
			}

			return false;
		}
		catch(e)
		{
			console.error('Eval error in following data: '+scripts);
		}
	}

	return self;
}

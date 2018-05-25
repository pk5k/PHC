function (to)
{
	var self = this;

	self._target = to;
	self._action = undefined;
	self._method = undefined;

	self.do = function (arg_obj)
	{
		if (arg_obj === undefined)
		{
			arg_obj = {};
		}

		if (self.action() === undefined)
		{
			throw 'No action specified';
		}

		var callbacks = getCallbacks(arg_obj);
		var overwrites = getOverwrites(arg_obj);
		var passed_args = getArguments(arg_obj);
		var passed_files = getFiles(arg_obj);

		var url_args = {
			method: self.method(),
		};

		for (var key in passed_args)
		{
			if (url_args.hasOwnProperty(key))
			{
				throw 'Cannot use argument ' + key + ' - this argument is used by the bridge for internally routing';
			}

			url_args[key] = passed_args[key];
		}

		send(url_args, passed_files, overwrites, callbacks);

		return self;
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
	function getCallbacks(p_obj)
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
			}

			if (download)
			{
				callbacks.download = download;
			}

			if (before)
			{
				callbacks.before = before;
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

	function getOverwrites(p_obj)
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
			}

			if (method)
			{
				overwrites.method = method;
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

	// urlArgsToString: function (url_args)
	// {
	// 	var arg_str = '';

	// 	for(var key in url_args)
	// 	{
	// 		if (url_args.hasOwnProperty(key))
	// 		{
	// 			var value = url_args[key];
	// 			arg_str += key + '=' + value + '&';
	// 		}
	// 	}

	// 	if (arg_str.length > 0)
	// 	{
	// 		// cut off the last &
	// 		arg_str = arg_str.slice(0, -1);
	// 	}

	// 	return arg_str;
	// },

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
		var eval = false;//eval http-response on success for possible javascript content
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

		if (eval)
		{
			evalClosure = this.eval;
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

					if (eval)
					{
						response = evalClosure(response, false);
					}

					if (callbacks.success)
					{
						callbacks.success(http_request.responseText);
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
		http_request.open(req_method, '?!=-bridge', async);// if you override config.ini@hcf.web.Router, don't forget to add the internal -bridge route
		http_request.setRequestHeader("X-Bridge-Action", self.action());
		http_request.setRequestHeader("X-Bridge-Target", self.target());

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

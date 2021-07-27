export default function setup(to: string) 
{
	console.log(to);

	return (new BridgeRequest()).to(to);
}

export type BridgeConfig = {
	arguments?: Array<any>;
	files?: Array<any>;
	timeoutSeconds?: number;
	method?: string;
	eval?: boolean;
	xhr?: XMLHttpRequest;
	success?: Function;
	error?: Function;
	timeout?: Function;
	upload?: Function;
	download?: Function;
	before?: Function;
}

export type BridgeCallbacks = {
	success?: Function;
	error?: Function;
	timeout?: Function;
	upload?: Function;
	download?: Function;
	before?: Function;
}

type BridgePreparedData = {
	callbacks: BridgeCallbacks,
	overwrites: object,
	passed_files: Array<any>
	url_args: object
}

export class BridgeRequest extends XMLHttpRequest
{
	internal_route = '?!=-bridge';
	_target: string = '';
	_method: string = '';

	header = {
		target: "X-Bridge-Target",
		method: "X-Bridge-Method"
	};

	constructor()
	{
		super();
	}

	to(hypercell: string): BridgeRequest
	{
		this.target(hypercell);

		return this;
	}

	do(arg_obj: BridgeConfig): BridgeRequest
	{
		var prepared_data = this.prepareSend(arg_obj);
		return this.executeRequest(prepared_data.url_args, prepared_data.passed_files, prepared_data.overwrites, prepared_data.callbacks);
	}

	prepareSend(arg_obj: BridgeConfig): BridgePreparedData
	{
		if (this._method == '')
		{
			throw 'No action specified, use .invoke or .render';
		}

		let prepared_data: BridgePreparedData = {
			callbacks: this.getCallbacks(arg_obj),
			overwrites: this.getOverwrites(arg_obj),
			passed_files: this.getFiles(arg_obj),
			url_args: this.getArguments(arg_obj)
		};
	
		return prepared_data;
	}

	method(method: string): BridgeRequest
	{
		this._method = method;

		return this;
	}

	invoke(method: string, implicit_constructor?: boolean): BridgeRequest
	{
		if (implicit_constructor === true)
		{
			method = method + '#implicit';
		}

		return this.method(method);
	}

	render(): BridgeRequest
	{
		return this.invoke('toString', true);
	}

	target(target: string): BridgeRequest
	{
		this._target = target;

		return this;
	}

	/*
	Function: getArguments

		Extracts the arguments out of an parameter-object

	Parameters:

		p_obj - An parameter-object, which may contains arguments for it's target

   	Returns:

    	An array, containing all given arguments
	*/
	getArguments(p_obj: BridgeConfig): Array<any>
	{
		let passed_args: Array<any> = [];

		if (p_obj.arguments != undefined && p_obj.arguments.constructor != Array && p_obj.arguments.constructor != Object)
		{
			throw 'Passed argument list is not of type array nor object';
		}
		else if (p_obj.arguments != undefined)
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
	getFiles(p_obj: BridgeConfig): Array<any>
	{
		let passed_files: Array<any> = [];

		if (p_obj.files != undefined && p_obj.files.constructor != Array)
		{
			throw 'Passed file list is not of type array';
		}
		else if (p_obj.files != undefined)
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
	getCallbacks(p_obj: BridgeConfig): BridgeCallbacks
	{
		let cbs: BridgeCallbacks = {
			success: p_obj.success,
			error: p_obj.error,
			timeout: p_obj.timeout,
			upload: p_obj.upload,
			download: p_obj.download,
			before: p_obj.before
		};

		return cbs;
	}

	/*
	Function: getOverwrites

		Extracts values out of an parameter-object, which should overwrite the default xmlhttprequest-settings

	Parameters:

		p_obj - An parameter-object, which may contains overwrites

   	Returns:

    	An object, containing the overwrites for the xmlhttprequest-settings
	*/

	getOverwrites(p_obj: BridgeConfig): object
	{
		return {
			xhr: p_obj.xhr,
			method: p_obj.method,
			timeoutSeconds: p_obj.timeoutSeconds,
			eval: p_obj.eval
		};
	}

	argsToFormData(args: object, files: Array<any>): FormData
	{
		var fd = new FormData();

		for(var key in args)
		{
			if (args.hasOwnProperty(key))
			{
				let value: any;

				(Object.keys(args) as Array<keyof Object>).forEach(dataKey => {
			    	if (dataKey == key)
			    	{
			    		value = args[dataKey];
			    	}
			  	});

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

	executeRequest(args: object, files: Array<any>, overwrites: object, callbacks: BridgeCallbacks): BridgeRequest
	{
		var http_request = false;
		var async = true;
		var req_method = 'POST';//use POST so the POST-HOOK will be executed
		var timeout = 4000;// 4 seconds for timeout as default
		var eval_reponse = false;//eval http-response on success for possible javascript content
		var info = false;//log infos to console
		var eval_enabled = true; 

		if (this.ontimeout === undefined || this.ontimeout === null) //if a given XHR-Object already contains a ontimeout function, don't add ours
		{
			this.ontimeout = function()
			{
				if (callbacks.timeout)
				{
					callbacks.timeout(this);
				}
				else
				{
					throw 'Request timed out';
				}
			}
		}

		if (callbacks.upload) //if an upload-callback was given, add it to the xhr
		{
			this.upload.onprogress = function(e)
			{
				if (callbacks.upload != undefined)
				{
					callbacks.upload(e, this);
				}
			}
		}

		let evalClosure: Function | null = null;

		if (eval_reponse)
		{
			evalClosure = this.eval;
		}

		if (this.onreadystatechange === null) //if a given XHR-Object already contains a onreadystatechange function, don't add ours
		{
			this.onreadystatechange = () =>
			{
				if (this.readyState == 4 && this.status <= 300 && this.status >= 100)// response codes => 100 <= 300 counts as successful
				{
					var response = this.responseText;

					if (info)
					{
						console.log('Request was successful - response data:');
						console.log((response.length > 0) ? response : 'no data was sent');
					}

					if (eval_reponse)
					{
						this.eval(response, false);
					}

					if (callbacks.success)
					{
						callbacks.success(response);
					}
				}
				else if (this.readyState == 4 && this.status >= 400)// every http-response-code equal or higher 400 counts as error
				{
					if (info)
					{
						console.log('Request failed - Server returned code ' + this.status + ' with following response data:');
						console.log((this.responseText.length > 0) ? this.responseText : 'no data was sent');
					}

					if (callbacks.error)
					{
						callbacks.error(this.responseText, this.status);
					}
				}
				else if (this.readyState == 3)
				{
					if (callbacks.download)
					{
						callbacks.download(this.responseText);
					}

					if (info)
					{
						console.log('Receiving response-part:');
						console.log(this.responseText);
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

		var target_xhr: XMLHttpRequest = this;
		
		if (callbacks.before)
		{
			// the http-request must be returned from the before-callback to overwrite it. There you have the possibility to manipulate or abort the request before sending it
			// return an XMLHttpRequest Object to override and false to abort it
			var before_ret = callbacks.before(http_request);
			var override = null;

			if (before_ret !== undefined)
			{
				if (before_ret === false)
				{
					this.abort();// returning false aborts the request completely
					return this;
				}
				else if (before_ret.constructor === XMLHttpRequest)
				{
					target_xhr = before_ret;// returning an XMLHttpRequest instance overrides the current one
				}
			}
		}

		var data = this.argsToFormData(args, files);
		
		//Send request here
		target_xhr.open(req_method, this.internal_route, async);// if you override config.ini@hcf.web.Router, don't forget to add the internal -bridge route
		target_xhr.setRequestHeader(this.header.target, this._target);
		target_xhr.setRequestHeader(this.header.method, this._method);
		target_xhr.timeout = timeout;

		target_xhr.send(data);

		return this;
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
	eval(scripts: string, plain: boolean): any
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
					window.eval(script);
					
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

}
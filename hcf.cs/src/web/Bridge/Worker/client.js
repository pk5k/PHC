onmessage = function(e) 
{
	var data = e.data;
	var http_request = false;
	var timeout = 4000;// 4 seconds for timeout as default
	var info = false;//log infos to console
	var http_request = new XMLHttpRequest();// no check needed. If we can support WebWorkers, we'll have XMLHttpRequests available

	timeout	= (!isNaN(data.overwrites.timeout)) ? data.overwrites.timeout : timeout;

	http_request.ontimeout = function()
	{
		returnToHost('timeout', 0, null);
	}

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
			
			returnToHost('success', http_request.status, http_request.responseText);
		}
		else if (http_request.readyState == 4 && http_request.status >= 400)// every http-response-code equal or higher 400 counts as error
		{
			if (info)
			{
				console.log('Request failed - Server returned code ' + http_request.status + ' with following response data:');
				console.log((http_request.responseText.length > 0) ? http_request.responseText : 'no data was sent');
			}

			returnToHost('error', http_request.status, http_request.responseText);
		}
	}

	var send_data = argsToFormData(data.args, data.files);

	//Send request here
	http_request.open('POST', data._.route, true);
	http_request.setRequestHeader(data._.header.action, data._.action);
	http_request.setRequestHeader(data._.header.target, data._.target);
	http_request.timeout = timeout;
	http_request.send(send_data);

	function returnToHost(result, code, response_data)
	{
		var ret_obj = {
			token: data._.token
		};

		switch (result)
		{
			case 'timeout':
			case 'error':
			case 'success':
				ret_obj.result = result;
				ret_obj.code = code;
				ret_obj.data = response_data;
				break;

			default: 
				throw 'Invalid result "' + result + '" given.';
		}

		postMessage(ret_obj);
	}

	// copy from hcf.web.Bridge (can't access any of that inside here and FormData-objects cannot be cloned)
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
};
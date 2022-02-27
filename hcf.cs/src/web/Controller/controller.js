class  // hcf.web.Controller is just an internal function collection, no need to generalise so a own controller can be anything you want (function, object, class)
{
	static _resource_cache = [];

	static isCached(hcfqn)
	{
		let me = hcf.web.Controller;

		if (me._resource_cache.indexOf(hcfqn) == -1)
		{
			return false;
		}

		return true;
	}

	static loadResources(hcfqn, to_context)
	{
		let me = hcf.web.Controller;
		let component = '&component=';
		let load = [];

		if (hcfqn == undefined || hcfqn == null)
		{
			throw 'hcfqn is invalid';
		}
		else if (hcfqn.constructor === Array)
		{
			hcfqn.forEach((dependency) => {
				if (!me.isCached(dependency) && load.indexOf(dependency) == -1)
				{
					load.push(dependency);
				}
			});

			component += load.join(',');
		}
		else 
		{
			if (!me.isCached(hcfqn))
			{
				load.push(hcfqn);
				component += hcfqn;
			}
		}

		if (load.length == 0)
		{
			return [];
		}

		let version = (document.APP_VERSION != undefined) ? '&v=' + document.APP_VERSION : '';
		let context = (to_context != null && to_context != undefined) ? '&context=' + to_context : '';
		let base = document.head.querySelector('base');
		let base_href = '/';

		if (base != null && base.hasAttribute('href'))
		{
			base_href = base.getAttribute('href');
		}

		let controller = new Promise((resolve, reject) =>
		{
			let elem = document.createElement('script');
			elem.setAttribute('src', base_href+'?!=-script' + component + version);// controller is always global so context not required -> url will not differ if component loaded to multiple contexts -> cache will be used more

			elem.addEventListener('load', (e) => resolve(e));
			elem.addEventListener('error', (e) => reject(e));

			document.head.appendChild(elem);
		});

		let template = new Promise((resolve, reject) =>
		{
			let elem = document.createElement('script');
			elem.setAttribute('src', base_href+'?!=-template' + component + context + version);// context required to load to correct context

			elem.addEventListener('load', (e) => resolve(e));
			elem.addEventListener('error', (e) => reject(e));

			document.head.appendChild(elem);// templates will move to their context by themself if neccessary
		});

		let style = new Promise((resolve, reject) =>
		{
			let elem = document.createElement('link');
			elem.setAttribute('href', base_href+'?!=-style' + component + version);// link element is placed inside context, keep context away from path to use cache more often
			elem.setAttribute('type', 'text/css');
			elem.setAttribute('rel', 'stylesheet');

			if (context != '')
			{
				let c = document.getElementById(to_context);

				if (c == null)
				{
					throw 'render context ' + to_context + ' does not exist';
				}
				
				let global_allowed = (c.getAttribute('data-global') == 'true');

				if (global_allowed)
				{
					// load trough light dom and copy to shadow dom later to use load event
					elem.addEventListener('load', (e) => { 
						resolve(e);
						c.content.appendChild(elem.cloneNode(true));
					});

					elem.addEventListener('error', (e) => reject(e));
					document.head.appendChild(elem);
				}
				else 
				{
					resolve();// resolve immediately - links inside shadow dom won't start loading until visible so this promise won't be resolved
					c.content.appendChild(elem);
				}
			}
			else 
			{
				elem.addEventListener('load', (e) => resolve(e));
				elem.addEventListener('error', (e) => reject(e));

				document.head.appendChild(elem);
			}
		});

		let promises = [controller, template, style];
		
		Promise.all(promises).then(() => {
			me._resource_cache = me._resource_cache.concat(load);
		});

		return promises;
	}
}
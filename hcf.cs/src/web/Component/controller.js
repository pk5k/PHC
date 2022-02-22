class extends HTMLElement // extend an anonymous class from hcf.web.Component in your own component
{
	constructor()
	{
		super();
		this.loadTemplate();
	}

	loadTemplate()
	{
		if (document.componentMap[this.tagName] == undefined)
		{
			throw 'Element ' + this.tagName.toLowerCase() + ' is not in the component map and thus cannot be used.';
		}

		let component_definition = document.componentMap[this.tagName];

		let shadow_root = this.attachShadow({mode: 'open'});
		let context = null;
		let tpl = null;

		if (component_definition.context == '')
		{
			context = document.head;// global context
			tpl = context.querySelector('div[id="' + component_definition.fqn + '"]');
		}
		else 
		{
			context = document.getElementById(component_definition.context).content;
			tpl = context.getElementById(component_definition.fqn);
		}

      	context.querySelectorAll('style, link').forEach((e) => 
      	{
      		shadow_root.appendChild(e.cloneNode(true));
      	});

      	let children = tpl.children;

      	for (let i in children)
      	{
      		if (children[i] instanceof HTMLElement)
      		{
      			shadow_root.appendChild(children[i].cloneNode(true));
      		}
      	}
	}

	runAfterDomLoad(func)
	{
		hcf.web.Component.extRunAfterDomLoad(func);
	}

	static extRunAfterDomLoad(func)
	{
		if (document.readyState === 'loading')
	    {
	      window.addEventListener('DOMContentLoaded', function() { func() });// wait until children are initialised
	    }
	    else 
	    {
	    	func();
	    }
	}

	static loadDependencies(hcfqn, to_context)
	{
		let component = '&component=';

		if (hcfqn == undefined || hcfqn == null)
		{
			throw 'hcfqn is invalid';
		}
		else if (hcfqn.constructor === Array)
		{
			component += hcfqn.join(',');
		}
		else 
		{
			component += hcfqn;
		}

		let version = (document.APP_VERSION != undefined) ? '&v=' + document.APP_VERSION : '';
		let context = (to_context != null && to_context != undefined) ? '&context=' + to_context : '';

		let controller = new Promise((resolve, reject) =>
		{
			let elem = document.createElement('script');
			elem.setAttribute('src', '?!=-script' + component + context + version);

			elem.addEventListener('load', (e) => resolve(e));
			elem.addEventListener('error', (e) => reject(e));

			document.head.appendChild(elem);
		});

		let template = new Promise((resolve, reject) =>
		{
			let elem = document.createElement('script');
			elem.setAttribute('src', '?!=-template' + component + context + version);

			elem.addEventListener('load', (e) => resolve(e));
			elem.addEventListener('error', (e) => reject(e));

			document.head.appendChild(elem);// templates will move to their context by themself if neccessary
		});

		let style = new Promise((resolve, reject) =>
		{
			let elem = document.createElement('link');
			elem.setAttribute('href', '?!=-style' + component + context + version);
			elem.setAttribute('type', 'text/css');
			elem.setAttribute('rel', 'stylesheet');

			if (context != '')
			{
				let c = document.getElementById(to_context);

				if (c == null)
				{
					throw 'component context ' + to_context + ' does not exist';
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

		return [controller, template, style];
	}
}
class extends hcf.web.Component
{
	constructor()
	{
		super();
		
		let load_trigger = this.shadowRoot.querySelector('.hcf-load-trigger');

		if (this.getAttribute('autoload') == 'false')
		{
			load_trigger.remove();
			load_trigger = null;
		}

		if (load_trigger != null)
		{
			let load_as = load_trigger.getAttribute('data-load');

			this.loadView(load_as)
				.then((data) => 
				{
					this.loaded_as = load_as;
					this.viewLoadSuccess(data);
				})
				.catch((code, msg) =>  this.viewLoadFailed(code, msg));

			load_trigger.remove();
		}

		this.addEventListener('page-rendered', (e) => {
			this.ready(this.pageRoot());
		});
	}

	pageRoot()
	{
		return this.page_root;// the root element of your view
	}

	ready(view_root)
	{
		// called when the page has load it's view.
		// This does not depend on placement in the dom unlike connectedCallback
	}

	cacheReload()
	{
		// called each time PageLoader reloads class out of cache
	}

	beforeUnload()
	{
		// called each time before PageLoader moves this class to cache and loads another
		// last action before quitting the page. 
	}

	cache()
	{
		return true; // Return false to avoid PageLoaders caching of this page
	}

	reload() // use to re-render whole view with current element-attributes passed to the server page instance
	{
		if (this.loaded_as == undefined || this.loaded_as == null)
		{
			throw 'cannot reload - page was not load yet.';
		}

		return this.loadView(this.loaded_as)
			.then((data) => this.viewLoadSuccess(data))
			.catch((code, msg) => this.viewLoadFailed(code, msg));
	}

	// INTERNAL:
	clear()
	{
		this.page_root = null;
		let children = this.shadowRoot.children;
		let remove = [];

		for (let i in children)
      	{
      		let t_name = children[i].tagName;

      		if (children[i] instanceof HTMLElement && t_name != 'STYLE' && t_name != 'LINK')
      		{
      			remove.push(children[i]);
      		}
      	}

      	remove.forEach((e) => {
      		e.remove();
      	});
	}

	viewLoadSuccess(data)
	{
		let e = new Event('page-load-view-success', {bubbles:true});
		this.dispatchEvent(e);
		this.render(data);
	}

	viewLoadFailed(code, msg)
	{
		let e = new Event('page-load-view-failed', {bubbles:true});
		this.dispatchEvent(e);
		this.error(code, msg);
	}

	injectView(view_data, load_as)
	{
		this.loaded_as = load_as;

		return this.render(view_data);
	}

	render(view_data)
	{
		this.clear();

		let wrapper = document.createElement('div');
		wrapper.innerHTML = view_data;
		let children = wrapper.children;
		let first = null;

		for (let i in children)
      	{
      		if (children[i] instanceof HTMLElement)
      		{
      			if (first == null)
      			{
      				first = children[i];
      			}

      			this.shadowRoot.appendChild(children[i].cloneNode(true));
      		}
      	}

      	this.page_root = first;
      	let e = new Event('page-rendered', {bubbles:true});
      	
      	this.dispatchEvent(e);
	}

	getOwnAttributes()
	{
		let atts = this.attributes;
		let out = {};

		for (var i in atts)
		{
			if (!isNaN(i))
			{
				let att_name = atts[i];
				let att_val = this.getAttribute(att_name);
				out[att_name] = att_val;
			}
		}

		return out;
	}

	loadView(which)
	{
      	let e = new Event('page-load-view-begin', {bubbles:true});

		if (which == undefined || which == null)
		{
			throw 'given hcfqn is invalid.';
		}

		return new Promise((resolve, reject) =>
		{
			hcf.web.Bridge(which).render().do({
				arguments: [this.getOwnAttributes()],
				timeout: 0,
				onSuccess: (data) => { resolve(data) },
				onError: (code, msg) => { reject(code, msg) },
				onTimeout: (code, msg) => { reject(code, msg) }
			});
		});
	}

	error(code, msg)
	{
		this.loaded_as = null;

		console.error(code, msg);
	}
}
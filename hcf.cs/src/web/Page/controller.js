class extends hcf.web.Component
{
	constructor()
	{
		super();
		
		this.addEventListener('page-rendered', (e) => {
			this.loaded(this.pageRoot());
		});
	}

	connectedCallback()
	{
		if (this.initial_load_complete !== true)
		{
			this.runAfterDomLoad(()=>{
				let autoload = this.getAttribute('autoload');
				this.render_changes = this.getAttribute('render-changes');

				if (autoload != null && autoload != 'false')
				{
					this.load();
				}
			});
		}

		this.initial_load_complete = true;
	}

	pageRoot()
	{
		return this.page_root;// the root element of your view
	}

	loaded(view_root)
	{
		// called when the page has load it's view.
		// This does not depend on placement in the dom unlike connectedCallback and may occur before
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

	load()// if element was created without autoload="true" load view by using this method (element-attributes will be passed as first arg to constructor)
	{
		if (this.loaded_as != undefined)
		{
			return this.reload();
		}
		else
		{
			let load_trigger = this.shadowRoot.querySelector('.hcf-load-trigger');

			if (load_trigger == null)
			{
				throw 'page was not loaded yet and load trigger cannot be found.';
			}

			load_trigger.remove();

			return this.loadView()
				.then((data) => 
				{
					this.loaded_as = this.FQN;
					this.viewLoadSuccess(data);
				})
				.catch((code, msg) =>  this.viewLoadFailed(code, msg));
		}
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
	static get observedAttributes() 
	{
		return [
			'render-changes'
		];
	}

  	attributeChangedCallback(attr, oldValue, newValue) 
  	{
  		if (attr.indexOf('-') > -1)
  		{
  			attr = attr.replace('-', '_');// attributes containing - need a _ for methodname instead
  		}

  		if (attr != null && oldValue != newValue)
  		{
    		this[attr] = newValue;// triggers setter that'll do the rest
  		}
    }

    set render_changes(val)
    {
   		if (val != null && val != 'false')
		{
			this.setupObserver();
		}
		else 
		{
			this.removeObserver();
		}
    }

    get render_changes()
    {
		return this.getAttribute('render-changes');
    }

	clear(return_nodes)
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

      	if (return_nodes !== true)
      	{
	      	remove.forEach((e) => {
	      		e.remove();
	      	});
      	}
      	else 
      	{
      		let ret = [];

      		remove.forEach((e) => {
      			ret.push(this.shadowRoot.removeChild(e));
      		});

      		return ret;
      	}
	}

	viewLoadSuccess(data)
	{
		let e = new Event('page-load-view-success', {bubbles:true, composed:true});
		this.dispatchEvent(e);
		this.render(data);
	}

	viewLoadFailed(code, msg)
	{
		let e = new Event('page-load-view-failed', {bubbles:true, composed:true});
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

		this.style.visibility = 'hidden';
		let nodes = [];
		let first = null;			
		let wrapper = null;
		if (view_data.constructor === Array)
		{
			// node list
			nodes = view_data;
		}
		else 
		{
			let wrapper = document.createElement('div');
			wrapper.innerHTML = view_data;
			
			for (var i in wrapper.children)
			{
				nodes.push(wrapper.children[i]);
			}
		}

		nodes.forEach((node) => {
      		if (node instanceof HTMLElement)
      		{
      			if (first == null)
      			{
      				first = node;
      			}

      			this.shadowRoot.appendChild(node);
      		}
		});
			
		if (wrapper != null)
		{
			wrapper.remove();
		}

      	this.page_root = first;
      	let me = this;

      	// browser must finish it's rendering first before page can be shown to avoid flickering (without cache it may take too long)
      	setTimeout(function(){
	      	me.style.visibility = null;
			
			let e = new Event('page-rendered', {bubbles:true, composed:true});
	      	me.dispatchEvent(e);
      	}, 50);
	}

	getOwnAttributes()
	{
		let atts = this.attributes;
		let out = {};
		let skip = ['render-changes', 'autoload', 'style', 'class'];//dont pass these attributes to the page

		for (var i in atts)
		{
			if (!isNaN(i))
			{
				let att = atts[i];

				if (skip.indexOf(att.name) != -1)
				{
					continue;
				}

				out[att.name] = att.value;
			}
		}

		return out;
	}

	loadView()
	{
      	var e = new Event('page-load-view-begin', {bubbles:true, composed:true});
		this.dispatchEvent(e);

		return this.bridge().render().do([this.getOwnAttributes()]);
	}

	error(code, msg)
	{
		this.loaded_as = null;

		console.error(code, msg);
	}

	removeObserver()
	{
		if (this._observer != undefined)
		{
			this._observer.disconnect();

			delete this._observer;
		}
	}

	setupObserver()
	{
		if (this._observer != undefined)
		{
			this.removeObserver();
		}

		const config = { attributes: true, childList: false, subtree: false };
		this._observer = new MutationObserver((e) => { 
			if (e[0].attributeName != 'style' && e[0].attributeName != 'class')
			{
				this.reload()
			}
		});

		// Start observing the root element for mutations. If occured, the page will re-render with new attributes passed to server
		this._observer.observe(this, config);
	}
}
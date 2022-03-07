class extends hcf.web.Component
{
	constructor()
	{
		super();
		
		if (hcf.web.PageLoader.instance != undefined)
		{
			throw 'only one hcf.web.PageLoader instance (= 1 page-loader element) can exist per document';
		}

		hcf.web.PageLoader.instance = this;
		window.addEventListener('popstate', (e) => this.navigationOccured(e));

		// if page reload is triggered fade content
		this.addEventListener('page-load-view-begin', (e) => { this.hideContainer(); this.removeObserver()});
		this.addEventListener('page-rendered', (e) => {this.showContainer(); this.setupObserver()});
		this.addEventListener('page-load-view-failed', (e) => this.displayError(0, 'reloading view failed.'));
	}

	setupObserver()
	{
		// Options for the observer (which mutations to observe)
		const config = { attributes: false, childList: true, subtree: true };

		// Callback function to execute when mutations are observed
		const callback = (mutationsList, observer) =>
		{
		  this.initRouterLinks();
		};

		// Create an observer instance linked to the callback function
		this.observer = new MutationObserver(callback);

		// Start observing own contents for mutations
		for (let i in this.children)
		{
			let child = this.children[i];
			if (child instanceof hcf.web.Page)
			{
				this.observer.observe(child.shadowRoot, config);
			}
		}
	}

	removeObserver()
	{
		if (this.observer == null || this.observer == undefined)
		{
		  return;
		}

		this.observer.disconnect();
		this.observer = null;
	}

	connectedCallback()
	{
		if (this.current_route == undefined)
		{
			this.runAfterDomLoad(() => {
				this.loader_color = this.getAttribute('loader-color');
				this.loader_color_error = this.getAttribute('loader-color-error');
				this.link_class = this.getAttribute('link-class');

				if (!this.hasAttribute('route'))
				{
					throw 'route attribute required.';
				}

				this.initStateFragments();
				this.initRouterLinks();
				this.loadPage(this.getAttribute('route'));
			});

			super.instance = this;
		}
	}

	static get observedAttributes() 
	{
		return [
			'loader-color-error', 'loader-color', 'link-class'
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

	set link_class(val)
	{
		if (val == null || val == undefined)
		{
			this._link_class = 'router-link';
		}
		else 
		{
			this._link_class = val;
		}
	}

	get link_class()
	{
		return this._link_class;
	}

	set loader_color(val)
	{
		this._loader_color = val;
	}

	get loader_color()
	{
		return this._loader_color;
	}

	set loader_color_error(val)
	{
		this._loader_color_error = val;
	}

	get loader_color_error()
	{
		return this._loader_color_error;
	}

	// PAGELOADER:
	static instance = null;
	static current_request = null;
	static _cache = {};
	static _map = {};

	static cache(page_fqn, set)
	{
		let me = hcf.web.PageLoader;

		if (set == undefined)
		{
			if (me._cache[page_fqn] == undefined)
			{
				return null;
			}
			
			return me._cache[page_fqn];
		}

		me._cache[page_fqn] = set;

		if (set === false)// disable cache
		{
			delete me._map[page_fqn];
		}
	}

	static addToMap(route_name, target_page_fqn)
	{
		let me = hcf.web.PageLoader;

		if (me._map[target_page_fqn] == undefined)
		{
			me._map[target_page_fqn] = [route_name];
		}
		else 
		{
			me._map[target_page_fqn].push(route_name);
		}
	}

	static pageFqnForRoute(route_name)
	{
		let me = hcf.web.PageLoader;

		for (let i in me._map)
		{
			let o = me._map[i];

			if (o.indexOf(route_name) > -1)
			{
				return i;
			}
		}

		return null;
	}

	// INIT:

	initStateFragments()
	{
		let error_slot = this.shadowRoot.querySelector('.error-fragment');
		let main_slot = this.shadowRoot.querySelector('.main-fragment');

		if (error_slot.assignedElements().length > 0)
		{
			let ae = error_slot.assignedElements();
			let elem = ae[0];
			this.page_error_fragment = elem.parentNode.removeChild(elem);
		}

		error_slot.classList.add('initialized');
	}

	addLinkListener(to_elem)
	{
		if (!to_elem.classList.contains('router-link-initialized'))
		{
			to_elem.addEventListener('click', (e) => { this.routerLinkClicked(e); });
			to_elem.classList.add('router-link-initialized');
		}
	}

	inspectElementForRouterLinks(search_for_router_links)
	{
		if (search_for_router_links.shadowRoot != null && search_for_router_links.shadowRoot != undefined)
		{
			// custom elements with this.link_class + -crawl will be searched trough for contained links
			if (search_for_router_links.classList.contains('crawl-add-all'))
			{
				// if custom element also contains class "crawl-add-all" all contained links will be initialized
				search_for_router_links.shadowRoot.querySelectorAll('a[href]').forEach((shadow_router_link) => 
				{
					this.addLinkListener(shadow_router_link);
				});
			}
			else 
			{
				// if custom element does not contain "crawl-add-all" class, only links with this.link_class will be initilalized 
				// (this depends on the custom element implementation itself but is neccessary if not all links should be initialized)
				search_for_router_links.shadowRoot.querySelectorAll('.' + this._link_class).forEach((shadow_router_link) => 
				{
					this.addLinkListener(shadow_router_link);
				});
			}

			// search recursive
			search_for_router_links.shadowRoot.querySelectorAll('.' + this._link_class + '-crawl').forEach((e) => this.inspectElementForRouterLinks(e));
		}
	}

	initRouterLinks()
	{
		document.querySelectorAll('.' + this._link_class + '-crawl').forEach((e) => this.inspectElementForRouterLinks(e));

		if (this.firstChild instanceof hcf.web.Page)
		{
			this.inspectElementForRouterLinks(this.firstChild);
		}

		document.querySelectorAll('.' + this._link_class).forEach((router_link) => 
		{
			this.addLinkListener(router_link);
		});
	}

	topLoaderElement()
	{
		return this.shadowRoot.querySelector('.top-loader');
	}

	contentWrapperElement()
	{
		return this.shadowRoot.getElementById('content-wrapper');
	}

	// ACTIONS:
	syncQuery(new_args)
	{
		if (new_args == null)
		{
			this.removeAttribute('query');
		}

		this.setAttribute('query', this.joinUrlArgs('', new_args, false));
	}

	reload()
	{
		let route_name = this.current_route;

		if (this.error_page_active || this.current_page == undefined || this.current_page == null)
		{
			route_name = this.extractRouteName(window.location.pathname);// error or loader page is visible, try with current path
		}
		else 
		{
			if (route_name == null)// cache disabled
			{
				route_name = this.extractRouteName(window.location.pathname);
			}

			let me = hcf.web.PageLoader;
			let fqn = this.current_page;
			me.cache(fqn, false);// disable cache temporarely
		}

		this.hideContainer();
		this.loadPage(route_name);
	}

	loadPage(route_name)
	{
		if (route_name == null || route_name == undefined || route_name.trim() == '')
		{
			throw 'Invalid route ' + route_name + ' given.';
		}

		if (this.current_request != null)
		{
			console.warn('a page-request was already running and will be aborted.');
			this.current_request.abort();
			this.current_request = null;
		}

		this.hideContainer();
		this.resetTopLoader() 

		this.current_route = route_name;

		let me = hcf.web.PageLoader;
		let page_fqn = me.pageFqnForRoute(route_name);
		
		let e = new Event('page-load-begin', {bubbles:true});
		this.dispatchEvent(e);

		if (page_fqn != null)
		{
			let cached_page = me.cache(page_fqn);

			if (cached_page != null && cached_page !== false)
			{
				this.documentReady(route_name, cached_page, true);
				return;
			}
		}
		
		this.loadPageFromServer(route_name);
	}

	loadPageFromServer(route_name)
	{
		let query = this.getAttribute('query');
		let initial_args = null;

		if (query != null && query != '')
		{
			if (query.substr(0,1) != '?')
			{
				query = '?' + query;
			}

			initial_args = this.extractRouteName(query);
			initial_args = initial_args.args;

			this.removeAttribute('query');// query is only per page-load basis valid, on navigation the arguments on the used link will be used.
		}

		this.bridge().invoke('load').do({
			arguments:[route_name, hcf.web.PageLoader._map, initial_args],
			timeout: 0,
			onBefore: (xhr) => { this.current_request = xhr },
			onUpload: (e) => this.setTopLoaderProgress( (e.loaded / e.total * 100) * .25 ), // first 25% are for uploads 
				/* Beginning on 25% until 50% = download-progress - last 50% used for component-resources (styles, controller, templates).
					If Content != json -> e.total is not working, also setting correct content-type headers will be ignored */
			onProgress: (e) => { this.setTopLoaderProgress( ((e.loaded / (e.lengthComputable ? e.total : e.loaded) * 100) * .25) + 25)}, 
			onSuccess: (data) => this.preloadDependencies(route_name, data),
			onError: (msg, code) => this.displayError(code, msg),
			onTimeout: (code, msg) => this.displayError(code, msg)
		});
	}

	hideContainer()
	{
		this.contentWrapperElement().classList.add('loading');
	}

	showContainer()
	{
		this.contentWrapperElement().classList.remove('loading');
	}

	resetTopLoader()
	{
		this.setTopLoaderColor(this._loader_color);
		this.topLoaderElement().style.width = 0;
	}

	getTopLoaderProgress()
	{
		return Number(this.topLoaderElement().style.width.replace('%', ''));
	}

	setTopLoaderProgress(to)
	{
		this.topLoaderElement().style.width = to + '%';
	}

	setTopLoaderColor(to)
	{
		this.topLoaderElement().style.background = to;
	}

	unloadCurrentPage()
	{
		if (this.initial_page_unloaded !== true)
		{
			// first load, content is pre-rendered placeholder fragment that just need to be removed
			this.innerHTML = '';
			this.initial_page_unloaded = true;
			return;
		}

		if (this.error_page_active === true)
		{
			this.error_page_active = false;
			this.page_error_fragment = this.removeChild(this.page_error_fragment);
			this.current_route = null;
			this.current_page = null;
			return;
		}

		let me = hcf.web.PageLoader;
		let fqn = this.current_page;
		let c = me.cache(fqn);
		let store = document.createElement('div');
		let children = this.children;
		let clone = [];

		for (let i in children)
		{
			let e = children[i];

			if (e instanceof hcf.web.Page)
			{
				clone.push(e);
			}
		}
		
		clone.forEach((page) => 
		{
			page.beforeUnload();
			store.appendChild(this.removeChild(page));
		});

		if (c === false)
		{
			// cache disabled for this page
		}
		else 
		{
			if (c != null)
			{
				c.view = store;
			}

			me.cache(fqn, c);
		}

		this.current_route = null;
		this.current_page = null;
	}

	wasCached(route_name, o)
	{
		if (o.is_cached_as != undefined)
		{
			let me = hcf.web.PageLoader;
			let cached_page = me.cache(o.is_cached_as);

			if (cached_page != null)
			{
				me.addToMap(route_name, o.is_cached_as);
				this.documentReady(route_name, cached_page, true);
				
				return true;
			}
			else 
			{
				throw 'missing cache data.';
			}
		}

		return false;
	}

	preloadDependencies(route_name, data)
	{
		this.current_request = null; // xhr.abort not possible anymore

		let o = JSON.parse(data);

		if (this.wasCached(route_name, o))
		{
			return;
		}

		if (o.preload != undefined)
		{
			let me = hcf.web.PageLoader;
			let preload_data = o.preload;
			let preload_promises = [];

			for (let render_context in o.preload)
			{
				let components = o.preload[render_context];

				if (components.length == 0)
				{
					continue;
				}

				if (render_context.substr(0,1) == '@')
				{
					let first_component = components[0];
					render_context = document.cloneRenderContext(render_context.substr(1), first_component).getAttribute('id');
				}

				let context_promises = hcf.web.Controller.loadResources(components, (render_context == 'global') ? undefined : render_context);
				preload_promises = preload_promises.concat(context_promises);
			}

			if (preload_promises.length > 0)
			{
				let part = 48 / preload_promises.length; // every part of the preload-resources (controller, templates, styles) share a part of the loaders last 48% (except the 2% for rendering)
		
				for (var i in preload_promises)
				{
					let cp = preload_promises[i];

					cp.then(() => {
						this.setTopLoaderProgress(this.getTopLoaderProgress() + part);
					});
				}
			}

			Promise.all(preload_promises).catch((e) => this.displayError(e, 'Preloading resources failed.')).then(() => this.documentReady(route_name, o));
		}
		else 
		{
			this.documentReady(route_name, o);
		}
	}

	setTitle(to)
	{
		document.head.querySelector('title').innerText = to;
	}

	addView(view_data)
	{
		let view = view_data.view;
		let which = view_data.which;
		let rendered = view_data.rendered;

		if (view instanceof HTMLElement)// wrapper from cache
		{
			let children = view.children;
			let clone = [];

			for (var i in children)
			{
				if (children[i] instanceof hcf.web.Page)
				{
					clone.push(children[i]);
				}
			}

			clone.forEach((e) => {
				this.appendChild(view.removeChild(e));
			});

			this.showContainer();// show container instantly, no page-rendered event will be thrown
		}
		else 
		{
			this.innerHTML = view;
			let page_elem = this.firstChild;

			if (!(page_elem instanceof hcf.web.Page))
			{
				throw 'given element is no hcf.web.Page instance';
			}

			if (rendered != undefined)
			{
				page_elem.injectView(rendered, which);
			}

			this.appendChild(page_elem);
			this.initRouterLinks();
		}

		return this.firstChild;
	}

	displayErrorPage()
	{
		this.unloadCurrentPage();

		this.error_page_active = true;

		if (this.page_error_fragment != undefined && this.page_error_fragment != null)
		{
			this.appendChild(this.page_error_fragment);
		}
	}

	displayError(code, msg)
	{
		this.current_request = null;
		this.setTopLoaderColor(this._loader_color_error);
		//this.setTopLoaderProgress(100);
		this.displayErrorPage();
		this.showContainer();
		console.error('Loading failed: Error ', code, msg);

		let event = new Event('page-load-failed', {bubbles:true});
		this.dispatchEvent(event);
	}

	// EVENTS:
	documentReady(route_name, o, from_cache)
	{
		try 
		{
			this.unloadCurrentPage();
			
			let page_elem = this.addView(o);
			this.setTitle((o.title == '') ? o.which : o.title);
			
			this.setTopLoaderProgress(99);// view initialized (rendering happens asnyc)
			
			if (o.redirect != undefined)
			{
				this.redirected(o.redirect);
			}
			else 
			{
				this.current_route = route_name;
			}

			if (from_cache === true)
			{
				page_elem.cacheReload(page_elem);
			}
			else 
			{
				let me = hcf.web.PageLoader;

				if (page_elem.cache())
				{
					me.cache(o.which, o);
					me.addToMap(route_name, o.which);
				}
				else 
				{
					me.cache(o.which, false);
				}
			}

			this.current_page = o.which;
			this.setTopLoaderProgress(100);//fully initialized

			let event = new Event('page-load-success', {bubbles:true});
			this.dispatchEvent(event);
		}
		catch (e)
		{
			this.displayError(0, 'Failed on initialisation: ' + e);
		}
	}

	redirected(to_route)
	{
		let href = this.extractRouteName(window.location.href);

		this.current_route = to_route;

		this.syncQuery(href.args);
		history.pushState(null, null, this.joinUrlArgs(to_route, href.args, href.fancy));
	}

	navigationOccured(event)
	{
		let parts = this.extractRouteName(window.location.pathname);
		let href = parts.route;
		let args = parts.args;

		this.syncQuery(args);
		this.loadPage(href);
	}

	routerLinkClicked(event)
	{
		if (event.which != 1 || event.ctrlKey || event.shiftKey || event.metaKey)
		{
			return;// on mousewheel-click or ctrl/shift/cmd-key hold while click open in new tab/window -> no internal navigation
		}

		event.preventDefault();// do not redirect to url
		let href = null;

		if (!event.target.hasAttribute('href'))
		{
			let link_lookup = event.target.closest('a[href]');

			if (link_lookup == null)
			{
				throw 'cannot determine route for ' + this._link_class + ' element ' + event.target;
			}

			href = link_lookup.getAttribute('href');
		}
		else 
		{
			href = event.target.getAttribute('href');
		}

		let parts = this.extractRouteName(href);

		if (parts.route == this.current_route)
		{
			return; // no reload if same page should be load
		}

		let new_url = this.joinUrlArgs(parts.route, parts.args, parts.fancy);

		this.syncQuery(parts.args);
		history.pushState(null, null, new_url);
		this.loadPage(parts.route);
	}

	// URL STUFF
	
	dispatchQuery(href)
	{
		let arg = this.contentWrapperElement().getAttribute('data-router-arg');
		let parts = href.split('&');
		let route = null;
		let url_args = {};

		for (var i in parts)
		{
			let part = parts[i].split('=');
			let key = part[0];

			if (key == arg && part[1] != undefined)
			{
				route = part[1];
			}
			else 
			{
				url_args[key] = part[1];
			}
		}

		return {
			fancy: false,
			'route': route,
			'args': url_args
		};
	}

	extractRouteName(href)
	{
		if (href == '')
		{
			return {
				fancy: false,
				route: null,
				args: null
			};
		}

		let router_default = this.contentWrapperElement().getAttribute('data-router-default');

		if (href.substr(0, 4) == 'http')
		{
			// absolute url, strip down until first / or ?
			href = href.substr(8); // skip https://

			let qmark_i = href.indexOf('?');
			let slash_i = href.indexOf('/');

			if (qmark_i == -1 && slash_i == -1)
			{
				href = router_default;
			}
			else if (qmark_i == -1 || slash_i < qmark_i)
			{
				href = href.substr(slash_i);
			}
			else if (slash_i == -1 || qmark_i < slash_i)
			{
				href = href.substr(qmark_i);
			}
			else
			{
				href = router_default;	
			}
		}

		if (href.substr(0, 1) == '?')//regular urls with route-name as url-arg: ?foo=bar&route=target&other-arg=true
		{
			href = href.substr(1);

			return this.dispatchQuery(href);
		}

		// fancy-urls where route-name is path-part of url: /route?path-is-route=true&foo=bar or route?arg=1&arg=false without leading /
		if (href.substr(0, 1) == '/')
		{
			href = href.substr(1);
		}

		href = href.split('?');

		let url_args = href[1];
		if (url_args != undefined)
		{
			url_args = this.dispatchQuery(url_args).args;
		}
		else 
		{
			url_args = {};
		}

		let route_parts = href[0].split('/');
		let route = route_parts[0];

		if (route == '')
		{
			route = router_default;// try default of hcf.web.Router
		}

		return {
			fancy: true,
			'route': route,
			'args': url_args
		};
	}

	joinUrlArgs(route, args, fancy)
	{
		let out = '?';

		if (!fancy)
		{
			let arg = this.contentWrapperElement().getAttribute('data-router-arg');
			out += arg + '=' + route + '&';
		}

		Object.keys(args).forEach((a) => 
		{
			out += a + '=' + args[a] + '&';
		});
	
		if (fancy)
		{	
			out = route + out;
		}

		return out.slice(0, -1);
	}
}
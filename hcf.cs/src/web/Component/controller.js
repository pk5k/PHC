class extends HTMLElement // extend an anonymous class from hcf.web.Component in your own component
{
	constructor()
	{
		super();
		this.attachShadow({mode: 'open'});
		this.loadTemplate();
	}

	construct()
	{
		if (this._constructed)
		{
			return;
		}

		if (this._constructed === false)// instance was destructed and constructed again (would be undefined if initial construct)
		{
			this.loadTemplate();
		}

		this._constructed = true;

		this.linkStylesheets();
		this.constructedCallback();// use this as constructor of your implementation
	}

	constructedCallback()
	{
		// override in your own implementation
	}

	destruct()
	{
		if (!this._constructed)
		{
			return;
		}
		
		this._constructed = false;
		this.destructedCallback();// add a destructedCallback function to your element to react to removal of the node
		// clear own data after callback if destroyedCallback makes use of e.g. shadow dom (to clean up it's listeners)
		this.unlinkStylesheets();
		this.removeEventListeners();
		this.shadowRoot.removeEventListeners();
		this.shadowRoot.innerHTML = '';
		this.innerHTML = '';
	}

	destructedCallback()
	{
		// override in your own implementation
	}

	connectedCallback()
	{
		if (!this._constructed)
		{
			this.construct();
		}

		this._connected = true;
	}

	disconnectedCallback()
	{
		let c = this;

		setTimeout(function()// runs after browser finished rendering it's current frame
		{
			if (c.getRootNode().host == undefined && !document.body.contains(c) && // if root node is still disconnected the element will be cleaned up
				!c.inPreservedContext())// add preserve=true to an element that should be kept alive even if detached
			{
				c.destruct();
			}
		}, 0);
		
		this._connected = false;
	}

	inPreservedContext()
	{
		if (this.preserve == true || this.getAttribute('preserve') == 'true')
		{
			return true;
		}

		// parents containing preserved flag will shadow to all it's children
		let p = this.parentNode;

		while (p != null)
		{
			if (p.preserve == true || p.getAttribute('preserve'))
			{
				return true;
			}

			p = p.parentNode;
		}

		return false;
	}

	loadTemplate()
	{
		if (this.shadowRoot == undefined)
		{
			throw 'No shadow root attached to load template - in ' + this.FQN;
		}

		let tpl = this.renderContextTemplate();
		let children = tpl.children;

      	for (let i in children)
      	{
      		if (children[i] instanceof HTMLElement)
      		{
      			this.shadowRoot.appendChild(children[i].cloneNode(true));
      		}
      	}
	}

	contextStylesheets()
	{	
		let context_styles = document.componentStyleMap[this.renderContextId()];
		let context_fonts = [];

		if (this.renderContext().getAttribute('data-import-fonts') == 'true')
		{
			let fonts = document.importFontList();
			context_styles = fonts.concat(context_styles);// load fonts first
		}

		return context_styles;
	}

	linkStylesheets()
	{
		if (this._styles_setup)
		{
			return;
		}

		if (this.shadowRoot == undefined)
		{
			throw 'No shadowRoot initialized for ' + this.FQN;
		}

		let context_styles = this.contextStylesheets();

		if (context_styles != undefined)
		{
	      	this.shadowRoot.adoptedStyleSheets = context_styles;
		}

		this._styles_setup = true;
	}

	unlinkStylesheets()
	{
		if (!this._styles_setup)
		{
			return;
		}
		
		if (this.shadowRoot == undefined)
		{
			throw 'No shadowRoot initialized for ' + this.FQN;
		}

		//this.shadowRoot.adoptedStyleSheets = [];
		delete this.shadowRoot.adoptedStyleSheets;
		this._styles_setup = null;
	}

	view()
	{
		if (this.shadowRoot == undefined)
		{
			throw 'View for ' + this.FQN + ' was not initialized yet.';
		}

		// Components view is always in shadowRoot
		return this.shadowRoot;
	}

	bridge(to)
	{
		return hcf.web.Bridge((to == undefined) ? this.FQN : to);// this.FQN is defined in registerComponentController for prototype of your hcf.web.Controller/.Component/.Page
	}

	renderContextTemplate()
	{
		let render_context_id = this.renderContextId();
		let rc = this.renderContext();

		if (render_context_id == 'global')
		{
			return rc.querySelector('div[id="' + this.FQN + '"]');
		}
		else 
		{
			let context = rc.content;
			return context.getElementById(this.FQN);
		}
	}

	renderContextId()
	{
		if (document.componentMap[this.FQN] == undefined)
		{
			throw 'Element ' + this.tagName.toLowerCase() + ' is not in the component map and thus cannot be used.';
		}

		return document.componentMap[this.FQN];
	}

	renderContext()
	{
		if (document.componentMap[this.FQN] == undefined)
		{
			throw 'Element ' + this.tagName + ' (' + this.FQN + ') is not registered in component map - render context cannot be determined';
		}

		let render_context = this.renderContextId();

		if (render_context == 'global')
		{
			return document.head;// global context
		}
		else 
		{
			return document.getElementById(render_context);
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
	    	let loadedFunc = function()
	    	{
	    		func();
	    		window.removeEventListener('DOMContentLoaded', loadedFunc);
	    	};
	      	
	      	window.addEventListener('DOMContentLoaded', loadedFunc);// wait until children are initialised
	    }
	    else 
	    {
	    	func();
	    }
	}

	dispatchEvent(event)// allow custom event attribute like onsubmit-before
	{
	    let ret = super.dispatchEvent(event);
	    const eventFire = this['on' + event.type];
	    
	    if (eventFire) 
	    {
	    	return ret; // already processed by super.dispatchEvent
	    } 
	    else 
	    {

	      const func = new Function('e',
	        'with(document) {' +
	        'with(this) {' +
	        'let attr = ' + this.getAttribute('on' + event.type) + ';' + 
	        'if(typeof attr === \'function\' && this instanceof HTMLElement) { return attr(e)};' +
	        '}' +
	      '}');


	      let ret_own = func.call(this, event);

	      return ret_own || ret;
	    }
	}
}
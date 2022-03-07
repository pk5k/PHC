class extends HTMLElement // extend an anonymous class from hcf.web.Component in your own component
{
	constructor()
	{
		super();
		this.loadTemplate();
	}

	loadTemplate()
	{
		if (document.componentMap[this.FQN] == undefined)
		{
			throw 'Element ' + this.tagName.toLowerCase() + ' is not in the component map and thus cannot be used.';
		}

		let render_context = document.componentMap[this.FQN];

		let shadow_root = this.attachShadow({mode: 'open'});
		let context = null;
		let tpl = null;

		if (render_context == 'global')
		{
			context = document.head;// global context
			tpl = context.querySelector('div[id="' + this.FQN + '"]');
		}
		else 
		{
			context = document.getElementById(render_context).content;
			tpl = context.getElementById(this.FQN);
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

	bridge(to)
	{
		return hcf.web.Bridge((to == undefined) ? this.FQN : to);// this.FQN is defined in registerComponentController for prototype of your hcf.web.Controller/.Component/.Page
	}

	renderContext()
	{
		if (document.componentMap[this.FQN] == undefined)
		{
			throw 'Element ' + this.tagName + ' (' + this.FQN + ') is not registered in component map - render context cannot be determined';
		}

		return document.getElementById(document.componentMap[this.FQN]);
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
class extends HTMLElement // extend an anonymous class from hcf.web.Component in your own component
{
	constructor()
	{
		super();
		this.loadElement();
	}

	loadElement()
	{
		if (document.componentMap[this.tagName] == undefined)
		{
			throw 'Element ' + this.tagName.toLowerCase() + ' is not in the component map and thus cannot be used.';
		}

		let component_definition = document.componentMap[this.tagName];

		let shadow_root = this.attachShadow({mode: 'open'});
		let content = document.getElementById(component_definition.context).content;
		let tpl = content.getElementById(component_definition.fqn);

      	shadow_root.appendChild(content.getElementById('base-style').cloneNode(true));

      	let children = tpl.children;

      	for (let i in children)
      	{
      		if (children[i] instanceof HTMLElement)
      		{
      			shadow_root.appendChild(children[i].cloneNode(true));
      		}
      	}
	}
}
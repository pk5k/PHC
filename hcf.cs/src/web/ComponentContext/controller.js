document.registerComponentController = function(hcfqn, controller_class, component_context_id, as_element, element_options)
{
	var prop_hcfqn = hcfqn;
  var split = hcfqn.split('.')
	var scope = window;
	var hcfqn = split.pop();
	var prop_name = hcfqn;

  for (var i in split)
  {
    var part = split[i];

    if (!scope[part])
    {
      scope[part] = {};
    }

    scope = scope[part];
  }

	//controller_class.prototype = scope;
	controller_class.FQN = prop_hcfqn;
	controller_class.NAME = prop_name;
	
  scope[hcfqn] = controller_class;

  if (as_element != undefined && as_element != null)
  {
    if (element_options == undefined)
    {
      element_options = {};
    }

    customElements.define(as_element, scope[hcfqn], element_options);

    if (document.componentMap == undefined)
    {
      document.componentMap = {};
    }

    document.componentMap[as_element.toUpperCase()] = {
      fqn: prop_hcfqn,
      context: component_context_id
    };
  }

  return scope[hcfqn];
};
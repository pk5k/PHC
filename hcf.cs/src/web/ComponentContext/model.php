<?php
/**
 * Create instance of ComponentContext, add hcf.web.Components via ::register and pass ComponentContext to hcf.web.Container::registerComponentContext
 * to make all registered instances available in your document. Each registered component must extend hcf.web.Component
 **/

use \Exception;
use \hcf\web\Component as WebComponent;

trait Model
{
	private static $registry = [];
	private $components = [];
	private $id = null;
	private $stylesheet_embed = [];
	private $allow_global_style = 'false';

	public function onConstruct($id)
	{
		if (is_null($id) || trim($id) == '')
		{
			throw new Exception(self::FQN.' - given id is invalid.');
		}
		else if (isset(self::$registry[$id]))
		{
			throw new Exception(self::FQN.' - given id is already registered');
		}

		$this->id = $id;
		self::$registry[$id] = $this;
	}

	public function allowGlobalStyle($allow)
	{
		$this->allow_global_style = ($allow) ? 'true' : 'false';
	}

	public function register(/* WebComponent::class */ $component_class)
	{
		if (!is_subclass_of($component_class, WebComponent::class))
		{
			throw new Exception(self::FQN .' - given class '.$component_class.' does not implement '.WebComponent::class);
		}

		$fqn = $component_class::FQN;

		if (isset($this->components[$fqn]))
		{
			throw new Exception(self::FQN.' - component ' . $fqn . ' already registered.');
		}

		$this->components[$fqn] = $component_class;
	}

	private function clientControllerOf($component)
	{
		if (is_null($component::elementName()) || $component::elementName() == WebComponent::elementName())
		{
			return self::wrappedClientController($component::FQN, $component::script());
		}
		else
		{
			return self::wrappedClientControllerWithElement($component::FQN, $component::script(), $this->id, $component::elementName(), $component::elementOptions());
		}
	}

	private function styleOf($component)
	{
		return $component::style();
	}

	private function templateOf($component)
	{
		return $component::template();
	}

	public function embedStylesheet($which)
	{
		$this->stylesheet_embed[] = $which;
	}
}
?>
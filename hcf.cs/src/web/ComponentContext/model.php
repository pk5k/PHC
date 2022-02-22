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

	public static function get($id)
	{
		if (isset(self::$registry) && isset(self::$registry[$id]))
		{
			return self::$registry[$id];
		}

		return null;
	}

	public function allowGlobalStyle($allow)
	{
		$this->allow_global_style = ($allow) ? 'true' : 'false';
	}

	public function register(/* WebComponent::class */ $component_class)
	{
		if (!is_subclass_of($component_class, WebComponent::class) && $component_class != WebComponent::class)
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
		return $component::wrappedClientController($this->id);
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

	private function url($target, $component)
	{
		if (is_array($component))
		{
			$c_str = '';

			foreach ($component as $fqn => $component) 
			{
				$c_str .= $fqn.',';
			}

			$component = substr($c_str, 0, -1);
		}

		$v = (defined('APP_VERSION') ? '&v='.APP_VERSION : '');// define APP_VERSION and increment on updates to override caches

		return '?!=-'.$target.'&context='.$this->id.'&component='.$component.$v;
	}
}
?>
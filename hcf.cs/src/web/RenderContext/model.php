<?php
/**
 * Create instance of RenderContext, add hcf.web.Components via ::register and pass RenderContext to hcf.web.Container::registerRenderContext
 * to make all registered instances available in your document. Each registered component must extend hcf.web.Component
 **/

use \Exception;
use \hcf\web\Controller as WebController;
use \hcf\web\Component as WebComponent;
use \hcf\web\Container;

trait Model
{
	private static $registry = [];
	private $components = [];
	private $id = null;
	private $stylesheet_embed = [];
	private $allow_global_style = 'false';
	private $import_fonts = false;

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

	private function debugMode()
	{
		return HCF_DEBUG;
	}

	private function importedFonts()
	{
		return Container::loadedFonts();
	}

	public function importFonts($import = true)
	{
		$this->import_fonts = $import;// links the configured fonts of hcf.web.Container to the shadow dom
	}

	public function exportStyle($allow)
	{
		$this->allow_global_style = ($allow) ? 'true' : 'false';
	}

	public function register(/* WebController::class */ $component_class)
	{
		if (!is_subclass_of($component_class, WebController::class) && $component_class != WebController::class)
		{
			throw new Exception(self::FQN .' - given class '.$component_class.' does not implement '.WebController::class);
		}

		$fqn = $component_class::FQN;

		if (isset($this->components[$fqn]))
		{
			throw new Exception(self::FQN.' - component ' . $fqn . ' already registered.');
		}

		$this->components[$fqn] = $component_class;
	}

	public function embedStylesheet($which)
	{
		$this->stylesheet_embed[] = $which;
	}

	private function componentsLoad()
	{
		return (count($this->components) > 0);
	}

	private static function containerBaseDir()
	{
		return isset(Container::config()->base) ? Container::config()->base : '/';
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
		
		$context = '';
		
		if ($target == 'template' || $target == 'style')
		{
			$context = '&context='.$this->id;
		}

		$v = (defined('APP_VERSION') ? '&v='.APP_VERSION : '');// define APP_VERSION and increment on updates to override caches

		return self::containerBaseDir().'?!=-'.$target.$context.'&component='.$component.$v;
	}
}
?>
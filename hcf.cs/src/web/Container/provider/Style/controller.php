<?php
use \hcf\core\Utils;
use \hcf\web\Component as WebComponent;
use \hcf\web\Controller as WebController;
use \hcf\web\RenderContext;

trait Controller
{
	public static function provideAssemblies()
	{

		if (isset($_GET['component']))
		{
			parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mystyle.js'));

			return self::provideComponentStyle(htmlspecialchars($_GET['component']));
		}

		parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mystyle.css'));

		return parent::provideAssembliesOfType('style');
	}

	private static function provideComponentStyle($hcfqn)
	{
		$context = (isset($_GET['context']) ? htmlspecialchars($_GET['context']) : null);
		$classes = parent::getComponents($hcfqn, WebComponent::class, WebController::class);
		$out = '';
		$first_class = null;

		foreach ($classes as $class) 
		{
			if (is_null($first_class))
			{
				$first_class = $class;
			}

			$out .= $class::style();
		}

		if (is_null($first_class))
		{
			return '';
		}

		return $first_class::wrappedStyle($context, $out);// creates only style element in client
	}
}
?>

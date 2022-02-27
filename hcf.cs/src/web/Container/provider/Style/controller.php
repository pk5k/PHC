<?php
use \hcf\core\Utils;
use \hcf\web\Component as WebComponent;
use \hcf\web\Controller as WebController;

trait Controller
{
	public static function provideAssemblies()
	{
		parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mystyle.css'));

		if (isset($_GET['component']))
		{
			return self::provideComponentStyle(htmlspecialchars($_GET['component']));
		}

		return parent::provideAssembliesOfType('style');
	}

	private static function provideComponentStyle($hcfqn)
	{
		$classes = parent::getComponents($hcfqn, WebComponent::class, WebController::class);
		$out = '';

		foreach ($classes as $class) 
		{
			$out .= $class::style();
		}

		return $out;
	}
}
?>

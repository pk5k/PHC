<?php
use \hcf\core\Utils;
use \hcf\web\Controller as WebController;

trait Controller
{
	public static function provideAssemblies()
	{
		parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('myscript.js'));

		if (isset($_GET['component']))
		{
			return self::provideComponentScript(htmlspecialchars($_GET['component']));
		}

		return parent::provideAssembliesOfType('script');
	}

	private static function provideComponentScript($hcfqn)
	{
		$classes = parent::getComponents($hcfqn, WebController::class);
		$out = '';

		foreach ($classes as $class) 
		{
			$out .= $class::wrappedClientController();
		}

		return $out;
	}
}
?>

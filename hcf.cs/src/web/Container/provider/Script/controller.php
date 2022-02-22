<?php
use \hcf\core\Utils;
use \hcf\web\Component as WebComponent;

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
		$context = (isset($_GET['context']) ? htmlspecialchars($_GET['context']) : '');
		$classes = parent::getComponents($hcfqn);
		$out = '';

		foreach ($classes as $class) 
		{
			$out .= $class::wrappedClientController($context);
		}

		return $out;
	}
}
?>

<?php
use \hcf\core\Utils;

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
		$classes = parent::getComponents($hcfqn);
		$out = '';

		foreach ($classes as $class) 
		{
			$out .= $class::style();
		}

		return $out;
	}
}
?>

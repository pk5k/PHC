<?php
use \hcf\core\Utils;
use \hcf\web\Component as WebComponent;
use \hcf\web\Controller as WebController;

trait Controller
{
	public static function provideAssemblies()
	{
		parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mytemplate.js'));

		if (!isset($_GET['component']))
		{
			throw new \Exception(self::FQN.' - no component given.');
		}

		return self::provideComponentTemplate(htmlspecialchars($_GET['component']));
	}

	private static function provideComponentTemplate($hcfqn)
	{
		$context = (isset($_GET['context']) ? htmlspecialchars($_GET['context']) : null);
		$classes = parent::getComponents($hcfqn, WebComponent::class, WebController::class);
		$out = '';

		foreach ($classes as $class) 
		{
			$out .= $class::wrappedTemplate($context);
		}

		return $out;
	}
}
?>

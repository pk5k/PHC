<?php
use \hcf\core\Utils;

trait Controller
{
	public static function provideAssemblies()
	{
		parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('myscript.js'));

		return parent::provideAssembliesOfType('client');
	}
}
?>

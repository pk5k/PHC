<?php
use \hcf\core\Utils;

trait Controller
{
	public static function provideAssemblies()
	{
		parent::provideFileTypeHeader(Utils::getMimeTypeByExtension('mystyle.css'));

		return parent::provideAssembliesOfType('style');
	}
}
?>

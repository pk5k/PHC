<?php
use \hcf\core\Utils as Utils;
use \hcf\web\Bridge\Worker\FormDataPolyfill;

trait Controller
{
	public static function render()
	{
		header('Content-Type: '.Utils::getMimeTypeByExtension('iAmJavascript.js'));

		// we need the FormData-Polyfill until Browsers like Safari support them inside workers
		return FormDataPolyfill::script().self::script();
	}
}
?>
<?php
use \hcf\web\Container\Autoloader;

trait Controller
{
	protected static function provideAssembliesOfType($which_type)
	{
		$autoloader_conf = Autoloader::config();

		if (!isset($autoloader_conf->client->$which_type) || !is_array($autoloader_conf->client->$which_type->hypercells))
		{
			throw new \Exception(self::FQN.' - config-assembly of '.Autoloader::FQN.' does not contain a '.$which_type.' configuration');
		}

		$al = new Autoloader(false);
		$ao = new \stdClass();//= $autoloader_conf->client
		$ao->$which_type = $autoloader_conf->client->$which_type;// extract this part of the config
		$ao->$which_type->link = false; // embed this time (was true, otherwise we won't be here)
		$ad = $al->clientLoader($ao);

		return $ad->$which_type;
	}

	protected static function provideFileTypeHeader($mime_type)
	{
		header('Content-Type: '.$mime_type);
	}
}
?>

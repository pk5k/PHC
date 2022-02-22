<?php
use \hcf\web\Container\Autoloader;
use \hcf\web\Component as WebComponent;
use \hcf\core\Utils;

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

	protected static function getComponents($hcfqn_str_list)
	{
		$parts = explode(',', $hcfqn_str_list);
		$out = [];

		foreach ($parts as $fqn) 
		{
			$out[] = self::getComponent(trim($fqn));
		}

		return $out;
	}

	protected static function getComponent($hcfqn)
	{
		if (!Utils::isValidRMFQN($hcfqn))
		{
			header(Utils::getHTTPHeader(400));
			
			throw new \Exception(self::FQN.' given name is no valid hcfqn');
		}

		$class = Utils::HCFQN2PHPFQN($hcfqn);

		if (!is_subclass_of($class, WebComponent::class) && $class != WebComponent::class)
		{
			header(Utils::getHTTPHeader(400));

			throw new \Exception(self::FQN . ' given name ' . $hcfqn . ' does not refer to a hcf.web.Component');
		}

		return $class;
	}
}
?>

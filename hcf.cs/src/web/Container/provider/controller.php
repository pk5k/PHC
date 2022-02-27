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

		if (HCF_DEBUG)
		{
			return;
		}

		header('Cache-Control: max-age='.(30 * 24 * 60 * 60).', must-revalidate');// cache 30 days, on productive systems increase APP_VERSION constant to force refresh on dev use disable cache feature of browser
	}

	protected static function getComponents($hcfqn_str_list, $allowed_base, $ignore_if_base = null)
	{
		$parts = explode(',', $hcfqn_str_list);
		$out = [];

		foreach ($parts as $fqn) 
		{
			$class = self::getComponent(trim($fqn), $allowed_base, $ignore_if_base);

			if ($class !== false)
			{
				$out[] = $class;
			}
		}

		return $out;
	}

	protected static function getComponent($hcfqn, $allowed_base, $ignore_if_base = null)
	{
		if (!Utils::isValidRMFQN($hcfqn))
		{
			header(Utils::getHTTPHeader(400));
			
			throw new \Exception(self::FQN.' given name is no valid hcfqn');
		}

		$class = Utils::HCFQN2PHPFQN($hcfqn);

		if (!is_null($ignore_if_base) && (is_subclass_of($class, $ignore_if_base) || $class == $ignore_if_base) && !is_subclass_of($class, $allowed_base))
		{
			return false;
		}

		if (!is_subclass_of($class, $allowed_base) && $class != $allowed_base)
		{
			echo $ignore_if_base.' class:'.$class;
			header(Utils::getHTTPHeader(400));

			throw new \Exception(self::FQN . ' given name ' . $hcfqn . ' does not refer to a ' . $allowed_base::FQN);
		}

		return $class;
	}
}
?>

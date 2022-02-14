<?php
use \hcf\core\Utils as Utils;

trait Controller
{
	public function getName()
	{
		return 'CONFIG';
	}

	public function getConstructor()
	{
		return [1 => 'if(!isset(self::$config)){ self::loadConfig(); }'.Utils::newLine()];
	}

	public function getMethods()
	{
		// Config-Channels do not have a non-static method
		return null;
	}

	public function getStaticMethods()
	{
		$methods = [];

		$methods['loadConfig'] = $this->buildloadConfig();

		return $methods;
	}

	public function getProperties()
	{
		return null;
	}

	public function getStaticProperties()
	{
		return null;
	}

	public function getClassModifiers()
	{
		return null;
	}

	public function isAttachment()
	{
		return true;
	}

	public function isExecutable()
	{
		return false;
	}

	public function getAliases()
	{
		return null;
	}

	public function getTraits()
	{
		return ['Config' => '\\hcf\\core\\dryver\\Config'];
	}
}
?>

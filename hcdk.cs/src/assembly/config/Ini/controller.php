<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'INI';
	}

	public function buildLoadConfig()
	{
		$method = new Method('loadConfig', ['private', 'static']);
		$method->setBody($this->buildLoadConfigMethod());

		return $method->toString();
	}

	public function defaultInput()
	{
		return '';
	}

	public function checkInput()
	{
		$parser = new \IniParser();
		$parser->process($this->rawInput());// throw Exception if input is invalid
	}
}
?>

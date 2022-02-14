<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'JSON';
	}

	public function buildLoadConfig()
	{
		$method = new Method('loadConfig', ['private', 'static']);
		$method->setBody($this->buildLoadConfigMethod());

		return $method->toString();
	}

	public function checkInput()
	{
		@json_decode($this->rawInput());
		$le = json_last_error();

		if ($le !== JSON_ERROR_NONE)
		{
			throw new \Exception(self::FQN.' - unable to proceed due to invalid JSON-input (JSON ERROR CODE '.$le.') in file "'.$this->for_file.'"');
		}
	}
}
?>

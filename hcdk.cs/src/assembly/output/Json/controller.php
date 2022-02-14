<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	private $output = null;

	public function getType()
	{
		return 'JSON';
	}

	public function build__toString()
	{
		if(!self::isJSON($this->rawInput()))
		{
			throw new \RuntimeException('raw input of assembly output.json is no valid json string.');
		}

		$this->output = $this->processPlaceholders($this->escape($this->rawInput())); //escape double-quotes from json

		$method = new Method('__toString', ['public']);
		$method->setBody($this->prependControlSymbols($this->toString()));

		return $method->toString();
	}

	private static function isJSON($possible_json_str)
	{
		@json_decode($possible_json_str);
		return (json_last_error() == JSON_ERROR_NONE);
	}
}
?>

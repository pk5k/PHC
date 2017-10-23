<?php
use \hcdk\raw\Method as Method;

trait Controller 
{
	private $output = null;

	public function getType()
	{
		return 'RAW';
	}

	public function build__toString()
	{
		$this->output = str_replace('"', '\\"', $this->rawInput()); //escape double-quotes
		$method = new Method('__toString', ['public']);
		$method->setBody($this->toString());

		return $method->toString();
	}
}
?>

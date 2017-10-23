<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'TEXT';
	}

	public function build__toString()
	{
		$output = str_replace('"', '\\"', $this->processPlaceholders($this->rawInput())); //escape double-quotes
		$method = new Method('__toString', ['public']);
		$method->setBody($this->template__toString($output));

		return $method->toString();
	}
}
?>

<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'CSS';
	}

	public function getIsAttachment()
	{
		return true;
	}

	public function buildStyle()
	{
		$method = new Method('style', ['public', 'static'], ['as_array' => false]);
		$method->setBody($this->tplBuildStyle());

		return $method->toString();
	}
}
?>

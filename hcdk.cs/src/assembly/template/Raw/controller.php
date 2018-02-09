<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'RAW';
	}

	public function buildTemplate($name, $data)
	{
		$output = str_replace('"', '\\"', $data['content']); //escape double-quotes
		$method = new Method($name, $data['mod']);
		$method->setBody($this->buildTemplateMethod($output));

		return $method->toString();
	}
}
?>

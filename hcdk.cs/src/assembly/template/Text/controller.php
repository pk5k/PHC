<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'TEXT';
	}

	public function buildTemplate($name, $data)
	{
		$output = str_replace('"', '\\"', $data['content']); //escape double-quotes
		$output = $this->processPlaceholders($output, true);
		$method = new Method($name, $data['mod']);
		$method->setBody($this->buildTemplateMethod($output));

		return $method->toString();
	}
}
?>

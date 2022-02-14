<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'CSS';
	}

	public function sourceIsAttachment()
	{
		return true;
	}

	public function buildClient()
	{
		$method = new Method('style', ['public', 'static'], ['as_array' => false]);
		$method->setBody($this->tplBuildStyle());

		return $method->toString();
	}

	public function getStaticMethods()
	{
		$methods = [];

		$methods['style'] = $this->buildClient();

		return $methods;
	}

	public function defaultInput() { return ''; }

	public function getTraits()
	{
		return ['Client' => '\\hcf\\core\\dryver\\Client', 'ClientCss' => '\\hcf\\core\\dryver\\Client\\Css'];
	}
}
?>

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

	public function styleMethod()
	{
		$method = new Method('style', ['public', 'static'], ['as_array' => false]);
		$method->setBody($this->tplBuildStyle());

		return $method->toString();
	}

	public function getStaticMethods()
	{
		$methods = [];

		$methods['style'] = $this->styleMethod();

		return $methods;
	}

	public function buildTemplate($name, $data)
	{
		return '';
	}
	
	public function defaultInput() { return ''; }

	public function getTraits()
	{
		return ['View' => '\\hcf\\core\\dryver\\View', 'ViewCss' => '\\hcf\\core\\dryver\\View\\Css'];
	}
}
?>

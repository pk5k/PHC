<?php
use \hcdk\raw\Method as Method;
use \hcdk\raw\Property as Property;

trait Controller
{
	protected abstract function buildGetLogAttachment();

	public function getName()
	{
		return 'LOG';
	}

	public function getConstructor()
	{
		return null;
	}

	public function getMethods()
	{
		return null;
	}

	public function getStaticMethods()
	{
		$gla = new Method('getLogAttachment', ['protected', 'static']);
		$gla->setBody($this->buildGetLogAttachment());

		$static_methods = [];
		$static_methods['getLogAttachment'] = $gla->toString();

		return $static_methods;
	}

	public function getProperties()
	{
		return null;
	}

	public function getStaticProperties()
	{
		return null;
	}

	public function getClassModifiers()
	{
		return null;
	}

	public function isAttachment()
	{
		return true;
	}

	public function isExecutable()
	{
		return false;
	}

	public function getAliases()
	{
		return null;
	}

	public function getTraits()
	{
		return ['Log' => '\\hcf\\core\\dryver\\Log'];
	}

	public function checkInput() {}
	public function defaultInput() { return ''; }
}
?>

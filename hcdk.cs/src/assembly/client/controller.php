<?php
trait Controller
{
	//public abstract function buildClient();
	//protected abstract function sourceIsAttachment();

	public function getName()
	{
		return 'CLIENT';
	}

	public function getConstructor() { return null; }

	public function getMethods() { return null; }

	public function getStaticMethods()
	{
		$methods = [];

		$methods['client'] = $this->buildClient();

		return $methods;
	}

	public function getProperties() { return null; }

	public function getStaticProperties()
	{
		return null;
	}

	public function getClassModifiers() { return null; }

	public function isAttachment()
	{
		return $this->sourceIsAttachment();
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
		return ['Client' => '\\hcf\\core\\dryver\\Client'];
	}

	public function checkInput() {}
	public function defaultInput() { return ''; }
}
?>

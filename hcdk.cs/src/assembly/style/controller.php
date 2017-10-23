<?php
trait Controller
{
	public abstract function buildStyle();
	public abstract function getIsAttachment();

	public function isAttachment()
	{
		return $this->getIsAttachment();
	}

	public function isExecutable()
	{
		return false;
	}

	public function getName()
	{
		return 'STYLE';
	}

	public function getClassModifiers()
	{
		return null;
	}

	public function getConstructor()
	{
		return null;
	}

	public function getMethods()
	{
		// Style-channels do not have a non-static method
		return null;
	}

	public function getStaticMethods()
	{
		$methods = [];
		$methods['style'] = $this->buildStyle();

		return $methods;
	}

	public function getProperties()
	{
		// Style-channels do not use properties
		return null;
	}

	public function getStaticProperties()
	{
		// dito
		return null;
	}

	public function getAliases()
	{
		return null;
	}

	public function getTraits()
	{
		return ['Style' => '\\hcf\\core\\dryver\\Style'];
	}

	public function checkInput() {}
	public function defaultInput() { return ''; }
}
?>

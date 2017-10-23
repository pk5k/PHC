<?php
trait Controller
{
	protected abstract function getControllerTrait();
	protected abstract function getConstructorContents();
	protected abstract function getControllerMethods();
	protected abstract function getStaticControllerMethods();

	public function getName()
	{
		return 'CONTROLLER';
	}

	public function getConstructor()
	{
		return $this->getConstructorContents();
	}

	public function getMethods()
	{
		return $this->getControllerMethods();
	}

	public function getStaticMethods()
	{
		return $this->getStaticControllerMethods();
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

	public function getAliases()
	{
		return null;
	}

	public function getTraits()
	{
		return $this->getControllerTrait();
	}
}
?>

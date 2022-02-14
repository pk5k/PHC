<?php
trait Controller
{
	protected abstract function getModelTrait();
	protected abstract function getConstructorContents();
	protected abstract function getModelMethods();
	protected abstract function getStaticModelMethods();

	public function getName()
	{
		return 'MODEL';
	}

	public function getConstructor()
	{
		return $this->getConstructorContents();
	}

	public function getMethods()
	{
		return $this->getModelMethods();
	}

	public function getStaticMethods()
	{
		return $this->getStaticModelMethods();
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
		return $this->getModelTrait();
	}
}
?>

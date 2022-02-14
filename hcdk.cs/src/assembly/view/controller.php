<?php
trait Controller
{
	protected abstract function build__toString();

	public function getName()
	{
		return 'VIEW';
	}

	protected function escape($str)
	{
		// escape double quotes, to don't mess up the __toString method
		$escaped = str_replace(['"', '$'], ['\\"', '\\$'], $str);

		return $escaped;
	}

	public function getConstructor() { return null; }

	public function getMethods()
	{
		$methods = [];

		$methods['__toString'] 	= $this->build__toString();

		return $methods;
	}

	public function getStaticMethods() { return null; }

	public function getProperties() { return null; }

	public function getStaticProperties() { return null; }

	public function getClassModifiers() { return null; }

	public function isAttachment()	{ return false; }

	public function isExecutable() { return false; }

	public function getAliases()
	{
		return null;
	}

	public function getTraits()
	{
		return ['View' => '\\hcf\\core\\dryver\\View'];
	}

	public function checkInput() {}
}
?>

<?php
trait Controller
{
	private $name = 'unnamedProperty';
	private $modifiers = [];
	private $value = 'null';

	public function onConstruct($name, $modifiers = null)
	{
		$this->setName($name);
		$this->setModifiers($modifiers);
	}

	public function setName($name)
	{
		if(!is_string($name))
		{
			throw new \Exception('Given property name is not a valid string');
		}

		$this->name = $name;
	}

	public function getName()
	{
		return $this->name;
	}

	public function setModifiers($modifiers)
	{
		if(!is_array($modifiers) || !count($modifiers))
		{
			throw new \Exception('Given modifiers array is invalid');
		}

		$this->modifiers = $modifiers;
	}

	public function getModifiers()
	{
		return $this->modifiers;
	}

	public function setValue($value)
	{
		if(isset($value))
		{
			$this->value = $value;
		}
		else
		{
			$this->value = 'null';
		}
	}

	public function getValue()
	{
		return $this->value;
	}

	private function makeModifierString()
	{
		if(!count($this->modifiers))
		{
			return 'private';
		}

		$mod_str = '';

		foreach($this->modifiers as $value)
		{
			$mod_str .= ' '.$value;
		}

		return $mod_str;
	}
}
?>

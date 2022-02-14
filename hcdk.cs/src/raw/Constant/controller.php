<?php
trait Controller
{
	private $name = 'UNNAMED_CONSTANT';
	private $value = 0;

	public function onConstruct($name)
	{
		$this->setName($name);
	}

	public function setName($name)
	{
		if (!is_string($name))
		{
			throw new \Exception('Given name for constant is not a string');
		}

		$this->name = $name;
	}

	public function getName()
	{
		return $this->name;
	}

	public function setValue($value = null)
	{
		if(isset($value))
		{
			if (!is_numeric($value) && !is_string($value))
			{
				throw new \Exception(self::FQN.' - Given value for constant "'.$this->name.'" is not a string nor a numeric and therefore can\'t be used as constant');
			}

			if (!is_numeric($value) && is_string($value))
			{
				if (substr($value, 0, 1) !== '\'')
				{
					$value = '\''.$value.'\'';
				}
				else if (substr($value, 0, 1) == '"')
				{
					$value = str_replace('"', '\'', $value);
				}
			}

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
}
?>

<?php
use \hcf\core\Utils as Utils;

trait Controller
{
	private $name = 'unnamedMethod';
	private $modifiers = [];
	private $arguments = [];
	private $body = null;

	public function onConstruct($name, $modifiers = [], $arguments = [])
	{
		$this->setName($name);
		$this->setModifiers($modifiers);
		$this->setArguments($arguments);
	}

	public function setName($name)
	{
		if(!is_string($name))
		{
			throw new \Exception('Given method name is not a valid string');
		}

		$this->name = $name;
	}

	public function getName()
	{
		return $this->name;
	}

	public function setModifiers($modifiers)
	{
		if (!is_array($modifiers) || !count($modifiers))
		{
			throw new \Exception('Given modifiers array is invalid');
		}

		$this->modifiers = $modifiers;
	}

	public function getModifiers()
	{
		return $this->modifiers;
	}

	public function setArguments($arguments)
	{
		if(is_null($arguments)) 
		{
            $this->arguments = [];
        } 
        else if (!is_array($arguments)) 
        {
            throw new \Exception('Given arguments array is invalid');
        }

		$this->arguments = $arguments;
	}

	public function getArguments()
	{
		return $this->modifiers;
	}

	public function setBody($body)
	{
		if(!is_string($body) && !in_array('abstract', $this->modifiers)) 
		{
            throw new \Exception('Given method body is not a valid string and abstract-modifier is not set');
        }

		$this->body = $body;
	}

	public function getBody()
	{
		return $this->body;
	}

	private function makeBodyString()
	{
		if(in_array('abstract', $this->modifiers))
		{
			// abstract methods cannot have a body
			return ';';
		}

		return '{'.Utils::newLine().$this->body.Utils::newLine().'}';
	}

	private function makeModifierString()
	{
		if(!count($this->modifiers))
		{
			return 'public';
		}

		$mod_str = '';

		foreach($this->modifiers as $value)
		{
			$mod_str .= ' '.$value;
		}

		return $mod_str;
	}

	private function makeArgumentString()
	{
		if(!count($this->arguments))
		{
			return '';
		}

		$arg_str = '';

		foreach($this->arguments as $name => $default)
		{
			$arg_str .= '$'.$name;

			if(isset($default))
			{
				$arg_str .= ' = '.$default;
			}

			$arg_str .= ',';
		}

		$arg_str = trim($arg_str, ',');//cut off trailing ,

		return $arg_str;
	}
}
?>

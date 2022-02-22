<?php
use \hcdk\raw\Method;

trait Controller
{
	private $constructor_delegated = false;

	public function getType()
	{
		return 'PHP';
	}

	public function isAttachment()
	{
		return false;
	}

	public function isExecutable()
	{
		return true;
	}

	protected function getModelMethods()
	{
		return null;
	}

	protected function getStaticModelMethods()
	{
		return null;
	}

	public function defaultInput()
	{
		return trim($this->defaultInputTemplate());
	}

	private function namedConstructor()
	{
		return str_replace('.', '', $this->forHypercell()->getName()->long).'_'.self::CONSTRUCTOR.'_Model';
	}

	public function checkInput()
	{
		// override constructor to absolute name (base-implicit and constructor-delegation need this to work)
		if (!$this->constructor_delegated)
		{
			$this->raw_input = str_replace(self::CONSTRUCTOR, $this->namedConstructor(), $this->rawInput());
			$this->constructor_delegated = true;
		}

		$raw_input = $this->rawInput();

		// rawInput must contain a trait named Model
		if (preg_match('/(?:[TtRrAaIiTtSs]*)\s*[M|m]odel/', $raw_input) === false)
		{
			throw new \Exception(self::FQN.' - unable to find trait "Model" inside '.$this->fileInfo()->getPathInfo());
		}

		// rawInput must NOT contain a __construct method -> use onConstruct instead
		if (preg_match('/(?:\s+__construct\s*\(.*\))/i', $raw_input) !== 0)
		{
			throw new \Exception(self::FQN.' - don\'t use __construct inside model.php assemblies - use '.self::CONSTRUCTOR.' instead - in '.$this->fileInfo()->getPathInfo());
		}
		
		$raw_input = trim($raw_input);
		$lines = explode("\n", $raw_input);
		$expect_open = array_shift($lines);// first line
		$expect_close = array_pop($lines);// last line

		// a php start- and end-tag must exist
		if (strpos($expect_open, '<?') === false || strpos($expect_close, '?>') === false)
		{
			throw new \Exception(self::FQN.' - missing php-opening- and/or closing-tag in '.$this->fileInfo()->getPathInfo());
		}
	}

	protected function getModelTrait()
	{
		// executables will be embedded using the HCFQN as namespace.
		// the trait reference below will be used at the top inside the HC and requires it's own name + an offset as
		// additional namespace
		$hc_name = $this->fileInfo()->getPathInfo()->getBasename();

		return ['Model' => $hc_name.'\\__EO__\\Model'];// EO = ExecutableOffset
	}

	protected function getConstructorContents()
	{
		return [3 => $this->constructorDelegation($this->namedConstructor())];// use same index as controller.php's constructor to throw an exception if two assemblies want to add an php-constructor
	}
}
?>

<?php
use \hcf\core\Utils as Utils;

trait Controller
{
	private $parent = null;

	protected function implicitConstructor()
	{
		$split = explode(' ', $this->rawInput());
		$implicit = (isset($split[1]) && trim($split[1]) == 'implicit') ? true : false;

		return $implicit;
	}

	protected function getBaseClass()
	{
		$split = explode(' ', $this->rawInput());
		$raw = trim($split[0]);

		if (strpos($raw, self::TOKEN_INHERIT) === 0)
		{
			//parent-0 -> HCFQN to parent directory, parent-1 -> HCFQN to parents parent-directory, parent-2 -> ...
			$padding = 0;// parent = parent-0

			if (strpos($raw, '-') !== false)
			{
				$psplit = explode('-', $raw);
				$padding = (int)$psplit[1];
			}

			if ($padding < 0)
			{
				throw new \Exception(self::FQN.' - padding cannot be lower than 0');
			}

			// current Hypercells name without 
			$hc = $this->forHypercell();

			if (is_null($hc))
			{
				throw new \Exception(self::FQN.' - cannot determine parent HCFQN. Target hypercell of this assembly is not set (hcdk.assembly->forHypercell() returned null).');
			}

			$raw = $hc->getName()->long;
			$parts = explode('.', $raw);

			for ($i = -1; $i < $padding; $i++) 
			{
				array_pop($parts);
			}

			$raw = implode('.', $parts);
			
			if ($raw === '')
			{
				throw new \Exception(self::FQN.' - inherit-'.$padding.' relative to '.$hc->getName()->long.' results in empty name - inherit padding is too high.');
			}
		}

		$this->parent = Utils::HCFQN2PHPFQN($raw, true);

		return $this->parent;
	}

	public function getType()
	{
		return '';
	}

	public function getName()
	{
		return 'BASE';
	}

	public function getConstructor()
	{
		if (!$this->implicitConstructor())
		{
			return null;
		}

		return [999 => 'call_user_func_array(\'parent::__construct\', func_get_args());'];// 999 to be sure, it's the last row in our constructor 
	}

	public function getMethods() { return null; }

	public function getStaticMethods() { return null; }
	public function getProperties() { return null; }
	public function getStaticProperties() { return null; }
	public function isAttachment() { return false; }
	public function isExecutable() { return false; }
	public function getClassModifiers()
	{
		return ['extends' => [$this->getBaseClass()]];
	}

	public function getAliases() { return null; }

	public function getTraits()
	{
		return ['Base' => '\\hcf\\core\\dryver\\Base'];
	}

	public function checkInput() {}
	public function defaultInput() { return 'parent implicit'; }
}
?>

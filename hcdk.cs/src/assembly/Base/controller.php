<?php
use \hcf\core\Utils as Utils;

trait Controller
{
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
		$php_fqn = Utils::HCFQN2PHPFQN($raw);

		if(substr($php_fqn, 1) !== '\\')
		{
			// prepend \ to refer to the global namespace
			$php_fqn = '\\'.$php_fqn;
		}

		return $php_fqn;
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
	public function defaultInput() { return ''; }
}
?>

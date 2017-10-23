<?php
use \hcf\core\Utils as Utils;
use \hcf\core\log\Internal as InternalLogger;
use \hcdk\data\Sectionizer as Sectionizer;

trait Controller
{
	public abstract function buildTemplate($name, $data);

	public function getName()
	{
		return 'TEMPLATE';
	}

	public function getConstructor() { return null; }

	public function getMethods()
	{
		$sections = Sectionizer::toArray($this->rawInput());
		$methods = [];

		foreach ($sections as $name => $data)
		{
			if ($data['content'] != $this->processPlaceholders($data['content']) && in_array('static', $data['mod']))
			{
				throw new \Exception(static::FQN.' - placeholders in static template "'.$name.'" detected. Using placeholders inside static templates is not possible.');
			}

			$methods[$name] = $this->buildTemplate($name, $data);
		}

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
		return ['Template' => '\\hcf\\core\\dryver\\Template'];
	}

	public function checkInput() {}
	public function defaultInput() { return ''; }
}
?>

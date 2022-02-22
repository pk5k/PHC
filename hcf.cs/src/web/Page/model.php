<?php
trait Model
{
	public function onConstruct($initial_attributes) // initial_attributes = Attributes of the pages html-element on initialisation time
	{
		static::checkPermissions();
	}

	public static function template()
	{
		return static::internalTemplate(static::FQN);
	}

	public static function elementName()
	{
		return static::genericElementName();
	}

	protected static function genericElementName()
	{
		return strtolower(str_replace('.', '-', static::FQN)); // override this method if you want a specific element name, otherwise the hcfqn with dots replaced by dashes will be used.
	}

	public static function checkPermissions()
	{
		return; // override this method and throw exceptions if page should not be load trough hcf.web.Router. Router will catch and reroute according to this exception (if configured)
	}

	protected static function fqn()
	{
		return static::FQN;
	}

	public static function wrappedElementName($autoload = true)
	{
		$en = static::genericElementName();
		$al = '';

		if (!$autoload)
		{
			$al = ' autoload="false"';
		}

		return '<'.$en.$al.'></'.$en.'>';
	}
}
?>
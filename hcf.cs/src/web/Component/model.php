<?php
trait Model
{
	public static function hasTemplate()
	{
		return !(is_null(static::elementName()) || static::elementName() == self::elementName());	
	}

	public static function wrappedClientController($component_context_id = null)
	{
		if (static::hasTemplate())
		{
			return self::wrappedClientControllerWithElement(static::FQN, static::script(), $component_context_id, static::elementName(), static::elementOptions());
		}
		else
		{
			return self::wrappedClientControllerOnly(static::FQN, static::script());
		}
	}

	public static function wrappedTemplate($component_context_id = null)
	{
		// Nur in der Methode die aufgerufen wird gilt static:: wirklich der referenzierten Klasse, in allen Aufrufen aus Templates usw. wird es zur Klasse in der die Methode definiert wurde

		if (static::hasTemplate())
		{
			if (is_null($component_context_id))
			{
				return static::wrapTemplate(static::FQN, static::escapedTemplate(), self::targetHead(), 'global');
			}
			else 
			{
				return static::wrapTemplate(static::FQN, static::escapedTemplate(), self::targetComponentContext($component_context_id), $component_context_id);
			}
		}
		else 
		{
			return '';
		}
	}

	protected static function escapedTemplate()
	{
		return str_replace("'", "\'", static::template());
	}

	protected static function removeLinebreaks($from)
	{
		return trim(str_replace("\n", '', $from));// linebreaks in javascript strings lead to invalid result. Newlines in HTML aren't neccessary anyway
	}
}
?>
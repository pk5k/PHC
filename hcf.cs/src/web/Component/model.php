<?php
trait Model
{
	// hcf.web.Components are hcf.web.Controllers with a view, represented by a html-tag in the browser which must be defined by the component itself
	public static function hasTemplate()
	{
		return !(is_null(static::elementName()) || static::elementName() == '' || static::FQN == self::FQN);	
	}

	public static function wrappedClientController()
	{
		if (static::hasTemplate())
		{
			return self::wrappedClientControllerWithElement(static::FQN, static::script(), static::elementName(), static::elementOptions());
		}
		else
		{
			return self::wrappedClientControllerOnly(static::FQN, static::script());
		}
	}

	public static function wrappedTemplate($render_context_id = null)
	{
		if (static::hasTemplate())
		{
			if (is_null($render_context_id))
			{
				return static::wrapTemplate(static::FQN, static::escapedTemplate(), self::targetHead(), 'global');
			}
			else 
			{
				return static::wrapTemplate(static::FQN, static::escapedTemplate(), self::targetRenderContext($render_context_id), $render_context_id);
			}
		}
		else 
		{
			return '';
		}
	}

	protected static function genericElementName()
	{
		return strtolower(str_replace('.', '-', static::FQN)); // override elementName template if you want a specific element name, otherwise the hcfqn in lowercase with dots replaced by dashes will be used.
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
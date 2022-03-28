<?php 
trait Controller
{
	protected static $_ARGS = null;//$_GET parameter

	public function onConstruct()
	{
		self::initUrlArgs();
	}
	
	public static function initUrlArgs($with = null)
	{
		if (is_null($with))
		{
			$with = $_GET;
		}

		if (isset($with) && is_array($with))
		{
			static::$_ARGS = $with;
		}
		else
		{
			static::$_ARGS = [];
		}
	}

	protected function argument($name, $value = null)
	{
		return static::urlArg($name, $value);
	}

	public static function urlArg($name, $value = null)
	{
		if (is_null(static::$_ARGS))
		{
			static::initUrlArgs();
		}

		if (!isset($value))
		{
			if (isset(static::$_ARGS[$name]))
			{
				return filter_var(static::$_ARGS[$name], FILTER_SANITIZE_STRING);
			}
			else
			{
				return null;
			}
		}
		else
		{
			static::$_ARGS[$name] = filter_var(static::$_ARGS[$name], FILTER_SANITIZE_STRING);
		}
	}
}
?>
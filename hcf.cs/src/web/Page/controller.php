<?php
trait Controller
{
	protected static $_ARGS = [];

	public function onConstruct($initial_attributes) // initial_attributes = Attributes of the pages html-element on initialisation time
	{
		self::initAttributes($initial_attributes);
		static::checkPermissions();
	}

	private static function initAttributes($attrs)
	{
		if (is_string($attrs) && $attrs != 'null')
		{
			$attrs = json_decode($attrs);
		}

		if (is_null($attrs) || $attrs == 'null')
		{
			return;
		}

		foreach ($attrs as $key => $val)
		{
			$key_filtered = filter_var($key, FILTER_SANITIZE_STRING);
			$val_filtered = filter_var($val, FILTER_SANITIZE_STRING);

			self::$_ARGS[$key_filtered] = $val_filtered;
		}
	}

	public static function attribute($key = null)
	{
		if (!isset($key))
		{
			return self::$_ARGS;
		}

		if (isset($key) && isset(self::$_ARGS[$key]))
		{
			return self::$_ARGS[$key];
		}
		else 
		{
			return null;
		}
	}
	
	public static function checkPermissions()
	{
		return; // override this method and throw exceptions if page should not be load trough hcf.web.Router. Router will catch and reroute according to this exception (if configured)
	}

}
?>
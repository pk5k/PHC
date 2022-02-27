<?php

trait Model
{
	public static function template()
	{
		return static::internalTemplate(static::FQN);
	}

	public static function title()
	{
		return '';// override this method to set the title of the target browser window if page gets load trough hcf.web.PageLoader
	}

	public static function wrappedElementName($autoload = false, $render_changes = false, $initial_attributes = null)
	{
		$en = static::genericElementName();
		$args = '';

		if ($autoload)
		{
			$args = ' autoload="true"';
		}

		if ($render_changes)
		{
			$args = ' render-changes="true"';
		}

		if (!is_null($initial_attributes) && $initial_attributes != '')
		{
			if (is_string($initial_attributes))
			{
				$initial_attributes = json_decode($initial_attributes);
			}

			if (is_object($initial_attributes))
			{
				foreach ($initial_attributes as $key => $val)
				{
					$args .= ' '.filter_var($key, FILTER_SANITIZE_STRING).'="'.filter_var($val, FILTER_SANITIZE_STRING).'"';
				}
			}
		}

		return '<'.$en.$args.'></'.$en.'>';
	}
}
?>
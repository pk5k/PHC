<?php
/**
 * PropertyProcessor
 * Translates a {{property:my_property}} placeholder to an executable line of php-script
 * NOTICE: You can reqeust both, static and non-static properties with this placeholder
 *
 * @category Placholder-processor-implementations
 * @package hcdk.placeholder.processor
 * @author Philipp Kopf
 */
trait Controller
{
	/**
	 * process
	 *
	 * @param $content - string - The name of the property, you want it's value from
	 * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
	 *
	 * @throws ReflectionException
	 * @return string - a line of php-script to get the requested property from inside the raw-merge
	 */
	public static function process($content, $between_double_quotes = true)
	{
		if ($between_double_quotes)
		{
			return '{$__CLASS__::_property(\''.$content.'\', $__CLASS__, $_this)}';
		}
		else
		{
			return '$__CLASS__::_property(\''.$content.'\', $__CLASS__, $_this)';
		}
	}
}
?>

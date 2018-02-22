<?php
trait Controller
{
	/**
	 * process
	 *
	 * @param $content - string - The index of the argument
	 * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
	 *
	 * @throws ReflectionException
	 * @return string - a line of php-script to get the requested argument inside a method
	 */
	public static function process($content, $between_double_quotes = true)
	{
		if ($between_double_quotes)
		{
			return '{$__CLASS__::_arg(\func_get_args(), '.$content.', $__CLASS__, $_this)}';
		}
		else
		{
			return '$__CLASS__::_arg(\func_get_args(), '.$content.', $__CLASS__, $_this)';
		}
	}
}
?>

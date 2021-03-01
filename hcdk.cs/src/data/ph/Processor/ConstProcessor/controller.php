<?php
/**
 * ConstProcessor
 * Translates a {{const:MY_CONSTANT}} placeholder to an executable line of php-script
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
	 * @param $content - string - The name of the constant inside your raw-merge component
	 * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
	 *
	 * @return string
	 */
	public static function process($content, $between_double_quotes = true, $mirror_map = null)
	{
		if ($between_double_quotes)
		{
			return '{$__CLASS__::_constant(\''.$content.'\', $__CLASS__, $_this)}';
		}
		else
		{
			return '$__CLASS__::_constant(\''.$content.'\', $__CLASS__, $_this)';
		}
	}
}
?>

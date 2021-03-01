<?php
/**
 * LocalProcessor
 * Translates a {{local:my_local}} placeholder to an executable line of php-script
 * NOTICE: Locales can only be created by xml-fragments like e.g. the key-/value-alias from rmb.xml.fragment.ForEach
 *
 * @category Placholder-processor-implementations
 * @package rmb.placeholder.processor
 * @author Philipp Kopf
 */
trait Controller
{
	/**
	 * process
	 *
	 * @param $content - string - The name of the requested locale
	 * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
	 *
	 * @return string - a line of php-script to get the requested locale from inside the raw-merge
	 */
	public static function process($content, $between_double_quotes = true, $mirror_map = null)
	{
		return '$'.$content;
	}
}
?>

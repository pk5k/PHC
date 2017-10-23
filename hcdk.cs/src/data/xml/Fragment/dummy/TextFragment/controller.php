<?php
/**
 * Text
 * This Fragment will replace itself with dummy text (lorem ipsum) with a given length
 *
 * @category XML Fragment
 * @package hcdk.xml.fragment.dummy
 * @author Philipp Kopf
 */
trait Controller
{
	private static $lorem_ipsum = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';

	public static function build($root, $file_scope)
	{
		$length = 1000;//1000 chars as default length

  		if(isset($root['length']))
		{
			$length = (int)$root['length'];
		}

		$output = self::$lorem_ipsum;

		while(strlen($output) < $length)
		{
			$output .= self::$lorem_ipsum;
		}

		if(strlen($output) > $length)
		{
			$output = substr($output, 0, $length);
		}

		$output = parent::FRGMNT_OUTPUT_START().$output.parent::FRGMNT_OUTPUT_END();

		return $output;
	}
}
?>

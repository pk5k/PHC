<?php
trait Controller
{
	// Returns colored string
	public static function apply($string, $foreground_color = null, $background_color = null) 
	{
		$colored_string = "";

		// Check if given foreground color found
		if(isset($foreground_color) && isset(self::config()->foreground[$foreground_color]))
		{
			$colored_string .= "\033[" . self::config()->foreground[$foreground_color] . "m";
		}
		
		// Check if given background color found
		if(isset($background_color) && isset(self::config()->background[$background_color]))
		{
			$colored_string .= "\033[" . self::config()->background[$background_color] . "m";
		}

		// Add string and end coloring
		$colored_string .=  $string . "\033[0m";

		return $colored_string;
	}

	// Returns all foreground color names
	public static function getForegroundColors() 
	{
		return array_keys(self::config()->foreground);
	}

	// Returns all background color names
	public static function getBackgroundColors() 
	{
		return array_keys(self::config()->background);
	}
 }
 
?>
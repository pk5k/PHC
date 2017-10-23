<?php
use \hcf\core\Utils;

trait Controller
{
	public static function toArray($input)
	{
		$c = self::config();

		$begin_tokens = $c->token->begin;
		$visibility_tokens = $c->token->visibility;

		$default_name = $c->default->name;
		$default_mods = $c->default->begin;

		$chars = str_split($input);
		$chars[] = ' ';// EOF padding, last character gets truncated
		$result = [];

		$state = self::STATE_FEED_SEC;
		$read_buffer = '';
		$section_ptr = $default_name;
		$mod_map = [];

		// dispatch default visibility string
		foreach (str_split($default_mods) as $i => $mod)
		{
			$ptr = (!$i) ? $begin_tokens : $visibility_tokens;
			$mod_map[$mod] = $ptr[$mod];
		}

		foreach ($chars as $index => $char)
		{
			$eof = ($index+1 == count($chars)); // $char = EOF padding
			switch ($state)
			{
				case self::STATE_FEED_MOD:
					$mod_map[$char] = $visibility_tokens[$char];// consume visibility flag
					$state = self::STATE_FEED_NAME;
					break;

				case self::STATE_FEED_NAME:
					if ($char !== self::CHAR_END_NAME)// ends name feed
					{
						$section_ptr .= $char;
					}
					else
					{
						$state = self::STATE_FEED_SEC;
					}
					break;

				case self::STATE_FEED_SEC:
					// if current char is a begin-token AND the following one is a visibility-token AND the next end-name-char appears before a line-break -> must be a new section
					if ($eof || (isset($begin_tokens[$char]) && isset($visibility_tokens[$chars[$index+1]]) && strpos($input, self::CHAR_END_NAME, $index) < strpos($input, PHP_EOL, $index)))
					{
						if (strlen($read_buffer))
						{
							// only write out, if buffer has content
							$result[$section_ptr] = ['content' => $read_buffer, 'mod' => $mod_map];// write out buffer and mods since the current section ends...
						}

						if (!$eof)
						{
							$read_buffer = '';// ...and clear
							$section_ptr = '';
							$mod_map = [];

							$state = self::STATE_FEED_MOD;
							$mod_map[$char] = $begin_tokens[$char];// consume static flag
						}
					}
					else
					{
						$read_buffer .= $char;
					}
					break;
			}
		}

		return $result;
	}
}
?>

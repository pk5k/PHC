<?php #HYPERCELL hcdk.data.Sectionizer - BUILD 22.01.28#61
namespace hcdk\data;
class Sectionizer {
    use \hcf\core\dryver\Config, \hcf\core\dryver\Constant, Sectionizer\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.Sectionizer';
    const NAME = 'Sectionizer';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcdkdataSectionizer_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataSectionizer_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    # BEGIN ASSEMBLY FRAME CONSTANT
    const CHAR_END_NAME = ':';
    const STATE_FEED_MOD = 1;
    const STATE_FEED_NAME = 2;
    const STATE_FEED_SEC = 4;
    private static $_constant_list = ['CHAR_END_NAME', 'STATE_FEED_MOD', 'STATE_FEED_NAME', 'STATE_FEED_SEC'];
    # END ASSEMBLY FRAME CONSTANT
    
    }
    namespace hcdk\data\Sectionizer\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils;
    trait Controller {
        public static function toArray($input) {
            $c = self::config();
            $begin_tokens = $c->token->begin;
            $visibility_tokens = $c->token->visibility;
            $default_name = $c->default->name;
            $default_mods = $c->default->begin;
            $chars = str_split($input);
            $chars[] = ' '; // EOF padding, last character gets truncated
            $result = [];
            $state = self::STATE_FEED_SEC;
            $read_buffer = '';
            $section_ptr = $default_name;
            $mod_map = [];
            // dispatch default visibility string
            foreach (str_split($default_mods) as $i => $mod) {
                $ptr = (!$i) ? $begin_tokens : $visibility_tokens;
                $mod_map[$mod] = $ptr[$mod];
            }
            foreach ($chars as $index => $char) {
                $eof = ($index + 1 == count($chars)); // $char = EOF padding
                switch ($state) {
                    case self::STATE_FEED_MOD:
                        $mod_map[$char] = $visibility_tokens[$char]; // consume visibility flag
                        $state = self::STATE_FEED_NAME;
                    break;
                    case self::STATE_FEED_NAME:
                        if ($char !== self::CHAR_END_NAME) // ends name feed
                        {
                            $section_ptr.= $char;
                        } else {
                            $state = self::STATE_FEED_SEC;
                        }
                    break;
                    case self::STATE_FEED_SEC:
                        if ($read_buffer == '' && $char == PHP_EOL) {
                            // if first character is a linebreak we're entering a new section coming from the self::CHAR_END_NAME character that is followed by a linebreak.
                            continue;
                        }
                        // if current char is a begin-token AND the following one is a visibility-token AND the next end-name-char appears before a line-break -> must be a new section
                        if ($eof || (isset($begin_tokens[$char]) && isset($visibility_tokens[$chars[$index + 1]]) && strpos($input, self::CHAR_END_NAME, $index) < strpos($input, PHP_EOL, $index))) {
                            if (strlen($read_buffer)) {
                                while (substr($read_buffer, -1, 1) == PHP_EOL) {
                                    // omit trailing linebreaks
                                    $read_buffer = substr($read_buffer, 0, -1);
                                }
                                // only write out if buffer has content
                                $result[$section_ptr] = ['content' => $read_buffer, 'mod' => $mod_map]; // write out buffer and mods since the current section ends...
                                
                            }
                            if (!$eof) {
                                $read_buffer = ''; // ...and clear
                                $section_ptr = '';
                                $mod_map = [];
                                $state = self::STATE_FEED_MOD;
                                $mod_map[$char] = $begin_tokens[$char]; // consume static flag
                                
                            }
                        } else {
                            $read_buffer.= $char;
                        }
                    break;
                }
            }
            return $result;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

; each key defines the beginning of a template-method while it's value determines if this method will be static or not
token.begin[#] = ""
token.begin[@] = "static"

; char followed by token.begin that determines the template-methods visibility
token.visibility[~] = "protected"
token.visibility[-] = "private"
token.visibility[+] = "public"

default.name = "stdTpl"; name of the "anonymous" root section if defined
default.begin = "#+"; prefix to determine the visibility and type of the anonymous root section (is public non-static)


END[CONFIG.INI]


?>



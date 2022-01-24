<?php #HYPERCELL hcf.cli.Colors - BUILD 21.06.27#44
namespace hcf\cli;
class Colors {
    use \hcf\core\dryver\Config, Colors\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.cli.Colors';
    const NAME = 'Colors';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfcliColors_onConstruct')) {
            call_user_func_array([$this, 'hcfcliColors_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    
    }
    namespace hcf\cli\Colors\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        // Returns colored string
        public static function apply($string, $foreground_color = null, $background_color = null) {
            $colored_string = "";
            // Check if given foreground color found
            if (isset($foreground_color) && isset(self::config()->foreground[$foreground_color])) {
                $colored_string.= "\033[" . self::config()->foreground[$foreground_color] . "m";
            }
            // Check if given background color found
            if (isset($background_color) && isset(self::config()->background[$background_color])) {
                $colored_string.= "\033[" . self::config()->background[$background_color] . "m";
            }
            // Add string and end coloring
            $colored_string.= $string . "\033[0m";
            return $colored_string;
        }
        // Returns all foreground color names
        public static function getForegroundColors() {
            return array_keys(self::config()->foreground);
        }
        // Returns all background color names
        public static function getBackgroundColors() {
            return array_keys(self::config()->background);
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

[foreground]
black = "0;30"
dark-gray = "1;30"
blue = "0;34"
light-blue = "1;34"
green = "0;32"
light-green = "1;32"
cyan = "0;36"
light-cyan = "1;36"
red = "0;31"
light-red = "1;31"
purple = "0;35"
light-purple = "1;35"
brown = "0;33"
yellow = "1;33"
light-gray = "0;37"
white = "1;37"

[background]
black = "40"
red = "41"
green = "42"
yellow = "43"
blue = "44"
magenta = "45"
cyan = "46"
light-gray = "47"


END[CONFIG.INI]


?>



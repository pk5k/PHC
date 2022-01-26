<?php #HYPERCELL hcf.web.Cookie - BUILD 22.01.24#34
namespace hcf\web;
class Cookie {
    use \hcf\core\dryver\Config, Cookie\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Cookie';
    const NAME = 'Cookie';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfwebCookie_onConstruct')) {
            call_user_func_array([$this, 'hcfwebCookie_onConstruct'], func_get_args());
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
    namespace hcf\web\Cookie\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        private static function mask($str, $mask, $undo = false) {
            $out = '';
            // double mask-string, until it's longer than $str
            while (strlen($mask) < strlen($str)) {
                $mask.= $mask;
            }
            if ($undo) {
                $str = base64_decode($str);
            }
            $str_arr = str_split($str);
            $mask_arr = str_split($mask);
            foreach ($str_arr as $strpos => $char) {
                if (!$undo) {
                    $out.= chr(ord($char) - ord($mask_arr[$strpos]));
                } else {
                    $out.= chr(ord($char) + ord($mask_arr[$strpos]));
                }
            }
            if (!$undo) {
                $out = base64_encode($out);
            }
            return $out;
        }
        public static function exists($cookie) {
            return (isset($_COOKIE[$cookie]));
        }
        public static function isEmpty($cookie) {
            return (empty($_COOKIE[$cookie]));
        }
        public static function get($cookie, $def_value = '') {
            $options = self::options($cookie);
            $value = $def_value;
            if (self::exists($cookie)) {
                $value = $_COOKIE[$cookie];
                if (isset($options['mask']) && $options['mask'] != '') {
                    $value = self::mask($value, $options['mask'], true);
                }
            }
            return $value;
        }
        public static function options($cookie) {
            if (!isset(self::config()->$cookie)) {
                throw new \Exception(self::FQN . ' - Cookie "' . $cookie . '" is not configured');
            }
            return self::config()->$cookie;
        }
        public static function set($cookie, $value) {
            $options = self::options($cookie);
            $default_options = ['expiry' => 31536000, //a year by default
            'path' => '/', 'domain' => '', 'secure' => (bool)false, 'httponly' => (bool)false, 'mask' => ''];
            $cookie_set = false;
            if (!headers_sent()) {
                foreach ($default_options as $option_key => $option_value) {
                    if (!isset($options[$option_key])) {
                        $options[$option_key] = $default_options[$option_key];
                    }
                }
                $options['domain'] = ((is_string($options['domain'])) ? $options['domain'] : '');
                $options['expiry'] = (int)((is_numeric($options['expiry']) ? ($options['expiry']+= time()) : strtotime($options['expiry'])));
                $value = (($options['mask'] == '') ? $value : self::mask($value, $options['mask'], false));
                $cookie_set = @setcookie($cookie, $value, $options['expiry'], $options['path'], $options['domain'], $options['secure'], $options['httponly']);
                if ($cookie_set) {
                    $_COOKIE[$cookie] = $value;
                }
            }
            return $cookie_set;
        }
        public static function remove($cookie) {
            $options = self::options($cookie);
            $default_options = ['path' => '/', 'domain' => '', 'secure' => (bool)false, 'httponly' => (bool)false, 'globalremove' => (bool)true];
            $return = false;
            if (!headers_sent()) {
                foreach ($default_options as $option_key => $option_value) {
                    if (!isset($options[$option_key])) {
                        $options[$option_key] = $default_options[$option_key];
                    }
                }
                $options['domain'] = ((is_string($options['domain'])) ? $options['domain'] : '');
                if ($options['globalremove']) {
                    unset($_COOKIE[$cookie]);
                }
                $return = @setcookie($cookie, '', (time() - 3600), $options['path'], $options['domain'], $options['secure'], $options['httponly']);
            }
            return $return;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

; example values for "expiry" config
; Session = 0
; Day = 86400
; Week = 604800
; Month = 2592000 - technically this is only 30 days.
; Year = 31536000

[example-cookie]
expiry = 31536000
path = "/"
domain = ""
secure = false
httponly = true
globalremove = true
mask = "1Another2String3To4Mask5The6String7On8The9Client0Side10"

END[CONFIG.INI]


?>



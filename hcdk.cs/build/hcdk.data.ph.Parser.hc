<?php #HYPERCELL hcdk.data.ph.Parser - BUILD 22.02.15#81
namespace hcdk\data\ph;
class Parser {
    use \hcf\core\dryver\Config, Parser\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Parser';
    const NAME = 'Parser';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcdkdataphParser_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataphParser_onConstruct'], func_get_args());
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
    namespace hcdk\data\ph\Parser\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\remote\Invoker as RemoteInvoker;
    /**
     * Parser
     * This class resolves and replaces placeholders inside a given string
     *
     * @category Placholder parser
     * @package hcf.core.placeholder [INTERNAL]
     * @author Philipp Kopf
     */
    trait Controller {
        /**
         * parse
         * This method is parsing an input-string. Every part of this string, which matches the regular-expression in
         * Parser::PP_REGEX, will be passed to it's associated placeholder-processor. Every match will be replaced through the processed
         * form of the placeholder.
         *
         * @param $string - string - the input-string which should be parsed
         * @param $between_double_quotes - boolean - Flag which determinates, if the returned strings target is a double quoted string ( = true, it must be evaluated by php on runtime) or not ( = false, no evaluation needed by php).
         *
         * @return string - the processed form of the input string.
         * E.g. Input = "hi my name is {{property:name}}" Output = "hi my name is {$this->OUTPUT__getProperty(name)}"
         */
        public static function parse($string, $between_double_quotes = true) {
            $matches = self::match($string);
            $avoid_rec = false; // if processSingle can't resolve the given type to a processor-implementation, this flag must be set to true, to avoid an endless loop by parsing recursive
            foreach ($matches as $match) {
                if (count($match) < 3) {
                    // Skip, if this match doesn't contain all fields.
                    continue;
                }
                $full = $match[0];
                $type = $match[1];
                $value = $match[2];
                $parsed_ph = self::processSingle($type, $value, $between_double_quotes);
                if (!isset($parsed_ph)) {
                    // If null was returned, PP_DOMT is false and type could't have been resolved - we'll skip
                    $avoid_rec = true;
                    continue;
                }
                $string = str_replace($full, $parsed_ph, $string);
            }
            if (self::config()->parser->recursive && !$avoid_rec && self::matchCount($string) > 0) {
                // if the parsed input-string contains new placeholders after parsing, parse it again.
                $string = self::parse($string);
            }
            return $string;
        }
        /**
         * match
         * Executes the Parser::PP_REGEX regular-expression on a given string
         *
         * @param $in_string - string - The input-string which should be analyzed
         *
         * @return array - Associative array of string-parts which matched to Parser::PP_REGEX
         */
        private static function match($in_string) {
            $matches = [];
            preg_match_all(self::config()->parser->regex, $in_string, $matches, PREG_SET_ORDER);
            return $matches;
        }
        /**
         * matchCount
         * Executes the Parser::PP_REGEX regular-expression on a given string
         *
         * @param $in_string - string - The input-string which should be analyzed
         *
         * @return int - The count of matches, found inside the input-string
         */
        private static function matchCount($in_string) {
            $count = preg_match_all(self::config()->parser->regex, $in_string);
            if (!is_numeric($count)) {
                // if null or false was returned
                $count = 0;
            }
            return $count;
        }
        /**
         * processSingle
         * Tries to resolve a given placeholder-type to a placeholder-processor-implementation and calls the process-method of the placeholder-processor
         *
         * @param $type - string - The type of the placeholder (method, property, session or local)
         * @param $value - string - The value of the placeholder; what kind of value it represents, depends on it's type
         * @param $between_double_quotes - boolean - Flag which determinates, if the returned strings target is a double quoted string (true, it must be evaluated by php on runtime) or not (false, no evaluation needed by php).
         *
         * @throws PlaceholderException
         * @return string - the processed placeholder
         */
        public static function processSingle($type, $value, $between_double_quotes) {
            $type = ucfirst($type);
            $package = self::config()->placeholder->package;
            $suffix = self::config()->placeholder->suffix;
            if (substr($package, -1) !== '.') {
                $package.= '.';
            }
            $type_class = $package . $type . $suffix;
            try {
                RemoteInvoker::implicitConstructor(false);
                $ri = new RemoteInvoker($type_class);
                $type_class = $ri->getInstance();
                self::validateProcessor($type_class);
            }
            catch(\Exception$e) {
                if (self::config()->parser->DOMT) {
                    throw new \PlaceholderException('Placeholder-processor "' . $type . '" cannot be load due following exception: ' . $e->getMessage());
                }
                return null;
            }
            list($value, $mirror_map) = self::dispatchMirrorMap($value);
            $parsed = $type_class::process($value, $between_double_quotes, $mirror_map);
            return $parsed;
        }
        private static function splitOfMirrorMap($content) {
            $content = trim($content);
            if (strpos($content, '|') === false) {
                return [$content, null];
            }
            $new_content = null;
            $mmap = null;
            $feed = '';
            $brackets_open = 0;
            $quotes_open = 0;
            for ($i = 0;$i < strlen($content);$i++) {
                $c = $content[$i];
                switch ($c) {
                    case "'":
                        $quotes_open = 1 - $quotes_open; // only one quote-level deep allowed, no escaping possible
                        $feed.= $c;
                    break;
                    case '(':
                        $brackets_open++;
                        $feed.= $c;
                    break;
                    case ')':
                        $brackets_open--;
                        $feed.= $c;
                    break;
                    case '|':
                        if ($brackets_open == 0 && $quotes_open == 0) {
                            if (!is_null($new_content)) {
                                throw new \Exception(self::FQN . ' - only one mirror-map ( | symbol) allowed per placeholder. Found in ' . $content);
                            }
                            if ($feed == '') {
                                throw new \Exception(self::FQN . ' - mirror-map cannot be used without preceeding content in ' . $content);
                            }
                            $new_content = $feed;
                            $feed = '';
                            break;
                        }
                        // else: fall trough
                        
                    default:
                        $feed.= $c;
                }
            }
            if ($quotes_open != 0) {
                throw new \Exception(self::FQN . ' - unexpected end of expression. Missing single-quote in ' . $content);
            }
            if ($brackets_open != 0) {
                throw new \Exception(self::FQN . ' - unexpected end of expression. Missing parantheses in ' . $content);
            }
            if (is_null($new_content)) {
                // no mirror-map was given
                $new_content = $feed;
            } else {
                $mmap = $feed;
            }
            if ($new_content == '') {
                throw new \Exception(self::FQN . ' - missing content in ' . $content);
            }
            return [$new_content, $mmap];
        }
        public static function detectArgumentType($for) {
            $type = null;
            $val = null;
            $for = trim($for);
            if (substr($for, 0, 1) == "'" && substr($for, -1, 1) == "'") {
                // raw string value
                $type = 'raw';
                $val = $for;
            } else if (strpos($for, ':') === false) {
                // NULL and true/false possible
                $fl = strtolower($for);
                if ($fl == 'null' || $fl == 'true' || $fl == 'false') {
                    // NOTICE: null is problematic since methods like _arg or _property will throw an exception if the value is null -> maybe correct that
                    $type = 'raw';
                    $val = $for;
                }
                // autocast args and property references
                else if (is_numeric($for)) {
                    $type = 'arg';
                    $val = $for;
                } else {
                    $type = 'property';
                    $val = $for;
                }
                // for locales, constant, etc. use expilcit placeholder type as cast -> placeholdertype:content
                
            } else {
                $split = explode(':', $for);
                if (count($split) != 2) {
                    throw new \Exception(self::FQN . ' - invalid amount of colons, only one allowed in ' . $for);
                }
                $type = $split[0];
                $val = $split[1];
            }
            return [$type, $val];
        }
        private static function dispatchMirrorMap($content) {
            list($content, $mmap) = self::splitOfMirrorMap($content);
            $mirror_map = [];
            if ($mmap != '') {
                $pass_args_indexes = explode(',', $mmap);
                foreach ($pass_args_indexes as $arg_index) {
                    list($type, $val) = self::detectArgumentType($arg_index);
                    if ($type == 'raw') {
                        $mirror_map[] = $val; // currently no placeholder-evaluation possible in static-strings (needs proper parser to detect placeholder nesting levels)
                        
                    } else {
                        $mirror_map[] = self::processSingle($type, $val, false); // always false, parent-placeholder decides if it's between double quotes
                        
                    }
                }
            }
            return [$content, $mirror_map];
        }
        /**
         * validateProcessor
         * Validates, if a given class-name is a placeholder-processor
         *
         * @param $type_class - string - name of the class, which should be validated
         *
         * @throws PlaceholderException
         * @return void
         */
        private static function validateProcessor($type_class) {
            $implementers = class_parents($type_class);
            $base = Utils::HCFQN2PHPFQN(self::config()->placeholder->base);
            if ($implementers === false || (is_array($implementers) && !in_array($base, $implementers))) {
                throw new \PlaceholderException('Placholder "' . $type_class . '" is not a ' . self::config()->placeholder->base . ' generalisation.');
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__
BEGIN[CONFIG.INI]
[parser]
regex = "/{{((?:[0-9a-zA-Z_])*):((.)+?)}}/i"; Regex to match placeholders (must start with "value:" followed by everything until first }} 
DOMT = true; Die-On-Missing-Type - if true, a PlaceholderException will be thrown, if type cannot be resolved to a Placeholder-Generalisation, on false the PH will be skipped
recursive = false; re-run the parse method, until no placeholders can be found anymore. In case of nested placeholders, the regex will only match the inner-ph. After parsing this, the outter ph would be matched on a second run

[placeholder]
base = "hcdk.data.ph.Processor"; Name of the base processor Hypercell
package = "hcdk.data.ph.Processor."; hc-package name which HCs inside implement the placeholder-base
suffix = "Processor"; suffix, which will be append to the placeholders-type-name (e.g. ConstProcessor for {{const:MY_CONST}})
END[CONFIG.INI]

?>
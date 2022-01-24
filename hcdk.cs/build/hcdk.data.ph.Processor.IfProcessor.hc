<?php #HYPERCELL hcdk.data.ph.Processor.IfProcessor - BUILD 22.01.24#107
namespace hcdk\data\ph\Processor;
class IfProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, IfProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.IfProcessor';
    const NAME = 'IfProcessor';
    public function __construct() {
        if (method_exists($this, 'hcdkdataphProcessorIfProcessor_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataphProcessorIfProcessor_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\IfProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * MethodProcessor
     * Translates a {{method:myMethod}} placeholder to an executable line of php-script
     *
     * NOTICE: Method-placeholders can pass arguments by listing
     * the required arugments behind a pipe: {{method:name|arg:0,property:my_prop,local:variable}}
     * The argument cast (value before : of each argument) can be omittet in case of argument-indexes
     * (numeric-only value) or propertys (everything non-numeric will be interpreted as property reference if cast is missing)
     * The argument-casts are identical to the avaiable placeholder-names and will be resolved by them.
     *
     * NOTICE: You can request both, static and non-static methods with this placeholder.
     *
     * @category Placholder-processor-implementations
     * @package hcdk.placeholder.processor
     * @author Philipp Kopf
     */
    use \hcdk\data\ph\Parser as PlaceholderParser;
    trait Controller {
        /**
         * process
         *
         * @param $content - string - The name of the method that should be called (+ argument index pass list)
         * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
         *
         * @throws ReflectionException
         * @return string - a line of php-script to call the requested method from inside the raw-merge
         */
        public static function process($content, $between_double_quotes = true, $mirror_map = null) {
            // content = expression, must be wrapped in parantheses if | is used to distinguish between mirror-map
            // mirror-map = 0 = value for then, 1 (optional) value for else
            $then = null;
            $else = '""';
            if (isset($mirror_map)) {
                if (isset($mirror_map[0])) {
                    $then = $mirror_map[0];
                } else {
                    throw new \Exception(self::FQN . ' - missing value for "then" (first mirror-map entry) in ' . $content);
                }
                if (isset($mirror_map[1])) {
                    $else = $mirror_map[1];
                }
            }
            $expr = self::parseExpression($content);
            if ($between_double_quotes) {
                return '".(' . $expr . ' ? ' . $then . ' : ' . $else . ')."';
            } else {
                return '(' . $expr . ' ? ' . $then . ' : ' . $else . ')';
            }
        }
        private static function parseExpression($expr) {
            $feed = '';
            $data = []; // blocks splittet by control symbols below
            $cs = ['!', '=', '(', ')', '>', '<', '%', '&', ' '];
            $in_quotes = false;
            // split by control symbols - rest will be resolved to placeholders
            for ($i = 0;$i < strlen($expr);$i++) {
                $c = $expr[$i];
                if ($c == "'") {
                    $in_quotes = !$in_quotes;
                }
                if (in_array($c, $cs) && !$in_quotes) {
                    if ($feed != '') {
                        $data[] = $feed; // write out feed
                        $feed = ''; // start new feed
                        
                    }
                    $data[] = $c; // each symbol is it's own block
                    
                } else {
                    $feed.= $c;
                }
            }
            if ($in_quotes) {
                throw new \Exception(self::FQN . ' - missing closing single-quote in expression ' . $expr);
            }
            if (strlen($feed) > 0) {
                $data[] = $feed;
            }
            $expr = '';
            // resolve everything that is not a control-symbol like it were passed to the mirror-map
            foreach ($data as $block) {
                if (in_array($block, $cs)) {
                    $expr.= $block;
                    continue;
                }
                list($type, $val) = PlaceholderParser::detectArgumentType($block);
                if ($type == 'raw') {
                    $expr.= $val; // currently no placeholder-evaluation possible in static-strings (needs proper parser to detect placeholder nesting levels)
                    
                } else {
                    $expr.= PlaceholderParser::processSingle($type, $val, false); // always false, double quotes will be closed in main template
                    
                }
            }
            return $expr;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



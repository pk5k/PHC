<?php #HYPERCELL hcdk.data.ph.Processor.MethodProcessor - BUILD 21.02.24#68
namespace hcdk\data\ph\Processor;
class MethodProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, MethodProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.MethodProcessor';
    const NAME = 'MethodProcessor';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\MethodProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * MethodProcessor
     * Translates a {{method:myMethod}} placeholder to an executable line of php-script
     * NOTICE: Method-placeholders can pass it's parent method-call arguments by listing
     * the required arugment-indexes behind a hash: {{method:name#0,2,3}}
     * NOTICE: You can request both, static and non-static methods with this placeholder.
     *
     * @category Placholder-processor-implementations
     * @package hcdk.placeholder.processor
     * @author Philipp Kopf
     */
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
        public static function process($content, $between_double_quotes = true) {
            $content = self::cleanContent($content);
            if ($between_double_quotes) {
                return '{$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this, \func_get_args())}';
            } else {
                return '$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this, \func_get_args())';
            }
        }
        private static function cleanContent($content) {
            if (strpos($content, '#') !== false) {
                $split = explode('#', $content);
                if (!is_array($split) || count($split) != 2) {
                    throw new \Exception(self::FQN . ' - invalid methodname: ' . $content);
                }
                $content = trim($split[0]);
                $pass_args_indexes = explode(',', $split[1]);
                $cleaned = [];
                foreach ($pass_args_indexes as $arg_index) {
                    if (!is_numeric($arg_index)) {
                        throw new \Exception(self::FQN . ' - Argument index ' . $arg_index . ' for method ' . $content . ' is invalid (not numeric)');
                    }
                    $cleaned[] = trim($arg_index);
                }
                $content.= '#' . implode(',', $cleaned);
            }
            return $content;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



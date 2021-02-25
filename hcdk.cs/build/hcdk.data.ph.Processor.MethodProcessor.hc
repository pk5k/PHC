<?php #HYPERCELL hcdk.data.ph.Processor.MethodProcessor - BUILD 21.02.24#78
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
     *
     * NOTICE: Method-placeholders can pass it's parent method-call arguments by listing
     * the required arugment-indexes behind a hash: {{method:name#0,2,3}}
     * passing locale variables is possible by using their name: e.g. {{method:mymethod#local_var,another_locale}}
     * mising indexes and locales is possible -> {{method:myMethod#1,locale_1,0,another_locale}}
     *
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
            list($content, $passtrough_map) = self::processContent($content);
            if ($between_double_quotes) {
                return '{$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this' . $passtrough_map . ')}';
            } else {
                return '$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this' . $passtrough_map . ')';
            }
        }
        private static function processContent($content) {
            $pt_map = '';
            $content = trim($content);
            if (strpos($content, '#') !== false) {
                $split = explode('#', $content);
                if (!is_array($split) || count($split) != 2) {
                    throw new \Exception(self::FQN . ' - invalid methodname: ' . $content);
                }
                $content = trim($split[0]);
                $pass_args_indexes = explode(',', $split[1]);
                $mapped = [];
                foreach ($pass_args_indexes as $arg_index) {
                    $use_index = trim($arg_index);
                    if (is_numeric($use_index)) // numerics are argument-indexes
                    {
                        $mapped[] = '\func_get_arg(' . $use_index . ')';
                    } else {
                        $mapped[] = '$' . $use_index;
                    }
                }
                $content.= '#map';
                $pt_map = ', [' . implode(', ', $mapped) . ']';
            }
            return [$content, $pt_map];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.data.ph.Processor.MethodProcessor - BUILD 22.02.23#106
namespace hcdk\data\ph\Processor;
class MethodProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, MethodProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.MethodProcessor';
    const NAME = 'MethodProcessor';
    public function __construct() {
        if (method_exists($this, 'hcdkdataphProcessorMethodProcessor_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkdataphProcessorMethodProcessor_onConstruct_Controller'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\MethodProcessor\__EO__;
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
            list($content, $mirror_map) = self::processMirrorMap($content, $mirror_map);
            if ($between_double_quotes) {
                return '{$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this' . $mirror_map . ')}';
            } else {
                return '$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this' . $mirror_map . ')';
            }
        }
        public static function processMirrorMap($content, $mirror_map) {
            $mmap = '';
            $content = trim($content);
            if (!is_null($mirror_map) && is_array($mirror_map) && count($mirror_map) > 0) {
                $content.= '|map'; // required for downwards compatibility
                $mmap = ', [' . implode(', ', $mirror_map) . ']';
            }
            return [$content, $mmap];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
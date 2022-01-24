<?php #HYPERCELL hcdk.data.ph.Processor.DictProcessor - BUILD 22.01.24#96
namespace hcdk\data\ph\Processor;
class DictProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, DictProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.DictProcessor';
    const NAME = 'DictProcessor';
    public function __construct() {
        if (method_exists($this, 'hcdkdataphProcessorDictProcessor_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataphProcessorDictProcessor_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\DictProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * MethodProcessor
     * Translates a {{method:myMethod}} placeholder to an executable line of php-script
     *
     * NOTICE: Method-placeholders can pass it's parent method-call arguments by listing
     * the required arugment-indexes behind a pipe: {{method:name|0,2,3}}
     * passing locale variables is possible by using their name: e.g. {{method:mymethod|local_var,another_locale}}
     * mising indexes and locales is possible -> {{method:myMethod|1,locale_1,0,another_locale}}
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
            if (is_null($mirror_map)) {
                $mirror_map = [];
            }
            if ($between_double_quotes) {
                return '{$__CLASS__::_dict(\'' . $content . '\', [' . implode(',', $mirror_map) . '])}';
            } else {
                return '$__CLASS__::_dict(\'' . $content . '\', [' . implode(',', $mirror_map) . '])';
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



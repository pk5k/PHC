<?php #HYPERCELL hcdk.data.ph.Processor.ConstProcessor - BUILD 22.01.24#75
namespace hcdk\data\ph\Processor;
class ConstProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, ConstProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.ConstProcessor';
    const NAME = 'ConstProcessor';
    public function __construct() {
        if (method_exists($this, 'hcdkdataphProcessorConstProcessor_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataphProcessorConstProcessor_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\ConstProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * ConstProcessor
     * Translates a {{const:MY_CONSTANT}} placeholder to an executable line of php-script
     *
     * @category Placholder-processor-implementations
     * @package hcdk.placeholder.processor
     * @author Philipp Kopf
     */
    trait Controller {
        /**
         * process
         *
         * @param $content - string - The name of the constant inside your raw-merge component
         * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
         *
         * @return string
         */
        public static function process($content, $between_double_quotes = true, $mirror_map = null) {
            if ($between_double_quotes) {
                return '{$__CLASS__::_constant(\'' . $content . '\', $__CLASS__, $_this)}';
            } else {
                return '$__CLASS__::_constant(\'' . $content . '\', $__CLASS__, $_this)';
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



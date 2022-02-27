<?php #HYPERCELL hcdk.data.ph.Processor.PropertyProcessor - BUILD 22.02.23#83
namespace hcdk\data\ph\Processor;
class PropertyProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, PropertyProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.PropertyProcessor';
    const NAME = 'PropertyProcessor';
    public function __construct() {
        if (method_exists($this, 'hcdkdataphProcessorPropertyProcessor_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkdataphProcessorPropertyProcessor_onConstruct_Controller'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\PropertyProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * PropertyProcessor
     * Translates a {{property:my_property}} placeholder to an executable line of php-script
     * NOTICE: You can reqeust both, static and non-static properties with this placeholder
     *
     * @category Placholder-processor-implementations
     * @package hcdk.placeholder.processor
     * @author Philipp Kopf
     */
    trait Controller {
        /**
         * process
         *
         * @param $content - string - The name of the property, you want it's value from
         * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
         *
         * @throws ReflectionException
         * @return string - a line of php-script to get the requested property from inside the raw-merge
         */
        public static function process($content, $between_double_quotes = true, $mirror_map = null) {
            if ($between_double_quotes) {
                return '{$__CLASS__::_property(\'' . $content . '\', $__CLASS__, $_this)}';
            } else {
                return '$__CLASS__::_property(\'' . $content . '\', $__CLASS__, $_this)';
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
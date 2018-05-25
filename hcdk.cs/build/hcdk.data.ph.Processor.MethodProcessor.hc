<?php #HYPERCELL hcdk.data.ph.Processor.MethodProcessor - BUILD 18.02.22#57
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
 * NOTICE: Method-placeholders can't pass arguments to the methods. This is to keep out the
 * complexity of the output-channel.
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
     * @param $content - string - The name of the method which should be called
     * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
     *
     * @throws ReflectionException
     * @return string - a line of php-script to call the requested method from inside the raw-merge
     */
    public static function process($content, $between_double_quotes = true) {
        if ($between_double_quotes) {
            return '{$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this)}';
        } else {
            return '$__CLASS__::_call(\'' . $content . '\', $__CLASS__, $_this)';
        }
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



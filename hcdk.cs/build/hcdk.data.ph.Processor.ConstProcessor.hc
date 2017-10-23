<?php #HYPERCELL hcdk.data.ph.Processor.ConstProcessor - BUILD 17.10.11#53
namespace hcdk\data\ph\Processor;
class ConstProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, ConstProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.ConstProcessor';
    const NAME = 'ConstProcessor';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
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
    public static function process($content, $between_double_quotes = true) {
        if ($between_double_quotes) {
            return '{$this->_constant(\'' . $content . '\', __CLASS__)}';
        } else {
            return '$this->_constant(\'' . $content . '\', __CLASS__)';
        }
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



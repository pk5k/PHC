<?php #HYPERCELL hcdk.data.ph.Processor.ArgProcessor - BUILD 21.02.24#62
namespace hcdk\data\ph\Processor;
class ArgProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, ArgProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.ArgProcessor';
    const NAME = 'ArgProcessor';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\ArgProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        /**
         * process
         *
         * @param $content - string - The index of the argument
         * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
         *
         * @throws ReflectionException
         * @return string - a line of php-script to get the requested argument inside a method
         */
        public static function process($content, $between_double_quotes = true, $mirror_map = null) {
            if ($between_double_quotes) {
                return '{$__CLASS__::_arg($_func_args, ' . $content . ', $__CLASS__, $_this)}';
            } else {
                return '$__CLASS__::_arg($_func_args, ' . $content . ', $__CLASS__, $_this)';
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



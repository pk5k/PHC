<?php #HYPERCELL hcdk.data.ph.Processor.LocalProcessor - BUILD 18.06.15#59
namespace hcdk\data\ph\Processor;
class LocalProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, LocalProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.LocalProcessor';
    const NAME = 'LocalProcessor';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\LocalProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * LocalProcessor
     * Translates a {{local:my_local}} placeholder to an executable line of php-script
     * NOTICE: Locales can only be created by xml-fragments like e.g. the key-/value-alias from rmb.xml.fragment.ForEach
     *
     * @category Placholder-processor-implementations
     * @package rmb.placeholder.processor
     * @author Philipp Kopf
     */
    trait Controller {
        /**
         * process
         *
         * @param $content - string - The name of the requested locale
         * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
         *
         * @return string - a line of php-script to get the requested locale from inside the raw-merge
         */
        public static function process($content, $between_double_quotes = true, $mirror_map = null) {
            return '$' . $content;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



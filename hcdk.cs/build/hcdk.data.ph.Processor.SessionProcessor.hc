<?php #HYPERCELL hcdk.data.ph.Processor.SessionProcessor - BUILD 22.02.15#78
namespace hcdk\data\ph\Processor;
class SessionProcessor extends \hcdk\data\ph\Processor {
    use \hcf\core\dryver\Base, SessionProcessor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor.SessionProcessor';
    const NAME = 'SessionProcessor';
    public function __construct() {
        if (method_exists($this, 'hcdkdataphProcessorSessionProcessor_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataphProcessorSessionProcessor_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\ph\Processor\SessionProcessor\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * SessionProcessor
     * Translates a {{session:my_session_arr_key}} placeholder to an executable line of php-script
     * NOTICE: This is a direct access to the $_SESSION-array. You have to make sure, a session is
     * started and the key exists, before using this placeholder.
     *
     * @category Placholder-processor-implementations
     * @package rmb.placeholder.processor
     * @author Philipp Kopf
     */
    trait Controller {
        /**
         * process
         *
         * @param $content - string - The name of the key which should be returned from the $_SESSION-array
         * @param $between_double_quotes - boolean - if true, the return value will be optimized for evaluating inside a "double quoted string"
         *
         * @return string - a line of php-script to get the requested $_SESSION-array-key from inside the raw-merge
         */
        public static function process($content, $between_double_quotes = true, $mirror_map = null) {
            if ($between_double_quotes) {
                return '{$_SESSION[\'' . $content . '\']}';
            } else {
                return '$_SESSION[\'' . $content . '\']';
            }
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
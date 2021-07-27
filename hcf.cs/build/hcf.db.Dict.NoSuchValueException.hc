<?php #HYPERCELL hcf.db.Dict.NoSuchValueException - BUILD 21.07.04#120
namespace hcf\db\Dict;
class NoSuchValueException extends \Exception {
    use \hcf\core\dryver\Base, NoSuchValueException\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.db.Dict.NoSuchValueException';
    const NAME = 'NoSuchValueException';
    public function __construct() {
        if (method_exists($this, 'hcfdbDictNoSuchValueException_onConstruct')) {
            call_user_func_array([$this, 'hcfdbDictNoSuchValueException_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcf\db\Dict\NoSuchValueException\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        public $for_value = null;
        function hcfdbDictNoSuchValueException_onConstruct($for_value) {
            $this->message = 'Key for value "' . $for_value . '" does not exist.';
            $this->for_value = $for_value;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



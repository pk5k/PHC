<?php #HYPERCELL hcdk.assembly.log.Properties - BUILD 22.02.23#197
namespace hcdk\assembly\log;
class Properties extends \hcdk\assembly\log {
    use \hcf\core\dryver\Base, Properties\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.log.Properties';
    const NAME = 'Properties';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblylogProperties_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkassemblylogProperties_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    protected function buildGetLogAttachment() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$__CLASS__::_call('getName', $__CLASS__, $_this) }', '{$__CLASS__::_call('getType', $__CLASS__, $_this) }');";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\assembly\log\Properties\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        public function getType() {
            return 'PROPERTIES';
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcdk.assembly.log.Properties - BUILD 21.07.08#184
namespace hcdk\assembly\log;
class Properties extends \hcdk\assembly\log {
    use \hcf\core\dryver\Base, Properties\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.log.Properties';
    const NAME = 'Properties';
    public function __construct() {
        if (method_exists($this, 'hcdkassemblylogProperties_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblylogProperties_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildGetLogAttachment() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "
return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$__CLASS__::_call('getName', $__CLASS__, $_this) }', '{$__CLASS__::_call('getType', $__CLASS__, $_this) }');
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
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



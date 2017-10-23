<?php #HYPERCELL hcdk.assembly.log.Xml - BUILD 17.10.11#168
namespace hcdk\assembly\log;
class Xml extends \hcdk\assembly\log {
    use \hcf\core\dryver\Base, Xml\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.log.Xml';
    const NAME = 'Xml';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildGetLogAttachment() {
        $output = "
return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$this->_call('getName') }', '{$this->_call('getType') }');
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\log\Xml\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
trait Controller {
    public function getType() {
        return 'XML';
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



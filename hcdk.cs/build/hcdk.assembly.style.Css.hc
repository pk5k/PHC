<?php #HYPERCELL hcdk.assembly.style.Css - BUILD 18.02.22#172
namespace hcdk\assembly\style;
class Css extends \hcdk\assembly\style {
    use \hcf\core\dryver\Base, Css\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.style.Css';
    const NAME = 'Css';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function tplBuildStyle() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "
if(\$as_array)
{
	return self::makeStylesheetArray();
}

return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$__CLASS__::_call('getName', $__CLASS__, $_this) }', '{$__CLASS__::_call('getType', $__CLASS__, $_this) }');
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\style\Css\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
trait Controller {
    public function getType() {
        return 'CSS';
    }
    public function getIsAttachment() {
        return true;
    }
    public function buildStyle() {
        $method = new Method('style', ['public', 'static'], ['as_array' => false]);
        $method->setBody($this->tplBuildStyle());
        return $method->toString();
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



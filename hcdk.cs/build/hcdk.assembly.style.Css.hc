<?php #HYPERCELL hcdk.assembly.style.Css - BUILD 17.10.11#169
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
        $output = "
if(\$as_array)
{
	return self::makeStylesheetArray();
}

return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$this->_call('getName') }', '{$this->_call('getType') }');
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



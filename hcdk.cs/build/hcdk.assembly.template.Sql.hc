<?php #HYPERCELL hcdk.assembly.template.Sql - BUILD 18.02.22#179
namespace hcdk\assembly\template;
class Sql extends \hcdk\assembly\template {
    use \hcf\core\dryver\Base, Sql\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.template.Sql';
    const NAME = 'Sql';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildTemplateMethod() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "
\$sql = \"{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }\";

return \$sql;";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\template\Sql\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
trait Controller {
    public function getType() {
        return 'SQL';
    }
    public function buildTemplate($name, $data) {
        $output = str_replace('"', '\\"', $data['content']); //escape double-quotes
        $output = $this->processPlaceholders($output, true);
        $method = new Method($name, $data['mod']);
        $method->setBody($this->prependControlSymbols($this->buildTemplateMethod($output)));
        return $method->toString();
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



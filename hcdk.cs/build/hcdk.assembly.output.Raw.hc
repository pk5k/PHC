<?php #HYPERCELL hcdk.assembly.output.Raw - BUILD 17.10.11#167
namespace hcdk\assembly\output;
class Raw extends \hcdk\assembly\output {
    use \hcf\core\dryver\Base, Raw\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.output.Raw';
    const NAME = 'Raw';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $output = "\$output = \"{$this->_property('output') }\";
return \$output;";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
}
namespace hcdk\assembly\output\Raw\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
trait Controller {
    private $output = null;
    public function getType() {
        return 'RAW';
    }
    public function build__toString() {
        $this->output = str_replace('"', '\\"', $this->rawInput()); //escape double-quotes
        $method = new Method('__toString', ['public']);
        $method->setBody($this->toString());
        return $method->toString();
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.assembly.config.Ini - BUILD 17.10.11#170
namespace hcdk\assembly\config;
class Ini extends \hcdk\assembly\config {
    use \hcf\core\dryver\Base, Ini\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.config.Ini';
    const NAME = 'Ini';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildLoadConfigMethod() {
        $output = "
\$content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$this->_call('getName') }', '{$this->_call('getType') }');

\$parser = new \IniParser();
self::\$config = \$parser->process(\$content);
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\config\Ini\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
trait Controller {
    public function getType() {
        return 'INI';
    }
    public function buildLoadConfig() {
        $method = new Method('loadConfig', ['private', 'static']);
        $method->setBody($this->buildLoadConfigMethod());
        return $method->toString();
    }
    public function defaultInput() {
        return '';
    }
    public function checkInput() {
        $parser = new \IniParser();
        $parser->process($this->rawInput()); // throw Exception if input is invalid
        
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



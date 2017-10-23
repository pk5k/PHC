<?php #HYPERCELL hcdk.assembly.config.Json - BUILD 17.10.11#169
namespace hcdk\assembly\config;
class Json extends \hcdk\assembly\config {
    use \hcf\core\dryver\Base, Json\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.config.Json';
    const NAME = 'Json';
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
self::\$config = json_decode(\$content);

";
        return $output;
    }
    public function defaultInput() {
        $output = "
{}
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\config\Json\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
trait Controller {
    public function getType() {
        return 'JSON';
    }
    public function buildLoadConfig() {
        $method = new Method('loadConfig', ['private', 'static']);
        $method->setBody($this->buildLoadConfigMethod());
        return $method->toString();
    }
    public function checkInput() {
        @json_decode($this->rawInput());
        $le = json_last_error();
        if ($le !== JSON_ERROR_NONE) {
            throw new \Exception(self::FQN . ' - unable to proceed due to invalid JSON-input (JSON ERROR CODE ' . $le . ') in file "' . $this->for_file . '"');
        }
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.assembly.config.Json - BUILD 22.01.24#189
namespace hcdk\assembly\config;
class Json extends \hcdk\assembly\config {
    use \hcf\core\dryver\Base, Json\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.config.Json';
    const NAME = 'Json';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyconfigJson_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyconfigJson_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildLoadConfigMethod() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "
\$content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$__CLASS__::_call('getName', $__CLASS__, $_this) }', '{$__CLASS__::_call('getType', $__CLASS__, $_this) }');
self::\$config = json_decode(\$content);

";
        return $output;
    }
    public function defaultInput() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
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



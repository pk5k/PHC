<?php #HYPERCELL hcdk.assembly.config.Ini - BUILD 22.02.23#199
namespace hcdk\assembly\config;
class Ini extends \hcdk\assembly\config {
    use \hcf\core\dryver\Base, Ini\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.config.Ini';
    const NAME = 'Ini';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyconfigIni_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkassemblyconfigIni_onConstruct_Controller'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    protected function buildLoadConfigMethod() {
        $__CLASS__ = get_called_class();
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "\$content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, '{$__CLASS__::_call('getName', $__CLASS__, $_this) }', '{$__CLASS__::_call('getType', $__CLASS__, $_this) }');

\$parser = new \IniParser();
self::\$config = \$parser->process(\$content);";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
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
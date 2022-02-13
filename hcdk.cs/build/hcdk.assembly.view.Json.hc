<?php #HYPERCELL hcdk.assembly.view.Json - BUILD 22.02.13#191
namespace hcdk\assembly\view;
class Json extends \hcdk\assembly\view {
    use \hcf\core\dryver\Base, Json\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.view.Json';
    const NAME = 'Json';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyviewJson_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyviewJson_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "\$output = \"{$__CLASS__::_property('output', $__CLASS__, $_this) }\";
return \$output;";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
    }
    namespace hcdk\assembly\view\Json\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    trait Controller {
        private $output = null;
        public function getType() {
            return 'JSON';
        }
        public function build__toString() {
            if (!self::isJSON($this->rawInput())) {
                throw new \RuntimeException('raw input of assembly view.json is no valid json string.');
            }
            $this->output = $this->processPlaceholders($this->escape($this->rawInput())); //escape double-quotes from json
            $method = new Method('__toString', ['public']);
            $method->setBody($this->prependControlSymbols($this->toString()));
            return $method->toString();
        }
        private static function isJSON($possible_json_str) {
            @json_decode($possible_json_str);
            return (json_last_error() == JSON_ERROR_NONE);
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.assembly.output.Text - BUILD 22.01.24#190
namespace hcdk\assembly\output;
class Text extends \hcdk\assembly\output {
    use \hcf\core\dryver\Base, Text\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.output.Text';
    const NAME = 'Text';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyoutputText_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyoutputText_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function template__toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "\$output = \"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\";
return \$output;";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\assembly\output\Text\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    trait Controller {
        public function getType() {
            return 'TEXT';
        }
        public function build__toString() {
            $output = str_replace('"', '\\"', $this->processPlaceholders($this->rawInput())); //escape double-quotes
            $method = new Method('__toString', ['public']);
            $method->setBody($this->prependControlSymbols($this->template__toString($output)));
            return $method->toString();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.assembly.view.Text - BUILD 22.02.15#196
namespace hcdk\assembly\view;
class Text extends \hcdk\assembly\view {
    use \hcf\core\dryver\Base, Text\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.view.Text';
    const NAME = 'Text';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyviewText_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyviewText_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    protected function buildTemplateMethod() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "\$output = \"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\";
return \$output;";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\assembly\view\Text\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    trait Controller {
        public function getType() {
            return 'TEXT';
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
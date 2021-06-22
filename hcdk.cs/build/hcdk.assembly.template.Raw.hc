<?php #HYPERCELL hcdk.assembly.template.Raw - BUILD 18.06.15#177
namespace hcdk\assembly\template;
class Raw extends \hcdk\assembly\template {
    use \hcf\core\dryver\Base, Raw\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.template.Raw';
    const NAME = 'Raw';
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
        $_func_args = \func_get_args();
        $output = "
\$output = \"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\";
return \$output;";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\assembly\template\Raw\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    trait Controller {
        public function getType() {
            return 'RAW';
        }
        public function buildTemplate($name, $data) {
            $output = str_replace('"', '\\"', $data['content']); //escape double-quotes
            $method = new Method($name, $data['mod']);
            $method->setBody($this->buildTemplateMethod($output));
            return $method->toString();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.assembly.view.Sql - BUILD 22.02.15#201
namespace hcdk\assembly\view;
class Sql extends \hcdk\assembly\view {
    use \hcf\core\dryver\Base, Sql\__EO__\Controller, \hcf\core\dryver\View, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.view.Sql';
    const NAME = 'Sql';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyviewSql_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyviewSql_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME VIEW.TEXT
    protected function buildTemplateMethod() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "\$sql = \"{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }\";

return \$sql;";
        return $output;
    }
    # END ASSEMBLY FRAME VIEW.TEXT
    
    }
    namespace hcdk\assembly\view\Sql\__EO__;
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
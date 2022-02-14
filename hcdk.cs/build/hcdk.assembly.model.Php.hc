<?php #HYPERCELL hcdk.assembly.model.Php - BUILD 22.02.13#311
namespace hcdk\assembly\model;
class Php extends \hcdk\assembly\model {
    use \hcf\core\dryver\Base, \hcf\core\dryver\Constant, Php\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.model.Php';
    const NAME = 'Php';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblymodelPhp_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblymodelPhp_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONSTANT
    const CONSTRUCTOR = 'onConstruct';
    private static $_constant_list = ['CONSTRUCTOR'];
    # END ASSEMBLY FRAME CONSTANT
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function constructorDelegation() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "if (method_exists(\$this, '{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }'))
{
	call_user_func_array([\$this, '{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }'], func_get_args());
}";
        return $output;
    }
    public function defaultInputTemplate() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "<?php
trait Model
{

}
?>";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\assembly\model\Php\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method;
    trait Controller {
        private $constructor_delegated = false;
        public function getType() {
            return 'PHP';
        }
        public function isAttachment() {
            return false;
        }
        public function isExecutable() {
            return true;
        }
        protected function getModelMethods() {
            return null;
        }
        protected function getStaticModelMethods() {
            return null;
        }
        public function defaultInput() {
            return trim($this->defaultInputTemplate());
        }
        private function namedConstructor() {
            return str_replace('.', '', $this->forHypercell()->getName()->long) . '_' . self::CONSTRUCTOR;
        }
        public function checkInput() {
            // override constructor to absolute name (base-implicit and constructor-delegation need this to work)
            if (!$this->constructor_delegated) {
                $this->raw_input = str_replace(self::CONSTRUCTOR, $this->namedConstructor(), $this->rawInput());
                $this->constructor_delegated = true;
            }
            $raw_input = $this->rawInput();
            // rawInput must contain a trait named Model
            if (preg_match('/(?:[TtRrAaIiTtSs]*)\s*[M|m]odel/', $raw_input) === false) {
                throw new \Exception(self::FQN . ' - unable to find trait "Model" inside ' . $this->fileInfo()->getPathInfo());
            }
            // rawInput must NOT contain a __construct method -> use hcdkassemblymodelPhp_onConstruct instead
            if (preg_match('/(?:\s+__construct\s*\(.*\))/i', $raw_input) !== 0) {
                throw new \Exception(self::FQN . ' - don\'t use __construct inside model.php assemblies - use ' . self::CONSTRUCTOR . ' instead - in ' . $this->fileInfo()->getPathInfo());
            }
            $raw_input = trim($raw_input);
            $lines = explode("\n", $raw_input);
            $expect_open = array_shift($lines); // first line
            $expect_close = array_pop($lines); // last line
            // a php start- and end-tag must exist
            if (strpos($expect_open, '<?') === false || strpos($expect_close, '?>') === false) {
                throw new \Exception(self::FQN . ' - missing php-opening- and/or closing-tag in ' . $this->fileInfo()->getPathInfo());
            }
        }
        protected function getModelTrait() {
            // executables will be embedded using the HCFQN as namespace.
            // the trait reference below will be used at the top inside the HC and requires it's own name + an offset as
            // additional namespace
            $hc_name = $this->fileInfo()->getPathInfo()->getBasename();
            return ['Model' => $hc_name . '\\__EO__\\Model']; // EO = ExecutableOffset
            
        }
        protected function getConstructorContents() {
            return [3 => $this->constructorDelegation($this->namedConstructor()) ];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>

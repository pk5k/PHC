<?php #HYPERCELL hcf.core.remote.Invoker - BUILD 22.02.15#146
namespace hcf\core\remote;
class Invoker {
    use Invoker\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.core.remote.Invoker';
    const NAME = 'Invoker';
    public function __construct() {
        if (method_exists($this, 'hcfcoreremoteInvoker_onConstruct')) {
            call_user_func_array([$this, 'hcfcoreremoteInvoker_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcf\core\remote\Invoker\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\log\Internal as InternalLogger;
    /**
     * Invoker
     * This class reflects a given Hypercell and allows invoking it's methods
     *
     * @category Remote method invocation
     * @package hcf.core.remote
     * @author Philipp Kopf
     */
    trait Controller {
        private static $call__construct = true;
        protected $reflection_class = null;
        protected $reflected_instance = null;
        protected $php_fqn = null;
        protected $accessible_methods = null;
        /**
         * __construct
         * Sets up the instance, validates the given hcfqn and creates a ReflectionClass + a reflected instance
         * of the given Hypercell (without invoking it's constructor if set)
         *
         * @param $hcfqn - string - the full-qualified-name of the Hypercell you want to create an Invoker for
         * @param $constructor_arguments - array - if call__construct is true, these arguments will be passed to the constructor of the reflection-instance
         *
         * @throws RuntimeException
         */
        public function hcfcoreremoteInvoker_onConstruct($hcfqn, $constructor_arguments = null) {
            if (!Utils::isValidRMFQN($hcfqn)) {
                throw new \RuntimeException('Given value "' . $hcfqn . '" is not a valid Hypercell FQN - unable to proceed');
            }
            $this->php_fqn = Utils::HCFQN2PHPFQN($hcfqn);
            $this->reflection_class = new \ReflectionClass($this->php_fqn);
            if (self::$call__construct) {
                if (is_array($constructor_arguments)) {
                    $this->reflected_instance = $this->reflection_class->newInstanceArgs($constructor_arguments);
                } else {
                    $this->reflected_instance = $this->reflection_class->newInstance();
                }
            } else if (!$this->reflection_class->isAbstract()) {
                $this->reflected_instance = $this->reflection_class->newInstanceWithoutConstructor();
            }
        }
        /**
         * accessibleMethods
         * Get a list of all accessible methods of the connected Hypercell
         *
         * @return array - associative array with the accessible methods, while key is the method-name and value an array of the arguments, required for this method
         */
        public function accessibleMethods($only_self_defined = false) {
            if (!isset($this->accessible_methods)) {
                $this->getAccessibleMethods($only_self_defined);
            }
            return $this->accessible_methods;
        }
        /**
         * implicitConstructor
         * Defines, if the Invoker should call the constructor of the reflection class while creating the reflection-instance
         * NOTICE: This change only takes effect on further Invoker-instances, already existing Invoker-instances will be ignored
         *
         * @param invoke - boolean - if true, the constructor will be called implicit; if false, the constructor won't be called
         *
         * @return void
         */
        public static function implicitConstructor($invoke = true) {
            self::$call__construct = $invoke;
        }
        /**
         * getAccessibleMethods
         * Internal function to get the accessible methods out of the reflected class
         *
         * @return void
         */
        protected function getAccessibleMethods($only_self_defined = false) {
            $this->accessible_methods = [];
            $reflection_methods = $this->reflection_class->getMethods(\ReflectionMethod::IS_PUBLIC);
            foreach ($reflection_methods as $reflection_method) {
                if ($only_self_defined && $reflection_method->getDeclaringClass()->name != $this->reflection_class->name) {
                    continue;
                }
                $name = $reflection_method->getName();
                $args = $reflection_method->getParameters();
                $this->accessible_methods[$name] = [];
                foreach ($args as $arg) {
                    $arg_name = $arg->getName();
                    $index = $arg->getPosition();
                    $optional = $arg->isOptional();
                    $default = null;
                    try {
                        $default = $arg->getDefaultValue();
                    }
                    catch(\ReflectionException$e) {
                        $default = null;
                    }
                    $this->accessible_methods[$name][$index] = ['name' => $arg_name, 'optional' => $optional, 'default' => $default];
                }
            }
        }
        /**
         * invoke
         * Invokes a given method of the reflected-instance
         *
         * @param $name - string - the name of the method, you want to invoke
         * @param args - array - arguments, which will be passed to the method, each array-position is a single argument
         *
         * @return mixed - the return value of the invoked method will be returned
         */
        public function invoke($name, $args = null) {
            $no_args = false;
            if (isset($args) && !is_array($args)) {
                // force args be an array
                $args = [$args];
            } else if (!isset($args)) {
                $no_args = true;
            }
            if (!isset($this->accessible_methods)) {
                $this->getAccessibleMethods();
            }
            if (!isset($this->accessible_methods[$name])) {
                throw new \RuntimeException('Cannot invoke method "' . $name . '" for class ' . $this->php_fqn . ' - method does not exist or is not accessible');
            }
            $method = $this->reflection_class->getMethod($name);
            $ref = null;
            if (!$method->isStatic()) {
                $ref = $this->reflected_instance;
            }
            if ($no_args) {
                return $method->invoke($ref);
            } else {
                return $method->invokeArgs($ref, $args);
            }
        }
        public function getInstance() {
            return $this->reflected_instance;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcdk.assembly - BUILD 22.01.24#240
namespace hcdk;
abstract class assembly {
    use assembly\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly';
    const NAME = 'assembly';
    public function __construct() {
        if (method_exists($this, 'hcdkassembly_onConstruct')) {
            call_user_func_array([$this, 'hcdkassembly_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.RAW
    static protected function controlSymbols() {
        $output = "\$__CLASS__ = __CLASS__;
\$_this = (isset(\$this)) ? \$this : null;
\$_func_args = \\func_get_args();";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.RAW
    
    }
    namespace hcdk\assembly\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\data\ph\Parser as PlaceholderParser;
    use \hcdk\raw\Hypercell;
    trait Controller {
        protected $raw_input = null;
        protected $for_file = null;
        protected $for_hypercell = null;
        protected $name = null;
        /**
         * __construct
         * Set up the channel instance for a given file and it's content
         *
         * @param $raw_input - string - the raw data out of the source file
         * @param $for_file - string - the filepath to the source, the $raw_input belongs to
         */
        public function hcdkassembly_onConstruct($raw_input, $for_file, Hypercell $for_hc) {
            $this->for_file = $for_file;
            $this->forHypercell($for_hc);
            if (strlen(trim($raw_input))) {
                $this->raw_input = $raw_input;
            } else {
                $this->raw_input = $this->defaultInput();
            }
            $this->checkInput();
        }
        /**
         * forHypercell
         * hcdk.raw.Hypercell instance of the
         *
         *
         * @return hcdk.raw.Hypercell instance if $for wasnt set
         */
        public function forHypercell(Hypercell $for = null) {
            if (!isset($for)) {
                return $this->for_hypercell;
            }
            $this->for_hypercell = $for;
        }
        /**
         * fileInfo
         * Wrapper method, to get a SplFileInfo object for the channel-source
         *
         *
         * @return new SplFileInfo object
         */
        public function fileInfo() {
            return new \SplFileInfo($this->for_file);
        }
        /**
         * rawInput
         * Wrapper method, to get the rawInput
         * This method is not really necessary, but maybe useful in later development
         *
         * @return string - the raw content of the channel-source
         */
        public function rawInput() {
            return $this->raw_input;
        }
        /**
         * getChecksum
         * Get the checksum of the channel-source raw-input, to decide, if this hypercell must be rebuild
         *
         * @return string - md5 checksum of the raw-input
         */
        public function getChecksum() {
            $ri = $this->rawInput();
            $ri = preg_replace("/\R/", "", $ri); // before creating the checksum, replace all Line-Breaks inside this raw-input to don't mark a file as modified if another OS is used
            return md5($ri);
        }
        /**
         * processPlaceholders
         * Processes the placeholders inside a given input
         *
         * @param $input - string - the string that should be processed
         *
         * @return string - the $input argument with replaced placeholders
         */
        protected function processPlaceholders($input) {
            $output = PlaceholderParser::parse($input);
            return $output;
        }
        /**
         * prependControlSymbols
         * Used for method-bodies, to allow static templates with placeholders.
         * The control-symbols are required in every method which allows placeholders
         *
         * @param $method_body - string - sourcecode of a method, that should be prepend with the control-symbols
         *
         * @return string - the $method_body with prepended control-symbols
         */
        protected function prependControlSymbols($method_body) {
            return self::controlSymbols() . $method_body;
        }
        /**
         * checkInput
         * Each assembly implementation can check it's raw-input trough this method.
         * If the input is detected as invalid, this method should throw an Exception (will be displayed at build-time and triggers the rollback of this build)
         *
         * @return void - returns nothing but throws an Exception to abort the build-process
         */
        public abstract function checkInput();
        /**
         * defaultInput
         * If the given raw-input is empty (no content inside the assembly-file) the returned value of this method will be used as new raw-input.
         * NOTE: Using hcdk.cli.Add and passing assemblies as arguments, these assemblies will be filled with their defaultInput while added.
         *
         * @return string - the default input
         */
        public abstract function defaultInput();
        /**
         * isAttachment
         * This method decides, if the assembly should be embedded into it's built hypercell
         * The attachment data will be inserted after the __halt_compiler(); php command
         *
         * @return boolean - if true, the assembly will be embedded as-is to the end of the hypercell.
         */
        public abstract function isAttachment();
        /**
         * isExecutable
         * Like an attachment, but embedded BEFORE the __halt_compiler(); php command, not accessible by INTERNAL__attachment and not overrideable
         * Executable attachments using the HCFQN as namespace + __EO__ (= ExecutableOffset; e.g. my.hypercell.Name@controller.php -> \my\hypercell\Name\__EO__\Controller)
         *
         * @return boolean - if true, the assembly will be embedded before the __halt_compiler(); command - and therefore executed by php.
         */
        public abstract function isExecutable();
        /**
         * getName
         * Get the name of the assembly, this instance belongs to
         *
         * @return string - which represents the name of the channel
         */
        public abstract function getName();
        /**
         * getType
         * Get the type of the assembly, this instance belongs to
         *
         * @return string - which represents the type of the source
         */
        public abstract function getType();
        /**
         * getClassModifiers
         * Implements and extends which will be append to the head of the hypercell-class
         *
         * @return array - associative, contains the implement- and extend-classes which will be append to the head of the hypercell-class
         */
        public abstract function getClassModifiers();
        /**
         * getConstructor
         * PHP-script, which will be append to the method-body of the hypercell-constructor
         *
         * @return array - an array with a single key-value pair (= list). Key is the number of the line (will be ksort'ed on build time); value are the rows for the constructor method
         */
        public abstract function getConstructor();
        /**
         * getMethods
         * Get the methods, this channel is adding to the hypercell
         *
         * @return array - associative, the key is the method-name inside the hypercell while the array-value contains the full method as string
         */
        public abstract function getMethods();
        /**
         * getStaticMethods
         * Get the static methods, this channel is adding to the hypercell
         *
         * @return array - associative, the key is the static-method-name inside the hypercell while the array-value contains the full method as string
         */
        public abstract function getStaticMethods();
        /**
         * getProperties
         * Get the properties, this channel is adding to the hypercell
         *
         * @return array - associative, the key is the property-name inside the hypercell while the array-value contains the default-value of the property
         */
        public abstract function getProperties();
        /**
         * getStaticProperties
         * Get the static-properties, this channel is adding to the hypercell
         *
         * @return array - associative, the key is the static-property-name inside the hypercell while the array-value contains the default-value of the property
         */
        public abstract function getStaticProperties();
        /**
         * getAliases
         * Get the required files for this channel
         *
         * @return array - one entry each alias
         */
        public abstract function getAliases();
        /**
         * getTraits
         * Get the required traits for this channel
         *
         * @return array - one entry each trait
         */
        public abstract function getTraits();
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



<?php #HYPERCELL hcdk.data.php.ClassParser - BUILD 22.01.24#176
namespace hcdk\data\php;
class ClassParser {
    use \hcf\core\dryver\Config, ClassParser\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.php.ClassParser';
    const NAME = 'ClassParser';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcdkdataphpClassParser_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataphpClassParser_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    
    }
    namespace hcdk\data\php\ClassParser\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * ClassParser
     * This class analyzes a PHP-file to gain information about the containing classes
     * NOTICE: The hcdk.php.ClassParser is NOT checking your PHP-syntax! If you're getting
     * malformed raw-merge outputs, don't forget to check the syntax of all your
     * PHP-sources which belong to this raw-merge
     *
     * @category Parser
     * @package hcdk.php
     * @author Hugo Wetterberg/Philipp Kopf
     * @link Original source: https://github.com/hugowetterberg/php-class-parser
     */
    trait Controller {
        private $aliases = array();
        private $classes = array();
        private $extends = array();
        private $implements = array();
        /**
         * __construct
         *
         * @throws ClassParserException
         */
        public function hcdkdataphpClassParser_onConstruct() {
            if (!extension_loaded('tokenizer')) {
                throw new \ClassParserException("Compile php with tokenizer extension. Use --enable-tokenizer or don't use --disable-all on configure.");
            }
            if (!defined('STATE_CLASS_HEAD')) {
                define('STATE_CLASS_HEAD', self::config()->state->CLASS_HEAD);
            }
            if (!defined('STATE_FUNCTION_HEAD')) {
                define('STATE_FUNCTION_HEAD', self::config()->state->FUNCTION_HEAD);
            }
        }
        /**
         * getClasses
         * Get all information about all classes, which were found inside the last parsed class-data
         *
         * @return array - information about the classes
         */
        public function getClasses() {
            return $this->classes;
        }
        /**
         * getAliases
         * Get all class aliases, defined on the top of the php-script with "use ... as ...;"
         *
         * @return array - class aliases, used inside this file
         */
        public function getAliases() {
            return $this->aliases;
        }
        /**
         * getClassesImplementing
         * Get all information about all classes, which implementing a given interface
         *
         * @param $interface - string - The name of the interface
         *
         * @return array - information about the classes, which are implementing the given interface
         */
        public function getClassesImplementing($interface) {
            $implementers = array();
            if (isset($this->implements[$interface])) {
                foreach ($this->implements[$interface] as $name) {
                    $implementers[$name] = $this->classes[$name];
                }
            }
            return $implementers;
        }
        /**
         * getClassesExtending
         * Get all information about all classes, which are a generalisation of a given class
         *
         * @param $class - string - The name of the class
         *
         * @return array - information about the classes, which are a generalisation of the given class
         */
        public function getClassesExtending($class) {
            $extenders = array();
            if (isset($this->extends[$class])) {
                foreach ($this->extends[$class] as $name) {
                    $extenders[$name] = $this->classes[$name];
                }
            }
            return $extenders;
        }
        /**
         * resolveMethodBodies
         * Get the contents of a method by an regular expression
         * NOTICE: This method must be executed at the end of the ClassParser::parse method to work properly
         *
         * @param $php_file_content - string - The content of the PHP-file, you want to resolve the method-bodies for
         *
         * @throws MethodResolveException
         * @return void
         */
        private function resolveMethodBodies($php_file_content) {
            foreach ($this->classes as $class_name => $class) {
                if (isset($class['functions'])) {
                    foreach ($class['functions'] as $method_name => $data) {
                        $modifiers = $data['modifiers'];
                        $args = $data['args'];
                        if (in_array('abstract', $modifiers) || in_array('ABSTRACT', $modifiers) || in_array('Abstract', $modifiers)) {
                            // don't resolve method bodies for abstract methods
                            $this->classes[$class_name]['functions'][$method_name]['body'] = null;
                            continue;
                        }
                        //((?:(?:private|public)\s*)+)[Ff]unction(?:\s*)aMethodWithArgs\(\s*\$arg0(?:.*)\s*\$arg1(?:.*)\)\s*\{//} (bracket fix)
                        $regex = '((?:(?:';
                        $regex.= implode('|', $modifiers);
                        $regex.= ')\s*)+)[Ff]unction(?:\s*)';
                        $regex.= $method_name;
                        $regex.= '\(';
                        foreach ($args as $name => $default) {
                            $regex.= '\s*\\$' . $name . '(?:.*)';
                        }
                        $regex.= '\)\s*\{'; // } bracket fix - do not remove this comment, otherwise hcdk.php.ClassParser will run into an endless loop at build time
                        $matches = [];
                        $match_count = preg_match_all('/' . $regex . '/im', $php_file_content, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE);
                        if ($match_count === false) {
                            throw new \MethodResolveException('Unable to resolve method-body for method "' . $method_name . '" in class "' . $class_name . '"');
                        }
                        if ($match_count != 1) {
                            throw new \MethodResolveException('Exactly 1 result was expected for preg_match "' . $regex . '" - got ' . $match_count . ' results.');
                        }
                        $begin_offset = $matches[0][0][1];
                        $begin_offset+= strlen($matches[0][0][0]) + 1;
                        $body_buffer = '';
                        $continue = true;
                        $depth = 1; //must be 1, because we start inside the {//} bracket fix
                        while ($continue) {
                            $next = substr($php_file_content, $begin_offset, 1);
                            $begin_offset++;
                            switch ($next) {
                                case '{':
                                    $depth++;
                                break;
                                case '}':
                                    $depth--;
                                break;
                            }
                            if ($depth > 0) {
                                $body_buffer.= $next;
                            } else {
                                $continue = false;
                            }
                        }
                        $this->classes[$class_name]['functions'][$method_name]['body'] = $body_buffer;
                    }
                }
            }
        }
        /**
         * resolvePropertyDefaults
         * Get the default-values for each property, inside the classes of a PHP-file
         * NOTICE: This method must be executed at the end of the ClassParser::parse method to work properly
         *
         * @param $php_file_content - string - The content of the PHP-file, you want to resolve the property-defaults for
         *
         * @throws PropertyResolveException
         * @return void
         */
        private function resolvePropertyDefaults($php_file_content) {
            foreach ($this->classes as $class_name => $class) {
                if (isset($class['properties'])) {
                    foreach ($class['properties'] as $prop_name => $data) {
                        $modifiers = $data['modifiers'];
                        // (?:(?:public|private)\s*)+\$property\s*=\s*(.*?|\s*);
                        $regex = '(?:(?:';
                        $regex.= implode('|', $modifiers);
                        $regex.= ')\s*)+\\$';
                        $regex.= $prop_name;
                        $regex.= '\s*=\s*(.*?|\s*);';
                        $matches = [];
                        $match_count = preg_match_all('/' . $regex . '/im', $php_file_content, $matches, PREG_SET_ORDER | PREG_OFFSET_CAPTURE);
                        if ($match_count === false) {
                            throw new \PropertyResolveException('Unable to resolve default value for property "' . $prop_name . '" in class "' . $class_name . '"');
                        }
                        if ($match_count > 1) {
                            throw new \PropertyResolveException('Exactly 1 or 0 results were expected for preg_match "' . $regex . '" - got ' . $match_count . ' results.');
                        }
                        if (isset($matches[0][1][0])) {
                            $this->classes[$class_name]['properties'][$prop_name]['default'] = $matches[0][1][0];
                        } else {
                            $this->classes[$class_name]['properties'][$prop_name]['default'] = null;
                        }
                    }
                }
            }
        }
        /**
         * parse
         * Analyzes a given PHP-file-content and tries to get information about the classes
         * NOTICE: This method is only working with classes and not with functions/variables outside a class-scope
         *
         * @param $php_file_content - string - The PHP-file content, you want to parse
         *
         * @return void
         */
        public function parse($php_file_content) {
            $tokens = token_get_all($php_file_content);
            $classes = array();
            $si = NULL;
            $depth = 0;
            $mod = array();
            $doc = NULL;
            $state = NULL;
            foreach ($tokens as $idx => & $token) {
                if (is_array($token)) {
                    switch ($token[0]) {
                        case T_AS:
                        case T_USE:
                            // depth 0, because foreach uses "as" also
                            if ($state != STATE_CLASS_HEAD && $depth == 0) {
                                $t = token_name($token[0]);
                                $ni = count($this->aliases);
                                if (T_AS == $token[0]) {
                                    //"as" must follow "use" in this case - therefore, an index already exists
                                    $ni--;
                                }
                                if (!isset($this->aliases[$ni][$t])) {
                                    $this->aliases[$ni][$t] = '';
                                }
                                $state = $token[0];
                            }
                        break;
                        case T_DOC_COMMENT:
                            $doc = $token[1];
                        break;
                        case T_STATIC:
                        case T_PUBLIC:
                        case T_PRIVATE:
                        case T_ABSTRACT:
                        case T_PROTECTED:
                            $mod[] = $token[1];
                        break;
                        case T_CLASS:
                        case T_TRAIT:
                        case T_FUNCTION:
                            $state = $token[0];
                        break;
                        case T_EXTENDS:
                        case T_IMPLEMENTS:
                            switch ($state) {
                                case STATE_CLASS_HEAD:
                                case T_EXTENDS:
                                case T_IMPLEMENTS:
                                    $state = $token[0];
                                break;
                            }
                        break;
                        case T_VARIABLE:
                            $clsc = count($classes);
                            $real_var = substr($token[1], 1); //Cutoff $
                            switch ($state) {
                                case 0:
                                    if (count($mod) > 0) {
                                        if ($depth == 1 && $clsc) {
                                            // properties only on depth-level 1 (otherwise late-static-binding messes up the propertie modifiers)
                                            $classes[$clsc - 1]['properties'][$real_var] = array('modifiers' => $mod, 'doc' => $doc);
                                        }
                                    }
                                break;
                                case STATE_FUNCTION_HEAD:
                                    end($classes[$clsc - 1]['functions']); //Last method which was added to array
                                    $fn = key($classes[$clsc - 1]['functions']);
                                    $classes[$clsc - 1]['functions'][$fn]['args'][$real_var] = null;
                                break;
                            }
                        break;
                        case T_WHITESPACE:
                        case T_NS_SEPARATOR:
                        case T_STRING:
                            $is_whitespace = ($token[0] == T_WHITESPACE);
                            $is_ns_seperator = ($token[0] == T_NS_SEPARATOR);
                            $is_string = ($token[0] == T_STRING);
                            if (($state != T_IMPLEMENTS && $state != T_EXTENDS && $state != T_USE && $state != T_AS) && ($token[0] == T_NS_SEPARATOR || $token[0] == T_WHITESPACE)) {
                                // T_NS_SEPARATOR and T_WHITESPACE are just relevant, if we processing IMPLEMENTS, EXTENDS or USE/AS currently
                                break;
                            }
                            switch ($state) {
                                case T_AS:
                                case T_USE:
                                    if (!$is_whitespace) {
                                        $t = token_name($state);
                                        $i = count($this->aliases) - 1;
                                        $this->aliases[$i][$t].= $token[1];
                                    }
                                break;
                                case T_CLASS:
                                case T_TRAIT:
                                    $state = STATE_CLASS_HEAD;
                                    $si = $token[1];
                                    $classes[] = array('name' => $token[1], 'modifiers' => $mod, 'doc' => $doc);
                                break;
                                case T_FUNCTION:
                                    $state = STATE_FUNCTION_HEAD;
                                    $clsc = count($classes);
                                    if ($depth > 0 && $clsc) {
                                        $classes[$clsc - 1]['functions'][$token[1]] = array('modifiers' => $mod, 'args' => array(), 'doc' => $doc);
                                    }
                                break;
                                case STATE_FUNCTION_HEAD:
                                    end($classes[$clsc - 1]['functions']); //Last method which was added to array
                                    $fn = key($classes[$clsc - 1]['functions']);
                                    end($classes[$clsc - 1]['functions'][$fn]['args']); //last argument which was added to function
                                    $arg = key($classes[$clsc - 1]['functions'][$fn]['args']);
                                    $classes[$clsc - 1]['functions'][$fn]['args'][$arg] = $token[1];
                                break;
                                case T_IMPLEMENTS:
                                case T_EXTENDS:
                                    $clsc = count($classes);
                                    $key = $state == T_IMPLEMENTS ? 'implements' : 'extends';
                                    if (!isset($classes[$clsc - 1][$key])) {
                                        $classes[$clsc - 1][$key] = [];
                                    }
                                    if ($is_whitespace) {
                                        $classes[$clsc - 1][$key][] = '';
                                    } else {
                                        $last = count($classes[$clsc - 1][$key]) - 1;
                                        if ($last < 0) {
                                            $last = 0;
                                            $classes[$clsc - 1][$key][$last] = '';
                                        }
                                        $classes[$clsc - 1][$key][$last].= $token[1];
                                    }
                                break;
                            }
                        break;
                        case T_LNUMBER:
                        case T_CONSTANT_ENCAPSED_STRING:
                            switch ($state) {
                                case STATE_FUNCTION_HEAD:
                                    end($classes[$clsc - 1]['functions']); //Last method which was added to array
                                    $fn = key($classes[$clsc - 1]['functions']);
                                    end($classes[$clsc - 1]['functions'][$fn]['args']); //last argument which was added to function
                                    $arg = key($classes[$clsc - 1]['functions'][$fn]['args']);
                                    $classes[$clsc - 1]['functions'][$fn]['args'][$arg] = $token[1]; // push this token as default value for this argument
                                    
                            }
                        break;
                    }
                } else {
                    switch ($token) {
                        case '{':
                            $depth++;
                        break;
                        case '}':
                            $depth--;
                        break;
                    }
                    switch ($token) {
                        case '{':
                        case '}':
                        case ';':
                            $state = 0;
                            $doc = NULL;
                            $mod = array();
                        break;
                    }
                }
            }
            foreach ($classes as $class) {
                //$class['file'] = $file;
                $this->classes[$class['name']] = $class;
                if (!empty($class['implements'])) {
                    foreach ($class['implements'] as $name) {
                        $this->implements[$name][] = $class['name'];
                    }
                }
                if (!empty($class['extends'])) {
                    foreach ($class['extends'] as $name) {
                        $this->extends[$name][] = $class['name'];
                    }
                }
            }
            $this->resolveMethodBodies($php_file_content);
            $this->resolvePropertyDefaults($php_file_content);
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

[state]
CLASS_HEAD = 100001
FUNCTION_HEAD = 100002

END[CONFIG.INI]


?>



<?php #HYPERCELL hcdk.data.xml.Fragment - BUILD 22.01.24#64
namespace hcdk\data\xml;
class Fragment {
    use \hcf\core\dryver\Config, Fragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment';
    const NAME = 'Fragment';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcdkdataxmlFragment_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataxmlFragment_onConstruct'], func_get_args());
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
    namespace hcdk\data\xml\Fragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use hcdk\data\ph\Parser as PlaceholderParser;
    use hcdk\data\xml\Parser as XMLParser;
    /**
     * Fragment
     * Default Fragment for rmf.core.xml.Parser
     *
     * @category XML Fragment
     * @package rmf.core [INTERNAL]
     * @author Philipp Kopf
     */
    trait Controller {
        private static $OUTPUT_STARTED = false; // Is true, until you close the Fragment-Output. This flag decides, if $between_double_quotes of Placeholder::process should be true or not
        
        /**
         * build
         * Translates the given XML-Fragment into an executable PHP-script-part
         * NOTICE: If rmc.xml.Parser cannot resolve the name of a XML-tag to a Fragment-generalisation, this class will be used as default
         *
         * @param $node - LibXML Node object - Information about the current fragment, it's attributes and children
         * @param $file_scope - string - The filepath to the file which contains the current fragment
         *
         * @return string - An executable PHP-script-part, which will be append to the __toString method of the raw-merge
         */
        public static function build($node, $file_scope) {
            $root_name = $node->getName();
            $is_optional = (strpos($root_name, XMLParser::TMP_OPT_TAG_MARKER) !== false);
            $output = self::FRGMNT_OUTPUT_START() . '<' . $root_name;
            foreach ($node->attributes() as $name => $value) {
                $output.= ' ' . $name . '=\"' . PlaceholderParser::parse($value) . '\"';
            }
            if (XMLParser::isVoidTag($root_name)) {
                $output.= '/>';
            } else if ($is_optional && XMLParser::isVoidTag(str_replace(XMLParser::TMP_OPT_TAG_MARKER, '', $root_name))) {
                throw new \Exception(self::FQN . ' - self-closing tags cannot be optional. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root_name) . '"');
            } else {
                $output.= '>';
                if (count($node->children()) > 0) {
                    // End this output-line here, because we do not know what renderFragment will give us back
                    $output.= self::FRGMNT_OUTPUT_END();
                    foreach ($node->children() as $child) {
                        $output.= XMLParser::renderFragment($child, $file_scope);
                    }
                    $output.= self::FRGMNT_OUTPUT_START();
                } else {
                    $string_contents = (string)$node;
                    if (self::$OUTPUT_STARTED) {
                        $string_contents = str_replace('"', '\"', $string_contents); // escape double-quotes in plain-text before processing placeholders -> keeps the quotes added by placeholders here as meant to be
                        
                    }
                    $output.= PlaceholderParser::parse($string_contents);
                }
                $output.= '</' . $root_name . '>';
            }
            return $output . self::FRGMNT_OUTPUT_END();
        }
        /**
         * FRGMNT_OUTPUT_START
         * Returns the Fragment::FRGMNT_OUTPUT_START value and sets the Fragment::$OUTPUT_STARTED flag to true
         *
         * @return string - the Fragment::FRGMNT_OUTPUT_START value
         */
        public static function FRGMNT_OUTPUT_START() {
            self::$OUTPUT_STARTED = true;
            return self::config()->output->start;
        }
        /**
         * FRGMNT_OUTPUT_END
         * Returns the Fragment::FRGMNT_OUTPUT_END value and sets the Fragment::$OUTPUT_STARTED flag to false
         *
         * @return string - the Fragment::FRGMNT_OUTPUT_END value
         */
        public static function FRGMNT_OUTPUT_END() {
            self::$OUTPUT_STARTED = false;
            return self::config()->output->end;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

output.start = '$output .= "'; $output is the string, which will be returned by the template method of your hypercell
output.end = '";'; This closes the $output var

END[CONFIG.INI]


?>



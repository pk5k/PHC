<?php #HYPERCELL hcdk.data.xml.Parser - BUILD 21.02.24#70
namespace hcdk\data\xml;
class Parser {
    use \hcf\core\dryver\Config, \hcf\core\dryver\Constant, Parser\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Parser';
    const NAME = 'Parser';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    # BEGIN ASSEMBLY FRAME CONSTANT
    const TMP_OPT_MARKER = '--TMP-OPT-MARKER--';
    private static $_constant_list = ['TMP_OPT_MARKER'];
    # END ASSEMBLY FRAME CONSTANT
    
    }
    namespace hcdk\data\xml\Parser\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\remote\Invoker as RemoteInvoker;
    /**
     * Parser
     * This class parses an xml-string using lib-xml and executes a Fragment generalisation each time,
     * a tag name matches a defined pattern
     *
     * @category XML Parser
     * @package rmf.core [INTERNAL]
     * @author Philipp Kopf
     */
    trait Controller {
        /*
         * parse
         * Parses a xml input-string and calls the fragment-generalisations
         *
         * @param $xml_input - string - a well formed xml-string
         * @param $file_scope - string - the path/name of the xml input-string which will be processed
         *
         * @throws XMLParseException
         * @return string - the processed xml input-string
        */
        public static function parse($xml_input = null, $file_scope = null) {
            if (is_null($xml_input)) {
                throw new \XMLParseException('Cannot parse XML-input - XML-input is null');
            }
            if (!isset($file_scope)) {
                $file_scope = 'unknown';
            }
            if (strpos($xml_input, '<?xml') === false) {
                $xml_input = '<?xml version="1.0"?>' . $xml_input;
            }
            libxml_use_internal_errors(true); // Avoid direct printing of parser-errors
            $errors = null;
            $xml = '';
            $xml_input = self::morphAttributes($xml_input);
            try {
                $xml = new \SimpleXMLElement(self::replaceSpecialChars($xml_input));
                self::processLibXMLErrors($file_scope);
                $output = self::renderFragment($xml, $file_scope);
            }
            catch(\Exception $e) {
                $errors = $e->getMessage();
            }
            try {
                self::processLibXMLErrors($file_scope);
            }
            catch(\XMLParseException $e) {
                $errors.= "\r\n" . $e->getMessage();
            }
            if (isset($errors)) {
                throw new \XMLParseException($errors);
            }
            libxml_use_internal_errors(false);
            return self::demorphAttributes($output);
        }
        /**
         * processLibXMLErrors
         * Reads the occured errors from libxml and rewrites them to a XMLParseException
         *
         * @throws XMLParseException
         * @return void
         */
        private static function processLibXMLErrors($file_scope) {
            $errors = libxml_get_errors();
            if (count($errors) > 0) {
                $message = "Parse-errors: \n\r";
                foreach ($errors as $error) {
                    $message.= $error->message . ' (' . $error->code . ') in ' . $file_scope . ' at line ' . $error->line . "\n\r";
                }
                libxml_clear_errors();
                throw new \XMLParseException($message);
            }
        }
        /**
         * renderFragment
         * Renders a single xml-fragment
         *
         * @param $xml_root - LibXML-Node object - The fragment which should be rendered
         * @param $file_scope - string - optional - The file which contains this fragment
         *
         * @throws XMLParseException
         * @return string - the rendered fragment
         */
        public static function renderFragment($xml_root, $file_scope = null) {
            $class = null;
            $name = $xml_root->getName();
            $package = self::config()->fragment->package;
            $suffix = self::config()->fragment->suffix;
            if (self::config()->{'dash-to-cc'}) {
                $name = str_replace(' ', '', ucwords(str_replace('-', ' ', $name)));
            }
            if (strpos($name, '.') > 0) {
                $name_parts = explode('.', $name);
                $last = array_pop($name_parts);
                $name = strtolower(implode('.', $name_parts));
                $name.= '.' . ucfirst($last);
            }
            $name.= $suffix;
            if (substr($package, -1) !== '.') {
                $package.= '.';
            }
            $type_class = $package . $name;
            RemoteInvoker::implicitConstructor(false);
            $ri = null;
            try {
                $ri = new RemoteInvoker($type_class);
                $type_class = $ri->getInstance();
                self::validateProcessor($type_class);
            }
            catch(\Exception $e) {
                // use the default-fragment
                $type_class = Utils::HCFQN2PHPFQN(self::config()->fragment->base);
            }
            return $type_class::build($xml_root, $file_scope);
        }
        /**
         * isVoidTag
         * Determines, if a HTML-tag can be self-closing or not
         *
         * @param $tag_name - string - the name of the HTML-tag
         *
         * @return boolean - true, if HTML-tag is self-closing; false, if HTML-tag is NOT self-closing
         */
        public static function isVoidTag($tag_name) {
            switch (strtolower($tag_name)) {
                case 'area':
                case 'base':
                case 'br':
                case 'col':
                case 'command':
                case 'embed':
                case 'hr':
                case 'img':
                case 'input':
                case 'keygen':
                case 'link':
                case 'meta':
                case 'param':
                case 'source':
                case 'track':
                case 'wbr':
                    return true;
            }
            return false;
        }
        /**
         * replaceSpecialChars
         * Replaces special-characters to their XML-escape-equivalent to avoid LibXML parser-errors
         *
         * @param $str - string - the input-string which should be escaped
         *
         * @return string - the escaped input-string
         */
        public static function replaceSpecialChars($str) {
            $sc_from = array('&');
            $sc_to = array('&#38;');
            return str_replace($sc_from, $sc_to, $str);
        }
        /**
         * validateProcessor
         * Validates, if a given class-name is a fragment-processor
         *
         * @param $type_class - string - name of the class, which should be validated
         *
         * @throws RuntimeException
         * @return void
         */
        private static function validateProcessor($type_class) {
            $implementers = class_parents($type_class);
            $base = Utils::HCFQN2PHPFQN(self::config()->fragment->base);
            if ($implementers === false || (is_array($implementers) && !in_array($base, $implementers))) {
                throw new \RuntimeException('Fragment "' . $type_class . '" is not a ' . self::config()->fragment->base . ' generalisation.');
            }
        }
        public static function matchOptionalAttributes($raw_xml_input) {
            $matches = [];
            $attrs = [];
            preg_match_all('/\s([\w\d_-]*)\s?=\?\s?"/i', $raw_xml_input, $matches, PREG_SET_ORDER); // search attriutename=?"value" (name goes to group 1)
            foreach ($matches as $match) {
                if (!in_array($match[1], $attrs)) {
                    $attrs[] = $match[1];
                }
            }
            return $attrs;
        }
        protected static function morphAttributes($raw_xml_input) {
            $cleaned = self::matchOptionalAttributes($raw_xml_input);
            $raw_xml_input = str_replace('=?"', self::TMP_OPT_MARKER . '="', $raw_xml_input); // make xml valid but attribute name recognizable
            return $raw_xml_input;
        }
        protected static function demorphAttributes($processed_input) {
            return str_replace(self::TMP_OPT_MARKER . '=', '=?', $processed_input);
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

dash-to-cc = true; Convert dashed fragment-names to UpperCamelCase before resolving the fragments class name

[fragment]
base = "hcdk.data.xml.Fragment"; Name of the base processor Hypercell
package = "hcdk.data.xml.Fragment."; hc-package name which HCs inside implement the fragment-base
suffix = "Fragment"; must be append to all base generalisations


END[CONFIG.INI]


?>



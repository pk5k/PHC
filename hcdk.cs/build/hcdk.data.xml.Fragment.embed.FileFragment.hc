<?php #HYPERCELL hcdk.data.xml.Fragment.embed.FileFragment - BUILD 22.02.15#78
namespace hcdk\data\xml\Fragment\embed;
class FileFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, FileFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.embed.FileFragment';
    const NAME = 'FileFragment';
    public function __construct() {
        if (method_exists($this, 'hcdkdataxmlFragmentembedFileFragment_onConstruct')) {
            call_user_func_array([$this, 'hcdkdataxmlFragmentembedFileFragment_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\embed\FileFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\data\xml\Parser as XMLParser;
    use \hcdk\data\ph\Parser as PlaceholderParser;
    use \hcf\core\Utils as Utils;
    use \Parsedown as MarkdownParser;
    /**
     * File
     * File-Fragment for rmc.xml.Parser
     * This fragment reads the content of a given file and replaces itself trough the files content
     * NOTICE: The source-file location must be known while build-time, thus, no placeholders can be used inside the src-/type-attribute
     *
     * @category XML Fragment
     * @package rmb.xml.fragment.embed
     * @author Philipp Kopf
     */
    trait Controller {
        public static function build($root, $file_scope) {
            $process_placeholders = false;
            $is_xml = false;
            $src = (isset($root['src'])) ? (string)$root['src'] : null;
            $type = (isset($root['type'])) ? $root['type'] : 'raw'; // determine, how the file-content should be treated - text, xml, raw
            switch (strtolower($type)) {
                    // only process the placeholders
                    
                case 'text':
                    $process_placeholders = true;
                    $is_xml = false;
                break;
                    // parse the content with the xml-parser before using it (this includes processing the placeholders implicit)
                    
                case 'xml':
                    $process_placeholders = false;
                    $is_xml = true;
                break;
                    // use the content "as-is"
                    
                case 'raw':
                default:
                    $process_placeholders = false;
                    $is_xml = false;
                break;
            }
            if (count($root->children()) > 0) {
                throw new \XMLParseException(self::FQN . ' - Fragment cannot have content. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            if (!isset($src) || !is_string($src)) {
                throw new \XMLParseException(self::FQN . ' - No source-file specified - attribute "src" is non-optional. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            // if the source-path does not start with / it is relative...
            if (substr($src, 0, 1) !== '/') {
                // ...to the path of our current xml channel-source
                $src = dirname($file_scope) . '/' . $src;
            }
            if (!file_exists($src) || !is_readable($src)) {
                throw new \XMLParseException(self::FQN . ' - File "' . $src . '" does not exist or has wrong permissions. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            $file_contents = file_get_contents($src);
            if ($is_xml) {
                $file_contents = XMLParser::parse($file_contents, $src);
            }
            if ($process_placeholders) {
                $file_contents = PlaceholderParser::parse($file_contents);
            }
            if ($is_xml) {
                // if we processed our file-content with the xml parser, we do not need to set the output start and end
                return $file_contents;
            }
            // escape "
            $file_contents = str_replace('"', '\"', $file_contents);
            return parent::FRGMNT_OUTPUT_START() . $file_contents . parent::FRGMNT_OUTPUT_END() . Utils::newLine();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcdk.data.xml.Fragment.embed.MarkdownFragment - BUILD 22.02.23#82
namespace hcdk\data\xml\Fragment\embed;
class MarkdownFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, MarkdownFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.embed.MarkdownFragment';
    const NAME = 'MarkdownFragment';
    public function __construct() {
        if (method_exists($this, 'hcdkdataxmlFragmentembedMarkdownFragment_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkdataxmlFragmentembedMarkdownFragment_onConstruct_Controller'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\embed\MarkdownFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\data\xml\Parser as XMLParser;
    use \hcdk\data\ph\Parser as PlaceholderParser;
    use \hcf\core\Utils as Utils;
    use \Parsedown as MarkdownParser;
    /**
     * Markdown
     * Markdown-Fragment for \hcf\core.xml.Parser
     * This fragment renders markdown to valid HTML and replaces itself with the rendered content
     * NOTICE: The source-file location must be known while build-time, thus, no placeholders can be used inside the src-attribute (if set)
     *
     * @category XML Fragment
     * @package hcdk.xml.fragment.embed
     * @author Philipp Kopf
     */
    trait Controller {
        public static function build($root, $file_scope) {
            /* PARSEDOWN SETTINGS */
            $BREAKS_ENABLED = (isset($root['breaks-enabled'])) ? $root['breaks-enabled'] : true; // enables automatic line-breaks
            $MARKUP_ESCAPED = (isset($root['escape-markup'])) ? $root['escape-markup'] : true; // escape HTML, contained inside this fragment
            $URLS_LINKED = (isset($root['link-urls'])) ? $root['link-urls'] : false; // prevents automatic linking of URLs
            // get the markdown out of a given file, if the src attribute is set
            $src = (isset($root['src'])) ? (string)$root['src'] : false;
            $markdown_content = '';
            if (!$src) {
                if (count($root->children()) > 0) {
                    throw new \XMLParseException(self::FQN . '- Fragment cannot have children. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()));
                }
                $markdown_content = (string)$root;
            } else {
                // if the source-path does not start with / it is relative...
                if (substr($src, 0, 1) !== '/') {
                    // ...to the path of our current xml channel-source
                    $src = dirname($file_scope) . '/' . $src;
                }
                if (!file_exists($src) || !is_readable($src)) {
                    throw new \XMLParseException(self::FQN . ' - File "' . $src . '" does not exist or has wrong permissions. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
                }
                $markdown_content = file_get_contents($src);
            }
            $parsed_md = MarkdownParser::instance()->setMarkupEscaped($MARKUP_ESCAPED)->setBreaksEnabled($BREAKS_ENABLED)->setUrlsLinked($URLS_LINKED)->text($markdown_content);
            // process placeholders AFTER markdown was converted to HTML because the resolved placeholder may be
            // useless after rendering the markdown (the > of $this->... get's escaped for example, if MARKUP_ESCAPED is true)
            $ph_output = PlaceholderParser::parse($parsed_md, true);
            // escape "
            $ph_output = str_replace('"', '\"', $ph_output);
            return parent::FRGMNT_OUTPUT_START() . $ph_output . parent::FRGMNT_OUTPUT_END() . Utils::newLine();
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
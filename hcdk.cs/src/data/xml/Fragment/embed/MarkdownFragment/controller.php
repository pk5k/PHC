<?php
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
trait Controller
{
	public static function build($root, $file_scope)
	{
		/* PARSEDOWN SETTINGS */
		$BREAKS_ENABLED = (isset($root['breaks-enabled'])) ? $root['breaks-enabled'] : true; // enables automatic line-breaks
		$MARKUP_ESCAPED = (isset($root['escape-markup'])) ? $root['escape-markup'] : true; // escape HTML, contained inside this fragment
		$URLS_LINKED 	 = (isset($root['link-urls'])) ? $root['link-urls'] : false; // prevents automatic linking of URLs

		// get the markdown out of a given file, if the src attribute is set
		$src = (isset($root['src'])) ? (string)$root['src'] : false;
		$markdown_content = '';

		if(!$src)
		{
			if(count($root->children())>0)
			{
				throw new \XMLParseException('Fragment cannot have children');
			}

			$markdown_content = (string)$root;
		}
		else
		{
			// if the source-path does not start with / it is relative...
			if(substr($src, 0, 1) !== '/')
			{
				// ...to the path of our current xml channel-source
				$src = dirname($file_scope).'/'.$src;
			}

			if(!file_exists($src) || !is_readable($src))
			{
				throw new \XMLParseException('File "'.$src.'" does not exist or has wrong permissions');
			}

			$markdown_content = file_get_contents($src);
		}

		$parsed_md 	= MarkdownParser::instance()
						->setMarkupEscaped($MARKUP_ESCAPED)
						->setBreaksEnabled($BREAKS_ENABLED)
						->setUrlsLinked($URLS_LINKED)
						->text($markdown_content);

		// process placeholders AFTER markdown was converted to HTML because the resolved placeholder may be
		// useless after rendering the markdown (the > of $this->... get's escaped for example, if MARKUP_ESCAPED is true)
		$ph_output  = PlaceholderParser::parse($parsed_md, true);

		// escape "
		$ph_output = str_replace('"', '\"', $ph_output);

		return parent::FRGMNT_OUTPUT_START().$ph_output.parent::FRGMNT_OUTPUT_END().Utils::newLine();
	}
}
?>

<?php
use \hcf\core\Utils as Utils;
use \hcf\web\ComponentContext;
use \hcf\web\Component;
use \hcf\web\Bridge;
use \hcf\web\PageLoader;
use \hcf\web\Page;

/**
 * Server
 * This is the HTML-container from the raw-merge framework
 *
 * @category HTML
 * @package web.browser.container
 * @author Philipp Kopf
 * @version 1.0.0
 */

trait Model
{
	protected $title = self::FQN;
	protected $content_language = 'en';
	protected $content = 'No content set.';
	protected $ext_js = [];
	protected $emb_js = [];
	protected $ext_css = [];
	protected $emb_css = [];
	protected $encoding = 'utf-8';

	protected $font_family = 'arial';
	protected $font_size = 12;//px

	protected $fav_mimetype = '';
	protected $fav_path = '';
	protected $meta_http_equiv = [];
	protected $meta_name = [];
	protected $autoloading = false;
	protected $component_reg_data = '';
	protected $component_reg_data_initialized = false;
	protected $component_contexts = [];

	/**
	 * __construct
	 *
	 */
	public function onConstruct()
	{
		$config = self::config();

		if(isset($config))
		{
			if(isset($config->font) && is_object($config->font))
			{
				$this->font($config->font->family);
				$this->fontSize($config->font->size);
			}

			if(isset($config->{'enable-autoloader'}) && is_bool($config->{'enable-autoloader'}))
			{
				$this->autoloading = $config->{'enable-autoloader'};
			}

			if(isset($config->encoding) && is_string($config->encoding))
			{
				$this->encoding($config->encoding);
			}

			if(isset($config->{'fav-icon'}) && is_string($config->{'fav-icon'}))
			{
				$this->favicon($config->{'fav-icon'});
			}
		}

		$cc = new ComponentContext('core');
		$cc->register(Component::class);
		$cc->register(Bridge::class);
		$cc->register(PageLoader::class);
		$cc->register(Page::class);

		$this->registerComponentContext($cc);
	}

	/**
	 * title
	 * Set the title of your Browser-Tab/-Window
	 *
	 * @param $title - string - the title you want to display
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public function title($title)
	{
		if(!isset($title) || !is_string($title))
		{
			throw new \RuntimeException('Argument $title for "'.self::FQN.'::title($title)" is not a valid string.');
		}

		$this->title = $title;
	}

	/**
	 * font
	 * Set the font of this document
	 *
	 * @param $font_family - string - the name of the font you want to use
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public function font($font_family)
	{
		if(!isset($font_family) || !is_string($font_family))
		{
			throw new \RuntimeException('Argument $font_family for "'.self::FQN.'::font($font_family)" is not a valid string.');
		}

		$this->font_family = $font_family;
	}

	/**
	 * fontSize
	 * Set the base-font-size of this document
	 *
	 * @param $font_size - int - the font-size in pixels to use across the document
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public function fontSize($font_size = 12)
	{
		if(!isset($font_size))
		{
			throw new \RuntimeException('Argument $font_size for "'.self::FQN.'::fontSize($font_size)" is not set');
		}

		$this->font_size = $font_size;
	}

	/**
	 * content
	 * Set the content between the <body></body> tags
	 *
	 * @param $content - string - the content you want to display
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public function content($content)
	{
		if(!isset($content) || !is_string($content))
		{
			throw new \RuntimeException('Argument $content for "'.self::FQN.'::content($content)" is not a valid string.');
		}

		$this->content = $content;
	}

	/**
	 * linkScript
	 * Add an external javascript-resource you want to load inside the head of this container
	 *
	 * @param $url - string - the URL, where the external script is located
	 *
	 * @return void
	 */
	public function linkScript($url)
	{
		$this->ext_js[] = $url;
	}

	/**
	 * embedScript
	 * Embed a javascript-string directly into the head of this container
	 *
	 * @param $js_data - string - the Javascript-string, which will be embedded to the head
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public function embedScript($js_data)
	{
		if(!is_string($js_data))
		{
			throw new \RuntimeException('Argument $js_data for "'.self::FQN.'::embedScript($js_data)" is not a valid string.');
		}

		$this->emb_js[] = $js_data;
	}

	/**
	 * linkStylesheet
	 * Add an external stylesheet-resource you want to load inside the head of this container
	 *
	 * @param $url - string - the URL, where the external stylesheet is located
	 * @param $media - string - specifies, for what media/device the target resource is optimized for
	 *
	 * @return void
	 */
	public function linkStylesheet($url, $media = null)
	{
		$this->ext_css[$url] = (isset($media)) ? $media : '';
	}

	/**
	 * embedStylesheet
	 * Embed a stylesheet-string directly into the head of this container
	 *
	 * @param $css_data - string - the stylesheet-string, which will be embedded to the head
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public function embedStylesheet($css_data)
	{
		if(!is_string($css_data))
		{
			throw new \RuntimeException('Argument $css_data for "'.self::FQN.'::embedScript($css_data)" is not a valid string.');
		}

		$this->emb_css[] = $css_data;
	}

	/**
	 * contentLanguage
	 *
	 *
	 * @param $lang - string - the value that will be used as lang-attribute on the HTML-element
	 *
	 * @return
	 */
	public function contentLanguage($lang = null)
	{
		if (is_null($lang))
		{
			return $this->content_language;
		}

		if (!is_string($lang))
		{
			throw new \RuntimeException(self::FQN.' - invalid content-language value passed; not a string');
		}

		$this->content_language = $lang;
	}

	/**
	 * meta
	 * Add a meta-tag to the head of the container
	 *
	 * @param $name - string - Value, which will be written inside meta-tags "name" attribute
	 * @param $value - string - This will be inserted into the "content" attribute of the meta-tag
	 * @param $http_equiv - boolean - If true, the "name" attribute will be changed into "http-equiv"
	 *
	 * @return void
	 */
	public function meta($name, $value, $http_equiv = false)
	{
		if($http_equiv)
		{
			$this->meta_http_equiv[$name][] = $value;
		}
		else
		{
			$this->meta_name[$name][] = $value;
		}
	}

	/**
	 * encoding
	 * Set the encoding of your page
	 *
	 * @param $encoding - string - the encoding, this page is using
	 *
	 * @return void
	 */
	public function encoding($encoding)
	{
		$this->encoding = $encoding;
	}

	/**
	 * favicon
	 * Adds a fav-icon to your browser-window
	 *
	 * @param $image_path - string - the path to the fav-icon, you want to use
	 *
	 * @return void
	 */
	public function favicon($image_path)
	{
		$this->fav_mimetype = Utils::getMimeTypeByExtension($image_path);
		$this->fav_path = $image_path;
	}

	/**
	 * fqn
	 *
	 * @return self::FQN
	 */
	public function fqn()
	{
		return self::FQN;
	}

	/**
	 * autoloader
	 * Loads the Autoloader - if enabled (over the constructor of this instance)
	 *
	 * @return string - Autoloader output-channel
	 */
	public function autoloader()
	{
		if($this->autoloading)
		{
			try
			{
				$class 		= __CLASS__.'\\Autoloader';
				$autoloader = new $class();

				return $autoloader->toString();
			}
			catch (\FileNotFoundException $e)
			{
				header(Utils::getHTTPHeader(404));

				throw $e;
			}
		}

		return '';
	}

	public function registerComponentContext(ComponentContext $cc)
	{
		$this->component_contexts[] = $cc;
	}

	protected function renderContent()
	{
		return $this->content;
	}

	protected function ownScript()
	{
		return self::script();
	}

	protected function ownStyle()
	{
		return self::style();
	}

	private function appVersion()
	{
		return (defined('APP_VERSION') ? APP_VERSION : '');
	}
}
?>

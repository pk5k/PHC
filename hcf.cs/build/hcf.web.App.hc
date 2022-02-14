<?php #HYPERCELL hcf.web.App - BUILD 22.02.13#136
namespace hcf\web;
class App {
    use \hcf\core\dryver\Config, App\__EO__\Controller, \hcf\core\dryver\Client, \hcf\core\dryver\Client\Js, \hcf\core\dryver\Output, \hcf\core\dryver\Template, \hcf\core\dryver\Template\Html, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.App';
    const NAME = 'App';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfwebApp_onConstruct')) {
            call_user_func_array([$this, 'hcfwebApp_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.JSON
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'JSON');
        self::$config = json_decode($content);
    }
    # END ASSEMBLY FRAME CONFIG.JSON
    # BEGIN ASSEMBLY FRAME CONTROLLER.TS
    public static function script() {
        $js = "define(\"hcf.web.App\",[\"require\",\"exports\"],function(require,exports){\"use strict\";Object.defineProperty(exports,\"__esModule\",{value:true});function init(){throw'You have to override the main hcf.web.App with a hypercell that uses an own client.ts assembly.';}
exports.default=init;});";
        return $js;
    }
    # END ASSEMBLY FRAME CONTROLLER.TS
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "<!DOCTYPE html>
{$__CLASS__::_call('render', $__CLASS__, $_this) }";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    # BEGIN ASSEMBLY FRAME TEMPLATE.HTML
    public function render() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = '';
        $output.= "<html lang=\"{$__CLASS__::_property('content_language', $__CLASS__, $_this) }\">";
        $output.= "<head>";
        $output.= "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=Edge\"/>";
        $output.= "<meta charset=\"{$__CLASS__::_property('encoding', $__CLASS__, $_this) }\"/>";
        $output.= "<title>{$__CLASS__::_property('title', $__CLASS__, $_this) }</title>";
        $output.= "<link rel=\"icon\" type=\"{$__CLASS__::_property('fav_mimetype', $__CLASS__, $_this) }\" href=\"{$__CLASS__::_property('fav_path', $__CLASS__, $_this) }\"/>";
        $output.= "<base href=\"{$__CLASS__::_call('base', $__CLASS__, $_this) }\"/>";
        foreach ($__CLASS__::_property('meta_http_equiv', $__CLASS__, $_this) as $metaname => $typearr) {
            foreach ($typearr as $val) {
                $output.= "<meta http-equiv=\"$metaname\" content=\"$val\"/>";
            }
        }
        foreach ($__CLASS__::_property('meta_name', $__CLASS__, $_this) as $metaname => $typearr) {
            foreach ($typearr as $val) {
                $output.= "<meta name=\"$metaname\" content=\"$val\"/>";
            }
        }
        foreach ($__CLASS__::_property('ext_js', $__CLASS__, $_this) as $src) {
            $output.= "<script type=\"text/javascript\" src=\"$src\"></script>";
        }
        foreach ($__CLASS__::_property('ext_css', $__CLASS__, $_this) as $href => $media) {
            $output.= "<link rel=\"stylesheet\" type=\"text/css\" href=\"$href\" media=\"$media\"/>";
        }
        $output.= "<script language=\"javascript\">";
        foreach ($__CLASS__::_property('emb_js', $__CLASS__, $_this) as $emb_js_str) {
            $output.= "$emb_js_str 
				";
        }
        $output.= "</script>";
        $output.= "<style>";
        foreach ($__CLASS__::_property('emb_css', $__CLASS__, $_this) as $emb_css_str) {
            $output.= "$emb_css_str 
				";
        }
        $output.= "</style>";
        $output.= "<style>body { font-family:'{$__CLASS__::_property('font_family', $__CLASS__, $_this) }'!important; font-size:{$__CLASS__::_property('font_size', $__CLASS__, $_this) }!important;}</style>";
        $output.= "</head>";
        $output.= "<body>";
        $output.= "{$__CLASS__::_property('content', $__CLASS__, $_this) }";
        $output.= "<script language=\"javascript\">requirejs.config({baseUrl: '{$__CLASS__::_call('requireJsBaseUrl', $__CLASS__, $_this) }'}); require(['{$__CLASS__::_call('fqn', $__CLASS__, $_this) }']);</script>";
        $output.= "</body>";
        $output.= "</html>";
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME TEMPLATE.HTML
    
    }
    namespace hcf\web\App\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\web\Bridge as Bridge;
    use \hcf\web\App\RequireJS;
    /**
     * Server
     * This is the HTML-container from the raw-merge framework
     *
     * @category HTML
     * @package web.browser.container
     * @author Philipp Kopf
     * @version 1.0.0
     */
    trait Controller {
        private $title = self::FQN;
        private $content_language = 'en';
        private $content = 'No content set.';
        private $ext_js = [];
        private $emb_js = [];
        private $ext_css = [];
        private $emb_css = [];
        private $encoding = 'utf-8';
        private $font_family = 'arial';
        private $font_size = 12; //px
        private $fav_mimetype = '';
        private $fav_path = '';
        private $meta_http_equiv = [];
        private $meta_name = [];
        private $autoloading = false;
        private $initialized = false;
        private $_base = '/';
        /**
         * __construct
         *
         * @param autoload - boolean - optional - enable the autoloader for this instance (true) or not (false)
         */
        public function hcfwebApp_onConstruct() {
            $this->init();
        }
        protected function init() {
            if ($this->initialized) {
                return;
            }
            $config = self::config();
            if (isset($config)) {
                if (isset($config->font) && is_object($config->font)) {
                    $this->font($config->font->family);
                    $this->fontSize($config->font->size);
                }
                if (isset($config->encoding) && is_string($config->encoding)) {
                    $this->encoding($config->encoding);
                }
                if (isset($config->{'fav-icon'}) && is_string($config->{'fav-icon'})) {
                    $this->favicon($config->{'fav-icon'});
                }
            }
            $this->embedScript(RequireJS::script());
            $this->initialized = true;
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
        public function title($title) {
            if (!isset($title) || !is_string($title)) {
                throw new \RuntimeException('Argument $title for "' . self::FQN . '::title($title)" is not a valid string.');
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
        public function font($font_family) {
            if (!isset($font_family) || !is_string($font_family)) {
                throw new \RuntimeException('Argument $font_family for "' . self::FQN . '::font($font_family)" is not a valid string.');
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
        public function fontSize($font_size = 12) {
            if (!isset($font_size)) {
                throw new \RuntimeException('Argument $font_size for "' . self::FQN . '::fontSize($font_size)" is not set');
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
        public function content($content) {
            if (!isset($content) || !is_string($content)) {
                throw new \RuntimeException('Argument $content for "' . self::FQN . '::content($content)" is not a valid string.');
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
        public function linkScript($url) {
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
        public function embedScript($js_data) {
            if (!is_string($js_data)) {
                throw new \RuntimeException('Argument $js_data for "' . self::FQN . '::embedScript($js_data)" is not a valid string.');
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
        public function linkStylesheet($url, $media = null) {
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
        public function embedStylesheet($css_data) {
            if (!is_string($css_data)) {
                throw new \RuntimeException('Argument $css_data for "' . self::FQN . '::embedScript($css_data)" is not a valid string.');
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
        public function contentLanguage($lang = null) {
            if (is_null($lang)) {
                return $this->content_language;
            }
            if (!is_string($lang)) {
                throw new \RuntimeException(self::FQN . ' - invalid content-language value passed; not a string');
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
        public function meta($name, $value, $http_equiv = false) {
            if ($http_equiv) {
                $this->meta_http_equiv[$name][] = $value;
            } else {
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
        public function encoding($encoding) {
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
        public function favicon($image_path) {
            $this->fav_mimetype = Utils::getMimeTypeByExtension($image_path);
            $this->fav_path = $image_path;
        }
        /**
         * fqn
         *
         * @return self::FQN
         */
        private function fqn() {
            return static ::FQN;
        }
        public function base($href = null) {
            if (!isset($href)) {
                return $this->_base;
            }
            $this->_base = $href;
        }
        public function requireJsBaseUrl() {
            return '?!=-require' . (defined('APP_VERSION') ? '&v=' . APP_VERSION : '') . '&js=';
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__
BEGIN[CONFIG.JSON]
{
  "encoding":"utf-8",
  "enable-autoloader": true,
  "font":{
    "family":"robotoregular",
    "size":16
  }
}

END[CONFIG.JSON]

?>

<?php #HYPERCELL hcf.web.Container - BUILD 21.07.04#3251
namespace hcf\web;
class Container {
    use \hcf\core\dryver\Client, \hcf\core\dryver\Client\Js, \hcf\core\dryver\Config, Container\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Template, \hcf\core\dryver\Template\Xml, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container';
    const NAME = 'Container';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfwebContainer_onConstruct')) {
            call_user_func_array([$this, 'hcfwebContainer_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CLIENT.JS
    public static function script() {
        $js = "document.registerComponent=function(hcfqn,obj){var prop_hcfqn=hcfqn;var split=hcfqn.split('.')
var scope=window;var hcfqn=split.pop();var prop_name=hcfqn;for(var i in split){var part=split[i];if(!scope[part]){scope[part]={};}
scope=scope[part];}
obj.prototype=scope;obj.FQN=prop_hcfqn;obj.NAME=prop_name;scope[hcfqn]=obj;return scope[hcfqn];}
document.recursiveOffset=function(aobj){var currOffset={x:0,y:0}
var newOffset={x:0,y:0}
if(aobj!==null){if(aobj.scrollLeft){currOffset.x=aobj.scrollLeft;}
if(aobj.scrollTop){currOffset.y=aobj.scrollTop;}
if(aobj.offsetLeft){currOffset.x-=aobj.offsetLeft;}
if(aobj.offsetTop){currOffset.y-=aobj.offsetTop;}
if(aobj.parentNode!==undefined){newOffset=document.recursiveOffset(aobj.parentNode);}
currOffset.x=currOffset.x+newOffset.x;currOffset.y=currOffset.y+newOffset.y;}
return currOffset;}
function mouseMoved(e){if(typeof e=='undefined'||e==null){document.mouse={x:0,y:0};return;}
var doc=document.documentElement||document.body;var target=e.srcElement||e.target;var offsetpos=document.recursiveOffset(doc);pos_x=e.clientX+offsetpos.x;pos_y=e.clientY+offsetpos.y;document.mouse={x:pos_x,y:pos_y};}
document.onmousemove=mouseMoved;(function(\$){'use strict'
function safeAdd(x,y){var lsw=(x&0xFFFF)+(y&0xFFFF)
var msw=(x>>16)+(y>>16)+(lsw>>16)
return(msw<<16)|(lsw&0xFFFF)}
function bitRotateLeft(num,cnt){return(num<<cnt)|(num>>>(32-cnt))}
function md5cmn(q,a,b,x,s,t){return safeAdd(bitRotateLeft(safeAdd(safeAdd(a,q),safeAdd(x,t)),s),b)}
function md5ff(a,b,c,d,x,s,t){return md5cmn((b&c)|((~b)&d),a,b,x,s,t)}
function md5gg(a,b,c,d,x,s,t){return md5cmn((b&d)|(c&(~d)),a,b,x,s,t)}
function md5hh(a,b,c,d,x,s,t){return md5cmn(b^c^d,a,b,x,s,t)}
function md5ii(a,b,c,d,x,s,t){return md5cmn(c^(b|(~d)),a,b,x,s,t)}
function binlMD5(x,len){x[len>>5]|=0x80<<(len%32)
x[(((len+64)>>>9)<<4)+14]=len
var i
var olda
var oldb
var oldc
var oldd
var a=1732584193
var b=-271733879
var c=-1732584194
var d=271733878
for(i=0;i<x.length;i+=16){olda=a
oldb=b
oldc=c
oldd=d
a=md5ff(a,b,c,d,x[i],7,-680876936)
d=md5ff(d,a,b,c,x[i+1],12,-389564586)
c=md5ff(c,d,a,b,x[i+2],17,606105819)
b=md5ff(b,c,d,a,x[i+3],22,-1044525330)
a=md5ff(a,b,c,d,x[i+4],7,-176418897)
d=md5ff(d,a,b,c,x[i+5],12,1200080426)
c=md5ff(c,d,a,b,x[i+6],17,-1473231341)
b=md5ff(b,c,d,a,x[i+7],22,-45705983)
a=md5ff(a,b,c,d,x[i+8],7,1770035416)
d=md5ff(d,a,b,c,x[i+9],12,-1958414417)
c=md5ff(c,d,a,b,x[i+10],17,-42063)
b=md5ff(b,c,d,a,x[i+11],22,-1990404162)
a=md5ff(a,b,c,d,x[i+12],7,1804603682)
d=md5ff(d,a,b,c,x[i+13],12,-40341101)
c=md5ff(c,d,a,b,x[i+14],17,-1502002290)
b=md5ff(b,c,d,a,x[i+15],22,1236535329)
a=md5gg(a,b,c,d,x[i+1],5,-165796510)
d=md5gg(d,a,b,c,x[i+6],9,-1069501632)
c=md5gg(c,d,a,b,x[i+11],14,643717713)
b=md5gg(b,c,d,a,x[i],20,-373897302)
a=md5gg(a,b,c,d,x[i+5],5,-701558691)
d=md5gg(d,a,b,c,x[i+10],9,38016083)
c=md5gg(c,d,a,b,x[i+15],14,-660478335)
b=md5gg(b,c,d,a,x[i+4],20,-405537848)
a=md5gg(a,b,c,d,x[i+9],5,568446438)
d=md5gg(d,a,b,c,x[i+14],9,-1019803690)
c=md5gg(c,d,a,b,x[i+3],14,-187363961)
b=md5gg(b,c,d,a,x[i+8],20,1163531501)
a=md5gg(a,b,c,d,x[i+13],5,-1444681467)
d=md5gg(d,a,b,c,x[i+2],9,-51403784)
c=md5gg(c,d,a,b,x[i+7],14,1735328473)
b=md5gg(b,c,d,a,x[i+12],20,-1926607734)
a=md5hh(a,b,c,d,x[i+5],4,-378558)
d=md5hh(d,a,b,c,x[i+8],11,-2022574463)
c=md5hh(c,d,a,b,x[i+11],16,1839030562)
b=md5hh(b,c,d,a,x[i+14],23,-35309556)
a=md5hh(a,b,c,d,x[i+1],4,-1530992060)
d=md5hh(d,a,b,c,x[i+4],11,1272893353)
c=md5hh(c,d,a,b,x[i+7],16,-155497632)
b=md5hh(b,c,d,a,x[i+10],23,-1094730640)
a=md5hh(a,b,c,d,x[i+13],4,681279174)
d=md5hh(d,a,b,c,x[i],11,-358537222)
c=md5hh(c,d,a,b,x[i+3],16,-722521979)
b=md5hh(b,c,d,a,x[i+6],23,76029189)
a=md5hh(a,b,c,d,x[i+9],4,-640364487)
d=md5hh(d,a,b,c,x[i+12],11,-421815835)
c=md5hh(c,d,a,b,x[i+15],16,530742520)
b=md5hh(b,c,d,a,x[i+2],23,-995338651)
a=md5ii(a,b,c,d,x[i],6,-198630844)
d=md5ii(d,a,b,c,x[i+7],10,1126891415)
c=md5ii(c,d,a,b,x[i+14],15,-1416354905)
b=md5ii(b,c,d,a,x[i+5],21,-57434055)
a=md5ii(a,b,c,d,x[i+12],6,1700485571)
d=md5ii(d,a,b,c,x[i+3],10,-1894986606)
c=md5ii(c,d,a,b,x[i+10],15,-1051523)
b=md5ii(b,c,d,a,x[i+1],21,-2054922799)
a=md5ii(a,b,c,d,x[i+8],6,1873313359)
d=md5ii(d,a,b,c,x[i+15],10,-30611744)
c=md5ii(c,d,a,b,x[i+6],15,-1560198380)
b=md5ii(b,c,d,a,x[i+13],21,1309151649)
a=md5ii(a,b,c,d,x[i+4],6,-145523070)
d=md5ii(d,a,b,c,x[i+11],10,-1120210379)
c=md5ii(c,d,a,b,x[i+2],15,718787259)
b=md5ii(b,c,d,a,x[i+9],21,-343485551)
a=safeAdd(a,olda)
b=safeAdd(b,oldb)
c=safeAdd(c,oldc)
d=safeAdd(d,oldd)}
return[a,b,c,d]}
function binl2rstr(input){var i
var output=''
var length32=input.length*32
for(i=0;i<length32;i+=8){output+=String.fromCharCode((input[i>>5]>>>(i%32))&0xFF)}
return output}
function rstr2binl(input){var i
var output=[]
output[(input.length>>2)-1]=undefined
for(i=0;i<output.length;i+=1){output[i]=0}
var length8=input.length*8
for(i=0;i<length8;i+=8){output[i>>5]|=(input.charCodeAt(i / 8)&0xFF)<<(i%32)}
return output}
function rstrMD5(s){return binl2rstr(binlMD5(rstr2binl(s),s.length*8))}
function rstrHMACMD5(key,data){var i
var bkey=rstr2binl(key)
var ipad=[]
var opad=[]
var hash
ipad[15]=opad[15]=undefined
if(bkey.length>16){bkey=binlMD5(bkey,key.length*8)}
for(i=0;i<16;i+=1){ipad[i]=bkey[i]^0x36363636
opad[i]=bkey[i]^0x5C5C5C5C}
hash=binlMD5(ipad.concat(rstr2binl(data)),512+data.length*8)
return binl2rstr(binlMD5(opad.concat(hash),512+128))}
function rstr2hex(input){var hexTab='0123456789abcdef'
var output=''
var x
var i
for(i=0;i<input.length;i+=1){x=input.charCodeAt(i)
output+=hexTab.charAt((x>>>4)&0x0F)+
hexTab.charAt(x&0x0F)}
return output}
function str2rstrUTF8(input){return unescape(encodeURIComponent(input))}
function rawMD5(s){return rstrMD5(str2rstrUTF8(s))}
function hexMD5(s){return rstr2hex(rawMD5(s))}
function rawHMACMD5(k,d){return rstrHMACMD5(str2rstrUTF8(k),str2rstrUTF8(d))}
function hexHMACMD5(k,d){return rstr2hex(rawHMACMD5(k,d))}
function md5(string,key,raw){if(!key){if(!raw){return hexMD5(string)}
return rawMD5(string)}
if(!raw){return hexHMACMD5(key,string)}
return rawHMACMD5(key,string)}
if(typeof define==='function'&&define.amd){define(function(){return md5})}else if(typeof module==='object'&&module.exports){module.exports=md5}else{\$.md5=md5}}(this))";
        return $js;
    }
    # END ASSEMBLY FRAME CLIENT.JS
    # BEGIN ASSEMBLY FRAME CONFIG.JSON
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'JSON');
        self::$config = json_decode($content);
    }
    # END ASSEMBLY FRAME CONFIG.JSON
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "<!DOCTYPE html>
{$__CLASS__::_call('stdTpl', $__CLASS__, $_this) }
";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    # BEGIN ASSEMBLY FRAME TEMPLATE.XML
    public function stdTpl() {
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
        $output.= "<script language=\"javascript\">{$__CLASS__::_call('script', $__CLASS__, $_this) }</script>";
        foreach ($__CLASS__::_property('emb_js', $__CLASS__, $_this) as $emb_js_str) {
            $output.= "<script language=\"javascript\">$emb_js_str</script>";
        }
        foreach ($__CLASS__::_property('emb_css', $__CLASS__, $_this) as $emb_css_str) {
            $output.= "<style>$emb_css_str</style>";
        }
        $output.= "<style>body { font-family:'{$__CLASS__::_property('font_family', $__CLASS__, $_this) }'!important; font-size:{$__CLASS__::_property('font_size', $__CLASS__, $_this) }!important;}</style>";
        $output.= "{$__CLASS__::_call('autoloader', $__CLASS__, $_this) }";
        $output.= "</head>";
        $output.= "<body>{$__CLASS__::_property('content', $__CLASS__, $_this) }</body>";
        $output.= "</html>";
        return self::_postProcess($output, [], []);
    }
    # END ASSEMBLY FRAME TEMPLATE.XML
    
    }
    namespace hcf\web\Container\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
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
        /**
         * __construct
         *
         * @param autoload - boolean - optional - enable the autoloader for this instance (true) or not (false)
         */
        public function hcfwebContainer_onConstruct($autoload = null) {
            $config = self::config();
            if (isset($config)) {
                if (isset($config->font) && is_object($config->font)) {
                    $this->font($config->font->family);
                    $this->fontSize($config->font->size);
                }
                if (isset($autoload)) {
                    $this->autoloading = $autoload;
                } else if (isset($config->{'enable-autoloader'}) && is_bool($config->{'enable-autoloader'})) {
                    $this->autoloading = $config->{'enable-autoloader'};
                }
                if (isset($config->encoding) && is_string($config->encoding)) {
                    $this->encoding($config->encoding);
                }
                if (isset($config->{'fav-icon'}) && is_string($config->{'fav-icon'})) {
                    $this->favicon($config->{'fav-icon'});
                }
            }
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
        public function fqn() {
            return self::FQN;
        }
        /**
         * autoloader
         * Loads the Autoloader - if enabled (over the constructor of this instance)
         *
         * @return string - Autoloader output-channel
         */
        public function autoloader() {
            if ($this->autoloading) {
                try {
                    $class = __CLASS__ . '\\Autoloader';
                    $autoloader = new $class();
                    return $autoloader->toString();
                }
                catch(\FileNotFoundException $e) {
                    header(Utils::getHTTPHeader(404));
                    throw $e;
                }
            }
            return '';
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



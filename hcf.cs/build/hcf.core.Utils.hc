<?php #HYPERCELL hcf.core.Utils - BUILD 21.01.27#166
namespace hcf\core;
class Utils {
    use \hcf\core\dryver\Config, Utils\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.core.Utils';
    const NAME = 'Utils';
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
    
    }
    namespace hcf\core\Utils\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * Utils
     * A collection of static-methods, used across the framework
     *
     * @category Utils
     * @package rmf.core
     * @author Philipp Kopf
     */
    trait Controller {
        /**
         * cutTrailingSlash
         * Cut of the trailing "/" of a given path
         *
         * @param $path - string - the path where the trailing slash should be removed
         *
         * @return string - the path without the trailing slash
         */
        public static function cutTrailingSlash($path) {
            if (strlen($path) > 2 && substr($path, -1) == '/') {
                $path = substr($path, 0, strlen($path) - 1);
            }
            return $path;
        }
        /**
         * cleanPath
         * Replaces backslashes with slashes and remove multiple slashes with a single one
         *
         * @param $path - string - the path to clean
         *
         * @return string - the cleaned path
         */
        public static function cleanPath($path) {
            // replace backslashes with slashes
            $path = str_replace('\\', '/', $path);
            // remove multiple slashes
            $path = preg_replace('/\/+/', '/', $path);
            // and done
            return $path;
        }
        /**
         * isValidRMFQN
         * Checks, if a given string is a valid raw-merge full-qualified-name
         *
         * @param $rmfqn - string - the rmfqn which should be checked
         *
         * @return boolean - true, if the given rmfqn is valid, false if not
         */
        public static function isValidRMFQN($rmfqn) {
            $regex = '/^([a-zA-Z0-9\._]+)$/';
            $result = preg_match($regex, $rmfqn);
            if ($result === 1) {
                return true;
            } else if ($result === false) {
                throw new \RuntimeException('An error occured while checking "' . $rmfqn . '" against regex ' . $regex);
            } else {
                return false;
            }
        }
        /**
         * pathToRMName
         * Converts a given path to a raw-merge name
         *
         * @param $path - string - the path to convert
         *
         * @return string - the path, converted to a raw-merge name
         */
        public static function pathToRMName($path) {
            //First, remove all non-classname-conform chars (excepts \ and /)
            $path = preg_replace('~[^\\w/\\\\]+~i', '', $path);
            // And now convert all back-/slashes to dots
            $path = str_replace('/', '.', str_replace('\\', '/', $path));
            // Cut off dots at the beginning/end
            $path = trim($path, '.');
            return $path;
        }
        /**
         * pathToHCName
         * Converts a given path to a hypercell-name
         *
         * @param $path - string - the path to convert
         *
         * @return string - the path, converted to a raw-merge name
         */
        public static function pathToHCName($path) {
            //First, remove all non-classname-conform chars (excepts \ and /)
            $path = preg_replace('~[^\\w/\\\\]+~i', '', $path);
            // And now convert all back-/slashes to dots
            $path = str_replace('/', '.', str_replace('\\', '/', $path));
            // Cut off dots at the beginning/end
            $path = trim($path, '.');
            return $path;
        }
        /**
         * HCFQN2PHPFQN
         * HyperCellFullQualifiedName2PHPFullQualifiedName
         * Converts a HCFQN (FQN with dots) to a PHPFQN (FQN with backslashes)
         *
         * @param $hypercell_fqn - string - the full-qualified-name which should be converted to a PHPFQN
         *
         * @return string - the RMFQN converted to a PHPFQN
         */
        public static function HCFQN2PHPFQN($hypercell_fqn) {
            $php_fqn = str_replace('.', '\\', $hypercell_fqn);
            return $php_fqn;
        }
        /**
         * PHPFQN2HCFQN
         * PHPFullQualifiedName2HyperCellFullQualifiedName
         * Converts a PHPFQN (FQN with backslashes) to a HCFQN (FQN with dots)
         *
         * @param $php_fqn - string - the full-qualified-name which should be converted to a HCFQN
         *
         * @return string - the PHPFQN converted to a HCFQN
         */
        public static function PHPFQN2HCFQN($php_fqn) {
            $hc_fqn = str_replace('\\', '.', $php_fqn);
            return $hc_fqn;
        }
        /**
         * newLine
         * Adds a line-break to a string
         *
         * @return string - a line-break
         */
        public static function newLine() {
            return "\r\n";
        }
        /**
         * getAllSubDirectories
         * Iterates over a given directory recursively to collect all contained directories
         *
         * @param $directory - string - the directory where all sub-directories should be found
         * @param $directory_seperator - string - optional - specifies which character should be used, to split the directory-path
         *
         * @return array - an array, filled with all found directories inside $directory
         */
        public static function getAllSubDirectories($directory, $directory_seperator = '/') {
            $dirs = array_map(function ($item) use ($directory_seperator) {
                return $item . $directory_seperator;
            }, array_filter(glob($directory . '*'), 'is_dir'));
            foreach ($dirs as $dir) {
                $dirs = array_merge($dirs, self::getAllSubDirectories($dir, $directory_seperator));
            }
            return $dirs;
        }
        /**
         * getFilesByExtension
         * Get all files recursively, starting from a given directory, which have a specified file-extension
         *
         * @param $extension - string/array - the file-extension/-s which should be searched; WITHOUT the "."
         * @param $dir - string - the directory, the search starts from
         *
         * @throws UnexpectedValueException, DirectoryNotFoundException
         * @return array - containing the full filepath for each file with the given extension
         */
        public static function getFilesByExtension($extension, $dir) {
            $files = [];
            if (is_array($extension)) {
                foreach ($extension as $key => $value) {
                    $new_files = self::getFilesByExtension($value, $dir);
                    $files = array_merge($files, $new_files);
                }
                return $files;
            }
            if (!is_string($extension)) {
                throw new \UnexpectedValueException('Argument $extension is not a string.');
            }
            if (!isset($dir) && !file_exists($dir)) {
                throw new \DirectoryNotFoundException('Directory "' . $dir . '" does not exist.');
            }
            if (substr($extension, 0, 1) === '.') {
                // Cut off the dot
                $extension = substr($extension, 1);
            }
            $directory = new \RecursiveDirectoryIterator($dir);
            $iterator = new \RecursiveIteratorIterator($directory);
            $regex = new \RegexIterator($iterator, '/^.+\.' . $extension . '$/i', \RecursiveRegexIterator::GET_MATCH);
            foreach ($regex as $k => $v) {
                $files[] = $k;
            }
            return $files;
        }
        /**
         * getOffset
         * Make a path relative to another
         *
         * @param $absolute_path - string - the path which should made relative, e.g. $absolute_path = "/path/to/some/thing/"
         * @param $absolute_origin - string - must be identical to beginning-part of $absolute_path, e.g. $absolute_origin = "/path/to/"
         *
         * @throws UnexpectedValueException
         * @return string - the absolute path, relative to the absolute origin, e.g. "some/thing/"
         */
        public static function getOffset($absolute_path, $absolute_origin) {
            // clean paths first
            $absolute_path = realpath(self::cleanPath($absolute_path));
            $absolute_origin = realpath(self::cleanPath($absolute_origin));
            $pos = strpos($absolute_path, $absolute_origin);
            if ($pos === false) {
                throw new \UnexpectedValueException('Origin "' . $absolute_origin . '" is not part of path "' . $absolute_path . '"');
            }
            $out = substr($absolute_path, $pos + strlen($absolute_origin));
            if (substr($out, 0, 1) === '/') {
                // remove / at beginning, to make it relative to the absolute origin
                $out = substr($out, 1);
            }
            return $out;
        }
        /**
         * buildPath
         * Build a path on the filesystem recursively
         *
         * @param $path - string - the path which should be build
         * @param $rights - int - optional - the permissions the new directories should get
         *
         * @throws RuntimeException
         * @return void
         */
        public static function buildPath($path, $rights = 0755) {
            $path = self::cleanPath($path);
            if (is_dir($path)) {
                // If path already exists, we have nothing to do here.
                return;
            }
            // somehow, recursive mkdir doesn't work on xampp and mac
            $path = str_replace('\\', '/', $path);
            $dirs = explode('/', $path);
            $dir = '';
            foreach ($dirs as $part) {
                $dir.= $part . '/';
                if (!is_dir($dir) && strlen($dir) > 0) {
                    // http://stackoverflow.com/questions/6229353/permissions-with-mkdir-wont-work
                    $old = umask(0);
                    if (!(mkdir($dir))) {
                        throw new \RuntimeException('Unable to create path "' . $path . '" in "' . getcwd() . '".');
                    }
                    chmod($dir, (int)$rights);
                    umask($old);
                }
            }
        }
        /**
         * HCFQNtoPath
         * Converts a full-qualified-name of a hypercell to a (theoretical) file-path
         *
         * @param $hcfqn - string - the FQN which should be converted into a path
         * @param $cut_first - boolean - useful if path should be used for cellspaces
         *
         * @return string - the converted FQN as path
         */
        public static function HCFQNtoPath($hcfqn, $cut_first = false) {
            $out = str_replace('.', '/', $hcfqn);
            if ($cut_first) {
                $a = explode('/', $out);
                $a = array_slice($a, 1);
                $out = implode('/', $a);
            }
            return $out;
        }
        /**
         * getMimeTypeByExtension
         * Returns the MIME-type for a given file-extension
         *
         * @param $filename - string - the file-extension for the MIME-type you want to find
         *
         * @return string - the MIME-type the given file-extension is associated with
         */
        public static function getMimeTypeByExtension($filename) {
            $extension = substr($filename, strpos($filename, '.') + 1);
            $extension = strtolower($extension);
            if (isset(self::config()->MIME->{$extension})) {
                return self::config()->MIME->{$extension};
            }
            return null;
        }
        /**
         * getHTTPHeader
         * Get the header string (for PHP's header(...) function) for a given http-response-code
         *
         * @param $code - int - the code which should be translated to a header string
         *
         * @throws RuntimeException
         * @return string - the given http code as header string
         */
        public static function getHTTPHeader($code) {
            if (!isset(self::config()->HTTP->{$code})) {
                throw new \RuntimeException('No header definition found for HTTP-code ' . $code . '.');
            }
            return self::config()->HTTP->{$code};
        }
        /**
         * loadScript
         * Loads a given PHP-file by PHPs "require" function and returns an array,
         * containing classes, which where loaded trough this file
         *
         * @param $file - string - the path to the PHP-script, you want to load
         *
         * @throws FileNotFoundException
         * @return array - each index is a class, loaded trough this method-execution
         */
        public static function loadScript($file) {
            if (!file_exists($file)) {
                throw new \FileNotFoundException('File "' . $file . '" does not exist');
            }
            $before = get_declared_classes();
            require_once $file;
            $after = get_declared_classes();
            $diff = array_diff($after, $before);
            return $diff;
        }
        /**
         * removePath
         * Removes a given path recursively - no matter if it's a directory or file
         *
         * @param $path - string - the path you want to remove from your filesystem
         *
         * @throws Exception
         * @return void
         */
        public static function removePath($path) {
            $iterator = new \DirectoryIterator($path);
            foreach ($iterator as $fileinfo) {
                if ($fileinfo->isDot()) {
                    continue;
                }
                if ($fileinfo->isDir()) {
                    self::removePath($fileinfo->getPathname());
                    @rmdir($fileinfo->getPathname());
                }
                if ($fileinfo->isFile()) {
                    @unlink($fileinfo->getPathname());
                }
            }
            @rmdir($path);
        }
        /**
         * copyPath
         * Copies a given path recursively - no matter if it's a directory or file
         *
         * @param $src - string - the path you want to copy
         * @param $dst - string - the destination directory of the copy
         * @param $exc - array - names that won't be copied
         * @throws Exception
         * @return void
         */
        public static function copyPath($src, $dst, $exc = null) {
            $exc = $exc ? : [];
            $dir = opendir($src);
            @mkdir($dst);
            while (false !== ($file = readdir($dir))) {
                if (($file != '.') && ($file != '..') && !in_array($file, $exc)) {
                    if (is_dir($src . '/' . $file)) {
                        self::copyPath($src . '/' . $file, $dst . '/' . $file);
                    } else {
                        copy($src . '/' . $file, $dst . '/' . $file);
                    }
                }
            }
            closedir($dir);
        }
        /**
         * isEmptyDirectory
         * Check, if a given directory contains files, except hidden and system files
         * like Thumbs.db or .DS_Store
         *
         * @param $dir - string - the directory to check
         *
         * @return boolean - true if no non-system files were found inside this directory, otherwise false
         */
        public static function isEmptyDirectory($dir) {
            $contents = scandir($dir);
            $bad = self::config()->{'system-files'};
            $files = array_diff($contents, $bad);
            return (!count($files) ? true : false);
        }
        /**
         * isValidAsName
         * Check, if a given string can be used as variable/function name
         * NOTICE: Source http://stackoverflow.com/a/3980179
         *
         * @param $string - string - the string that should be checked
         *
         * @return boolean - true, if it can be used as variable/function name, otherwise false
         */
        public static function isValidAsName($string) {
            return ((preg_match('/^[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*$/', $string)) ? true : false);
        }
        /**
         * parseByteString
         * Converts e.g. an php.ini file-size string like 8M or 19mb to it's int value in bytes
         * NOTICE: Source http://php.net/manual/de/function.ini-get.php#106518
         *
         * @param $val - string - the file-size string to convert
         *
         * @return int - bytes which are represented by the input file-size string
         */
        public static function parseByteString($val) {
            if (empty($val)) {
                return 0;
            }
            $val = trim($val);
            preg_match('#([0-9]+)[\s]*([a-z]+)#i', $val, $matches);
            $last = '';
            if (isset($matches[2])) {
                $last = $matches[2];
            }
            if (isset($matches[1])) {
                $val = (int)$matches[1];
            }
            switch (strtolower($last)) {
                case 'g':
                case 'gb':
                    $val*= 1024;
                case 'm':
                case 'mb':
                    $val*= 1024;
                case 'k':
                case 'kb':
                    $val*= 1024;
            }
            return (int)$val;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

system-files = [".", "..", ".DS_Store", "_notes", "Thumbs.db"]; for Utils::isEmptyDirectory

[HTTP]
100 = "HTTP/1.1 100 Continue"
101 = "HTTP/1.1 101 Switching Protocols"
200 = "HTTP/1.1 200 OK"
201 = "HTTP/1.1 201 Created"
202 = "HTTP/1.1 202 Accepted"
203 = "HTTP/1.1 203 Non-Authoritative Information"
204 = "HTTP/1.1 204 No Content"
205 = "HTTP/1.1 205 Reset Content"
206 = "HTTP/1.1 206 Partial Content"
300 = "HTTP/1.1 300 Multiple Choices"
301 = "HTTP/1.1 301 Moved Permanently"
302 = "HTTP/1.1 302 Found"
303 = "HTTP/1.1 303 See Other"
304 = "HTTP/1.1 304 Not Modified"
305 = "HTTP/1.1 305 Use Proxy"
307 = "HTTP/1.1 307 Temporary Redirect"
400 = "HTTP/1.1 400 Bad Request"
401 = "HTTP/1.1 401 Unauthorized"
402 = "HTTP/1.1 402 Payment Required"
403 = "HTTP/1.1 403 Forbidden"
404 = "HTTP/1.1 404 Not Found"
405 = "HTTP/1.1 405 Method Not Allowed"
406 = "HTTP/1.1 406 Not Acceptable"
407 = "HTTP/1.1 407 Proxy Authentication Required"
408 = "HTTP/1.1 408 Request Time-out"
409 = "HTTP/1.1 409 Conflict"
410 = "HTTP/1.1 410 Gone"
411 = "HTTP/1.1 411 Length Required"
412 = "HTTP/1.1 412 Precondition Failed"
413 = "HTTP/1.1 413 Request Entity Too Large"
414 = "HTTP/1.1 414 Request-URI Too Large"
415 = "HTTP/1.1 415 Unsupported Media Type"
416 = "HTTP/1.1 416 Requested range not satisfiable"
417 = "HTTP/1.1 417 Expectation Failed"
500 = "HTTP/1.1 500 Internal Server Error"
501 = "HTTP/1.1 501 Not Implemented"
502 = "HTTP/1.1 502 Bad Gateway"
503 = "HTTP/1.1 503 Service Unavailable"
504 = "HTTP/1.1 504 Gateway Time-out"

[MIME]
; Source: https://gist.github.com/Erutan409/8e774dfb2b343fe78b14#file-mimetype-php

3dml	= "text/vnd.in3d.3dml"
3g2	= "video/3gpp2"
3gp	= "video/3gpp"
7z	= "application/x-7z-compressed"
aab	= "application/x-authorware-bin"
aac	= "audio/x-aac"
aam	= "application/x-authorware-map"
aas	= "application/x-authorware-seg"
abw	= "application/x-abiword"
ac	= "application/pkix-attr-cert"
acc	= "application/vnd.americandynamics.acc"
ace	= "application/x-ace-compressed"
acu	= "application/vnd.acucobol"
adp	= "audio/adpcm"
aep	= "application/vnd.audiograph"
afp	= "application/vnd.ibm.modcap"
ahead	= "application/vnd.ahead.space"
ai	= "application/postscript"
aif	= "audio/x-aiff"
air	= "application/vnd.adobe.air-application-installer-package+zip"
ait	= "application/vnd.dvb.ait"
ami	= "application/vnd.amiga.ami"
apk	= "application/vnd.android.package-archive"
application	= "application/x-ms-application"
apr	= "application/vnd.lotus-approach"
asf	= "video/x-ms-asf"
aso	= "application/vnd.accpac.simply.aso"
atc	= "application/vnd.acucorp"
atom	= "application/atom+xml"
atomcat	= "application/atomcat+xml"
atomsvc	= "application/atomsvc+xml"
atx	= "application/vnd.antix.game-component"
au	= "audio/basic"
avi	= "video/x-msvideo"
aw	= "application/applixware"
azf	= "application/vnd.airzip.filesecure.azf"
azs	= "application/vnd.airzip.filesecure.azs"
azw	= "application/vnd.amazon.ebook"
bcpio	= "application/x-bcpio"
bdf	= "application/x-font-bdf"
bdm	= "application/vnd.syncml.dm+wbxml"
bed	= "application/vnd.realvnc.bed"
bh2	= "application/vnd.fujitsu.oasysprs"
bin	= "application/octet-stream"
bmi	= "application/vnd.bmi"
bmp	= "image/bmp"
box	= "application/vnd.previewsystems.box"
btif	= "image/prs.btif"
bz	= "application/x-bzip"
bz2	= "application/x-bzip2"
c	= "text/x-c"
c11amc	= "application/vnd.cluetrust.cartomobile-config"
c11amz	= "application/vnd.cluetrust.cartomobile-config-pkg"
c4g	= "application/vnd.clonk.c4group"
cab	= "application/vnd.ms-cab-compressed"
car	= "application/vnd.curl.car"
cat	= "application/vnd.ms-pki.seccat"
ccxml	= "application/ccxml+xml,"
cdbcmsg	= "application/vnd.contact.cmsg"
cdkey	= "application/vnd.mediastation.cdkey"
cdmia	= "application/cdmi-capability"
cdmic	= "application/cdmi-container"
cdmid	= "application/cdmi-domain"
cdmio	= "application/cdmi-object"
cdmiq	= "application/cdmi-queue"
cdx	= "chemical/x-cdx"
cdxml	= "application/vnd.chemdraw+xml"
cdy	= "application/vnd.cinderella"
cer	= "application/pkix-cert"
cgm	= "image/cgm"
chat	= "application/x-chat"
chm	= "application/vnd.ms-htmlhelp"
chrt	= "application/vnd.kde.kchart"
cif	= "chemical/x-cif"
cii	= "application/vnd.anser-web-certificate-issue-initiation"
cil	= "application/vnd.ms-artgalry"
cla	= "application/vnd.claymore"
class	= "application/java-vm"
clkk	= "application/vnd.crick.clicker.keyboard"
clkp	= "application/vnd.crick.clicker.palette"
clkt	= "application/vnd.crick.clicker.template"
clkw	= "application/vnd.crick.clicker.wordbank"
clkx	= "application/vnd.crick.clicker"
clp	= "application/x-msclip"
cmc	= "application/vnd.cosmocaller"
cmdf	= "chemical/x-cmdf"
cml	= "chemical/x-cml"
cmp	= "application/vnd.yellowriver-custom-menu"
cmx	= "image/x-cmx"
cod	= "application/vnd.rim.cod"
cpio	= "application/x-cpio"
cpt	= "application/mac-compactpro"
crd	= "application/x-mscardfile"
crl	= "application/pkix-crl"
cryptonote	= "application/vnd.rig.cryptonote"
csh	= "application/x-csh"
csml	= "chemical/x-csml"
csp	= "application/vnd.commonspace"
css	= "text/css"
csv	= "text/csv"
cu	= "application/cu-seeme"
curl	= "text/vnd.curl"
cww	= "application/prs.cww"
dae	= "model/vnd.collada+xml"
daf	= "application/vnd.mobius.daf"
davmount	= "application/davmount+xml"
dcurl	= "text/vnd.curl.dcurl"
dd2	= "application/vnd.oma.dd2+xml"
ddd	= "application/vnd.fujixerox.ddd"
deb	= "application/x-debian-package"
der	= "application/x-x509-ca-cert"
dfac	= "application/vnd.dreamfactory"
dir	= "application/x-director"
dis	= "application/vnd.mobius.dis"
djvu	= "image/vnd.djvu"
dna	= "application/vnd.dna"
doc	= "application/msword"
docm	= "application/vnd.ms-word.document.macroenabled.12"
docx	= "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
dotm	= "application/vnd.ms-word.template.macroenabled.12"
dotx	= "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
dp	= "application/vnd.osgi.dp"
dpg	= "application/vnd.dpgraph"
dra	= "audio/vnd.dra"
dsc	= "text/prs.lines.tag"
dssc	= "application/dssc+der"
dtb	= "application/x-dtbook+xml"
dtd	= "application/xml-dtd"
dts	= "audio/vnd.dts"
dtshd	= "audio/vnd.dts.hd"
dvi	= "application/x-dvi"
dwf	= "model/vnd.dwf"
dwg	= "image/vnd.dwg"
dxf	= "image/vnd.dxf"
dxp	= "application/vnd.spotfire.dxp"
ecelp4800	= "audio/vnd.nuera.ecelp4800"
ecelp7470	= "audio/vnd.nuera.ecelp7470"
ecelp9600	= "audio/vnd.nuera.ecelp9600"
edm	= "application/vnd.novadigm.edm"
edx	= "application/vnd.novadigm.edx"
efif	= "application/vnd.picsel"
ei6	= "application/vnd.pg.osasli"
eml	= "message/rfc822"
emma	= "application/emma+xml"
eol	= "audio/vnd.digital-winds"
eot	= "application/vnd.ms-fontobject"
epub	= "application/epub+zip"
es	= "application/ecmascript"
es3	= "application/vnd.eszigno3+xml"
esf	= "application/vnd.epson.esf"
etx	= "text/x-setext"
exe	= "application/x-msdownload"
exi	= "application/exi"
ext	= "application/vnd.novadigm.ext"
ez2	= "application/vnd.ezpix-album"
ez3	= "application/vnd.ezpix-package"
f	= "text/x-fortran"
f4v	= "video/x-f4v"
fbs	= "image/vnd.fastbidsheet"
fcs	= "application/vnd.isac.fcs"
fdf	= "application/vnd.fdf"
fe_launch	= "application/vnd.denovo.fcselayout-link"
fg5	= "application/vnd.fujitsu.oasysgp"
fh	= "image/x-freehand"
fig	= "application/x-xfig"
fli	= "video/x-fli"
flo	= "application/vnd.micrografx.flo"
flv	= "video/x-flv"
flw	= "application/vnd.kde.kivio"
flx	= "text/vnd.fmi.flexstor"
fly	= "text/vnd.fly"
fm	= "application/vnd.framemaker"
fnc	= "application/vnd.frogans.fnc"
fpx	= "image/vnd.fpx"
fsc	= "application/vnd.fsc.weblaunch"
fst	= "image/vnd.fst"
ftc	= "application/vnd.fluxtime.clip"
fti	= "application/vnd.anser-web-funds-transfer-initiation"
fvt	= "video/vnd.fvt"
fxp	= "application/vnd.adobe.fxp"
fzs	= "application/vnd.fuzzysheet"
g2w	= "application/vnd.geoplan"
g3	= "image/g3fax"
g3w	= "application/vnd.geospace"
gac	= "application/vnd.groove-account"
gdl	= "model/vnd.gdl"
geo	= "application/vnd.dynageo"
gex	= "application/vnd.geometry-explorer"
ggb	= "application/vnd.geogebra.file"
ggt	= "application/vnd.geogebra.tool"
ghf	= "application/vnd.groove-help"
gif	= "image/gif"
gim	= "application/vnd.groove-identity-message"
gmx	= "application/vnd.gmx"
gnumeric	= "application/x-gnumeric"
gph	= "application/vnd.flographit"
gqf	= "application/vnd.grafeq"
gram	= "application/srgs"
grv	= "application/vnd.groove-injector"
grxml	= "application/srgs+xml"
gsf	= "application/x-font-ghostscript"
gtar	= "application/x-gtar"
gtm	= "application/vnd.groove-tool-message"
gtw	= "model/vnd.gtw"
gv	= "text/vnd.graphviz"
gxt	= "application/vnd.geonext"
h261	= "video/h261"
h263	= "video/h263"
h264	= "video/h264"
hal	= "application/vnd.hal+xml"
hbci	= "application/vnd.hbci"
hdf	= "application/x-hdf"
hlp	= "application/winhlp"
hpgl	= "application/vnd.hp-hpgl"
hpid	= "application/vnd.hp-hpid"
hps	= "application/vnd.hp-hps"
hqx	= "application/mac-binhex40"
htke	= "application/vnd.kenameaapp"
html	= "text/html"
hvd	= "application/vnd.yamaha.hv-dic"
hvp	= "application/vnd.yamaha.hv-voice"
hvs	= "application/vnd.yamaha.hv-script"
i2g	= "application/vnd.intergeo"
icc	= "application/vnd.iccprofile"
ice	= "x-conference/x-cooltalk"
ico	= "image/x-icon"
ics	= "text/calendar"
ief	= "image/ief"
ifm	= "application/vnd.shana.informed.formdata"
igl	= "application/vnd.igloader"
igm	= "application/vnd.insors.igm"
igs	= "model/iges"
igx	= "application/vnd.micrografx.igx"
iif	= "application/vnd.shana.informed.interchange"
imp	= "application/vnd.accpac.simply.imp"
ims	= "application/vnd.ms-ims"
ipfix	= "application/ipfix"
ipk	= "application/vnd.shana.informed.package"
irm	= "application/vnd.ibm.rights-management"
irp	= "application/vnd.irepository.package+xml"
itp	= "application/vnd.shana.informed.formtemplate"
ivp	= "application/vnd.immervision-ivp"
ivu	= "application/vnd.immervision-ivu"
jad	= "text/vnd.sun.j2me.app-descriptor"
jam	= "application/vnd.jam"
jar	= "application/java-archive"
java	= "text/x-java-source,java"
jisp	= "application/vnd.jisp"
jlt	= "application/vnd.hp-jlyt"
jnlp	= "application/x-java-jnlp-file"
joda	= "application/vnd.joost.joda-archive"
jpeg	= "image/jpeg"
jpg	= "image/jpeg"
jpgv	= "video/jpeg"
jpm	= "video/jpm"
js	= "application/javascript"
json	= "application/json"
karbon	= "application/vnd.kde.karbon"
kfo	= "application/vnd.kde.kformula"
kia	= "application/vnd.kidspiration"
kml	= "application/vnd.google-earth.kml+xml"
kmz	= "application/vnd.google-earth.kmz"
kne	= "application/vnd.kinar"
kon	= "application/vnd.kde.kontour"
kpr	= "application/vnd.kde.kpresenter"
ksp	= "application/vnd.kde.kspread"
ktx	= "image/ktx"
ktz	= "application/vnd.kahootz"
kwd	= "application/vnd.kde.kword"
lasxml	= "application/vnd.las.las+xml"
latex	= "application/x-latex"
lbd	= "application/vnd.llamagraphics.life-balance.desktop"
lbe	= "application/vnd.llamagraphics.life-balance.exchange+xml"
les	= "application/vnd.hhe.lesson-player"
link66	= "application/vnd.route66.link66+xml"
lrm	= "application/vnd.ms-lrm"
ltf	= "application/vnd.frogans.ltf"
lvp	= "audio/vnd.lucent.voice"
lwp	= "application/vnd.lotus-wordpro"
m21	= "application/mp21"
m3u	= "audio/x-mpegurl"
m3u8	= "application/vnd.apple.mpegurl"
m4v	= "video/x-m4v"
ma	= "application/mathematica"
mads	= "application/mads+xml"
mag	= "application/vnd.ecowin.chart"
mathml	= "application/mathml+xml"
mbk	= "application/vnd.mobius.mbk"
mbox	= "application/mbox"
mc1	= "application/vnd.medcalcdata"
mcd	= "application/vnd.mcd"
mcurl	= "text/vnd.curl.mcurl"
mdb	= "application/x-msaccess"
mdi	= "image/vnd.ms-modi"
meta4	= "application/metalink4+xml"
mets	= "application/mets+xml"
mfm	= "application/vnd.mfmp"
mgp	= "application/vnd.osgeo.mapguide.package"
mgz	= "application/vnd.proteus.magazine"
mid	= "audio/midi"
mif	= "application/vnd.mif"
mj2	= "video/mj2"
mlp	= "application/vnd.dolby.mlp"
mmd	= "application/vnd.chipnuts.karaoke-mmd"
mmf	= "application/vnd.smaf"
mmr	= "image/vnd.fujixerox.edmics-mmr"
mny	= "application/x-msmoney"
mods	= "application/mods+xml"
movie	= "video/x-sgi-movie"
mp4	= "video/mp4"
mp4a	= "audio/mp4"
mpc	= "application/vnd.mophun.certificate"
mpeg	= "video/mpeg"
mpga	= "audio/mpeg"
mpkg	= "application/vnd.apple.installer+xml"
mpm	= "application/vnd.blueice.multipass"
mpn	= "application/vnd.mophun.application"
mpp	= "application/vnd.ms-project"
mpy	= "application/vnd.ibm.minipay"
mqy	= "application/vnd.mobius.mqy"
mrc	= "application/marc"
mrcx	= "application/marcxml+xml"
mscml	= "application/mediaservercontrol+xml"
mseq	= "application/vnd.mseq"
msf	= "application/vnd.epson.msf"
msh	= "model/mesh"
msl	= "application/vnd.mobius.msl"
msty	= "application/vnd.muvee.style"
mts	= "model/vnd.mts"
mus	= "application/vnd.musician"
musicxml	= "application/vnd.recordare.musicxml+xml"
mvb	= "application/x-msmediaview"
mwf	= "application/vnd.mfer"
mxf	= "application/mxf"
mxl	= "application/vnd.recordare.musicxml"
mxml	= "application/xv+xml"
mxs	= "application/vnd.triscape.mxs"
mxu	= "video/vnd.mpegurl"
n3	= "text/n3"
nbp	= "application/vnd.wolfram.player"
nc	= "application/x-netcdf"
ncx	= "application/x-dtbncx+xml"
ngage	= "application/vnd.nokia.n-gage.symbian.install"
ngdat	= "application/vnd.nokia.n-gage.data"
nlu	= "application/vnd.neurolanguage.nlu"
nml	= "application/vnd.enliven"
nnd	= "application/vnd.noblenet-directory"
nns	= "application/vnd.noblenet-sealer"
nnw	= "application/vnd.noblenet-web"
npx	= "image/vnd.net-fpx"
nsf	= "application/vnd.lotus-notes"
oa2	= "application/vnd.fujitsu.oasys2"
oa3	= "application/vnd.fujitsu.oasys3"
oas	= "application/vnd.fujitsu.oasys"
obd	= "application/x-msbinder"
oda	= "application/oda"
odb	= "application/vnd.oasis.opendocument.database"
odc	= "application/vnd.oasis.opendocument.chart"
odf	= "application/vnd.oasis.opendocument.formula"
odft	= "application/vnd.oasis.opendocument.formula-template"
odg	= "application/vnd.oasis.opendocument.graphics"
odi	= "application/vnd.oasis.opendocument.image"
odm	= "application/vnd.oasis.opendocument.text-master"
odp	= "application/vnd.oasis.opendocument.presentation"
ods	= "application/vnd.oasis.opendocument.spreadsheet"
odt	= "application/vnd.oasis.opendocument.text"
oga	= "audio/ogg"
ogv	= "video/ogg"
ogx	= "application/ogg"
onetoc	= "application/onenote"
opf	= "application/oebps-package+xml"
org	= "application/vnd.lotus-organizer"
osf	= "application/vnd.yamaha.openscoreformat"
osfpvg	= "application/vnd.yamaha.openscoreformat.osfpvg+xml"
otc	= "application/vnd.oasis.opendocument.chart-template"
otf	= "application/x-font-otf"
otg	= "application/vnd.oasis.opendocument.graphics-template"
oth	= "application/vnd.oasis.opendocument.text-web"
oti	= "application/vnd.oasis.opendocument.image-template"
otp	= "application/vnd.oasis.opendocument.presentation-template"
ots	= "application/vnd.oasis.opendocument.spreadsheet-template"
ott	= "application/vnd.oasis.opendocument.text-template"
oxt	= "application/vnd.openofficeorg.extension"
p	= "text/x-pascal"
p10	= "application/pkcs10"
p12	= "application/x-pkcs12"
p7b	= "application/x-pkcs7-certificates"
p7m	= "application/pkcs7-mime"
p7r	= "application/x-pkcs7-certreqresp"
p7s	= "application/pkcs7-signature"
p8	= "application/pkcs8"
par	= "text/plain-bas"
paw	= "application/vnd.pawaafile"
pbd	= "application/vnd.powerbuilder6"
pbm	= "image/x-portable-bitmap"
pcf	= "application/x-font-pcf"
pcl	= "application/vnd.hp-pcl"
pclxl	= "application/vnd.hp-pclxl"
pcurl	= "application/vnd.curl.pcurl"
pcx	= "image/x-pcx"
pdb	= "application/vnd.palm"
pdf	= "application/pdf"
pfa	= "application/x-font-type1"
pfr	= "application/font-tdpfr"
pgm	= "image/x-portable-graymap"
pgn	= "application/x-chess-pgn"
pgp	= "application/pgp-signature"
pic	= "image/x-pict"
pki	= "application/pkixcmp"
pkipath	= "application/pkix-pkipath"
plb	= "application/vnd.3gpp.pic-bw-large"
plc	= "application/vnd.mobius.plc"
plf	= "application/vnd.pocketlearn"
pls	= "application/pls+xml"
pml	= "application/vnd.ctc-posml"
png	= "image/png"
pnm	= "image/x-portable-anymap"
portpkg	= "application/vnd.macports.portpkg"
potm	= "application/vnd.ms-powerpoint.template.macroenabled.12"
potx	= "application/vnd.openxmlformats-officedocument.presentationml.template"
ppam	= "application/vnd.ms-powerpoint.addin.macroenabled.12"
ppd	= "application/vnd.cups-ppd"
ppm	= "image/x-portable-pixmap"
ppsm	= "application/vnd.ms-powerpoint.slideshow.macroenabled.12"
ppsx	= "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
ppt	= "application/vnd.ms-powerpoint"
pptm	= "application/vnd.ms-powerpoint.presentation.macroenabled.12"
pptx	= "application/vnd.openxmlformats-officedocument.presentationml.presentation"
prc	= "application/x-mobipocket-ebook"
pre	= "application/vnd.lotus-freelance"
prf	= "application/pics-rules"
psb	= "application/vnd.3gpp.pic-bw-small"
psd	= "image/vnd.adobe.photoshop"
psf	= "application/x-font-linux-psf"
pskcxml	= "application/pskc+xml"
ptid	= "application/vnd.pvi.ptid1"
pub	= "application/x-mspublisher"
pvb	= "application/vnd.3gpp.pic-bw-var"
pwn	= "application/vnd.3m.post-it-notes"
pya	= "audio/vnd.ms-playready.media.pya"
pyv	= "video/vnd.ms-playready.media.pyv"
qam	= "application/vnd.epson.quickanime"
qbo	= "application/vnd.intu.qbo"
qfx	= "application/vnd.intu.qfx"
qps	= "application/vnd.publishare-delta-tree"
qt	= "video/quicktime"
qxd	= "application/vnd.quark.quarkxpress"
ram	= "audio/x-pn-realaudio"
rar	= "application/x-rar-compressed"
ras	= "image/x-cmu-raster"
rcprofile	= "application/vnd.ipunplugged.rcprofile"
rdf	= "application/rdf+xml"
rdz	= "application/vnd.data-vision.rdz"
rep	= "application/vnd.businessobjects"
res	= "application/x-dtbresource+xml"
rgb	= "image/x-rgb"
rif	= "application/reginfo+xml"
rip	= "audio/vnd.rip"
rl	= "application/resource-lists+xml"
rlc	= "image/vnd.fujixerox.edmics-rlc"
rld	= "application/resource-lists-diff+xml"
rm	= "application/vnd.rn-realmedia"
rmp	= "audio/x-pn-realaudio-plugin"
rms	= "application/vnd.jcp.javame.midlet-rms"
rnc	= "application/relax-ng-compact-syntax"
rp9	= "application/vnd.cloanto.rp9"
rpss	= "application/vnd.nokia.radio-presets"
rpst	= "application/vnd.nokia.radio-preset"
rq	= "application/sparql-query"
rs	= "application/rls-services+xml"
rsd	= "application/rsd+xml"
rss	= "application/rss+xml"
rtf	= "application/rtf"
rtx	= "text/richtext"
s	= "text/x-asm"
saf	= "application/vnd.yamaha.smaf-audio"
sbml	= "application/sbml+xml"
sc	= "application/vnd.ibm.secure-container"
scd	= "application/x-msschedule"
scm	= "application/vnd.lotus-screencam"
scq	= "application/scvp-cv-request"
scs	= "application/scvp-cv-response"
scurl	= "text/vnd.curl.scurl"
sda	= "application/vnd.stardivision.draw"
sdc	= "application/vnd.stardivision.calc"
sdd	= "application/vnd.stardivision.impress"
sdkm	= "application/vnd.solent.sdkm+xml"
sdp	= "application/sdp"
sdw	= "application/vnd.stardivision.writer"
see	= "application/vnd.seemail"
seed	= "application/vnd.fdsn.seed"
sema	= "application/vnd.sema"
semd	= "application/vnd.semd"
semf	= "application/vnd.semf"
ser	= "application/java-serialized-object"
setpay	= "application/set-payment-initiation"
setreg	= "application/set-registration-initiation"
sfdhdstx	= "application/vnd.hydrostatix.sof-data"
sfs	= "application/vnd.spotfire.sfs"
sgl	= "application/vnd.stardivision.writer-global"
sgml	= "text/sgml"
sh	= "application/x-sh"
shar	= "application/x-shar"
shf	= "application/shf+xml"
sis	= "application/vnd.symbian.install"
sit	= "application/x-stuffit"
sitx	= "application/x-stuffitx"
skp	= "application/vnd.koan"
sldm	= "application/vnd.ms-powerpoint.slide.macroenabled.12"
sldx	= "application/vnd.openxmlformats-officedocument.presentationml.slide"
slt	= "application/vnd.epson.salt"
sm	= "application/vnd.stepmania.stepchart"
smf	= "application/vnd.stardivision.math"
smi	= "application/smil+xml"
snf	= "application/x-font-snf"
spf	= "application/vnd.yamaha.smaf-phrase"
spl	= "application/x-futuresplash"
spot	= "text/vnd.in3d.spot"
spp	= "application/scvp-vp-response"
spq	= "application/scvp-vp-request"
src	= "application/x-wais-source"
sru	= "application/sru+xml"
srx	= "application/sparql-results+xml"
sse	= "application/vnd.kodak-descriptor"
ssf	= "application/vnd.epson.ssf"
ssml	= "application/ssml+xml"
st	= "application/vnd.sailingtracker.track"
stc	= "application/vnd.sun.xml.calc.template"
std	= "application/vnd.sun.xml.draw.template"
stf	= "application/vnd.wt.stf"
sti	= "application/vnd.sun.xml.impress.template"
stk	= "application/hyperstudio"
stl	= "application/vnd.ms-pki.stl"
str	= "application/vnd.pg.format"
stw	= "application/vnd.sun.xml.writer.template"
sub	= "image/vnd.dvb.subtitle"
sus	= "application/vnd.sus-calendar"
sv4cpio	= "application/x-sv4cpio"
sv4crc	= "application/x-sv4crc"
svc	= "application/vnd.dvb.service"
svd	= "application/vnd.svd"
svg	= "image/svg+xml"
swf	= "application/x-shockwave-flash"
swi	= "application/vnd.aristanetworks.swi"
sxc	= "application/vnd.sun.xml.calc"
sxd	= "application/vnd.sun.xml.draw"
sxg	= "application/vnd.sun.xml.writer.global"
sxi	= "application/vnd.sun.xml.impress"
sxm	= "application/vnd.sun.xml.math"
sxw	= "application/vnd.sun.xml.writer"
t	= "text/troff"
tao	= "application/vnd.tao.intent-module-archive"
tar	= "application/x-tar"
tcap	= "application/vnd.3gpp2.tcap"
tcl	= "application/x-tcl"
teacher	= "application/vnd.smart.teacher"
tei	= "application/tei+xml"
tex	= "application/x-tex"
texinfo	= "application/x-texinfo"
tfi	= "application/thraud+xml"
tfm	= "application/x-tex-tfm"
thmx	= "application/vnd.ms-officetheme"
tiff	= "image/tiff"
tmo	= "application/vnd.tmobile-livetv"
torrent	= "application/x-bittorrent"
tpl	= "application/vnd.groove-tool-template"
tpt	= "application/vnd.trid.tpt"
tra	= "application/vnd.trueapp"
trm	= "application/x-msterminal"
tsd	= "application/timestamped-data"
tsv	= "text/tab-separated-values"
ttf	= "application/x-font-ttf"
ttl	= "text/turtle"
twd	= "application/vnd.simtech-mindmapper"
txd	= "application/vnd.genomatix.tuxedo"
txf	= "application/vnd.mobius.txf"
txt	= "text/plain"
ufd	= "application/vnd.ufdl"
umj	= "application/vnd.umajin"
unityweb	= "application/vnd.unity"
uoml	= "application/vnd.uoml+xml"
uri	= "text/uri-list"
ustar	= "application/x-ustar"
utz	= "application/vnd.uiq.theme"
uu	= "text/x-uuencode"
uva	= "audio/vnd.dece.audio"
uvh	= "video/vnd.dece.hd"
uvi	= "image/vnd.dece.graphic"
uvm	= "video/vnd.dece.mobile"
uvp	= "video/vnd.dece.pd"
uvs	= "video/vnd.dece.sd"
uvu	= "video/vnd.uvvu.mp4"
uvv	= "video/vnd.dece.video"
vcd	= "application/x-cdlink"
vcf	= "text/x-vcard"
vcg	= "application/vnd.groove-vcard"
vcs	= "text/x-vcalendar"
vcx	= "application/vnd.vcx"
vis	= "application/vnd.visionary"
viv	= "video/vnd.vivo"
vsd	= "application/vnd.visio"
vsf	= "application/vnd.vsf"
vtu	= "model/vnd.vtu"
vxml	= "application/voicexml+xml"
wad	= "application/x-doom"
wav	= "audio/x-wav"
wax	= "audio/x-ms-wax"
wbmp	= "image/vnd.wap.wbmp"
wbs	= "application/vnd.criticaltools.wbs+xml"
wbxml	= "application/vnd.wap.wbxml"
weba	= "audio/webm"
webm	= "video/webm"
webp	= "image/webp"
wg	= "application/vnd.pmi.widget"
wgt	= "application/widget"
wm	= "video/x-ms-wm"
wma	= "audio/x-ms-wma"
wmd	= "application/x-ms-wmd"
wmf	= "application/x-msmetafile"
wml	= "text/vnd.wap.wml"
wmlc	= "application/vnd.wap.wmlc"
wmls	= "text/vnd.wap.wmlscript"
wmlsc	= "application/vnd.wap.wmlscriptc"
wmv	= "video/x-ms-wmv"
wmx	= "video/x-ms-wmx"
wmz	= "application/x-ms-wmz"
woff	= "application/x-font-woff"
wpd	= "application/vnd.wordperfect"
wpl	= "application/vnd.ms-wpl"
wps	= "application/vnd.ms-works"
wqd	= "application/vnd.wqd"
wri	= "application/x-mswrite"
wrl	= "model/vrml"
wsdl	= "application/wsdl+xml"
wspolicy	= "application/wspolicy+xml"
wtb	= "application/vnd.webturbo"
wvx	= "video/x-ms-wvx"
x3d	= "application/vnd.hzn-3d-crossword"
xap	= "application/x-silverlight-app"
xar	= "application/vnd.xara"
xbap	= "application/x-ms-xbap"
xbd	= "application/vnd.fujixerox.docuworks.binder"
xbm	= "image/x-xbitmap"
xdf	= "application/xcap-diff+xml"
xdm	= "application/vnd.syncml.dm+xml"
xdp	= "application/vnd.adobe.xdp+xml"
xdssc	= "application/dssc+xml"
xdw	= "application/vnd.fujixerox.docuworks"
xenc	= "application/xenc+xml"
xer	= "application/patch-ops-error+xml"
xfdf	= "application/vnd.adobe.xfdf"
xfdl	= "application/vnd.xfdl"
xhtml	= "application/xhtml+xml"
xif	= "image/vnd.xiff"
xlam	= "application/vnd.ms-excel.addin.macroenabled.12"
xls	= "application/vnd.ms-excel"
xlsb	= "application/vnd.ms-excel.sheet.binary.macroenabled.12"
xlsm	= "application/vnd.ms-excel.sheet.macroenabled.12"
xlsx	= "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
xltm	= "application/vnd.ms-excel.template.macroenabled.12"
xltx	= "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
xml	= "application/xml"
xo	= "application/vnd.olpc-sugar"
xop	= "application/xop+xml"
xpi	= "application/x-xpinstall"
xpm	= "image/x-xpixmap"
xpr	= "application/vnd.is-xpr"
xps	= "application/vnd.ms-xpsdocument"
xpw	= "application/vnd.intercon.formnet"
xslt	= "application/xslt+xml"
xsm	= "application/vnd.syncml+xml"
xspf	= "application/xspf+xml"
xul	= "application/vnd.mozilla.xul+xml"
xwd	= "image/x-xwindowdump"
xyz	= "chemical/x-xyz"
yaml	= "text/yaml"
yang	= "application/yang"
yin	= "application/yin+xml"
zaz	= "application/vnd.zzazz.deck+xml"
zip	= "application/zip"
zir	= "application/vnd.zul"
zmm	= "application/vnd.handheld-entertainment+xml"


END[CONFIG.INI]


?>



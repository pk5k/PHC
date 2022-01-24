<?php #HYPERCELL hcf.core.ExceptionHandler - BUILD 22.01.24#142
namespace hcf\core;
class ExceptionHandler {
    use ExceptionHandler\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.core.ExceptionHandler';
    const NAME = 'ExceptionHandler';
    public function __construct() {
        if (method_exists($this, 'hcfcoreExceptionHandler_onConstruct')) {
            call_user_func_array([$this, 'hcfcoreExceptionHandler_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcf\core\ExceptionHandler\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\log\Internal as InternalLogger;
    /**
     * Internal
     * This class is for uniform logging across the builder and engine packages.
     *
     * @category Logger
     * @package rmc.log
     * @author Philipp Kopf
     */
    trait Controller {
        // use this method for set_exception_handler
        public static function exceptionHandler($e) {
            $ex_str = self::exStr($e);
            InternalLogger::log()->error($ex_str);
            if (!headers_sent() && http_response_code() == 200) {
                // this shouldn't be a 200
                header(Utils::getHTTPHeader(500));
            }
            if (ini_get('display_errors') && isset($_SERVER['REQUEST_METHOD'])) {
                echo '<pre>' . $ex_str . '</pre>';
            }
        }
        // and this for register_shutdown_function
        public static function errorHandler($cwd) {
            $err = error_get_last();
            if (!isset($err)) {
                return;
            }
            $handledErrorTypes = array(E_USER_ERROR => 'USER ERROR', E_ERROR => 'ERROR', E_PARSE => 'PARSE', E_CORE_ERROR => 'CORE_ERROR', E_CORE_WARNING => 'CORE_WARNING', E_COMPILE_ERROR => 'COMPILE_ERROR', E_COMPILE_WARNING => 'COMPILE_WARNING');
            // If our last error wasn't fatal then this must be a normal shutdown.
            if (!isset($handledErrorTypes[$err['type']])) {
                return;
            }
            $err_str = self::errStr($err);
            $now = getcwd();
            chdir($cwd);
            InternalLogger::log()->error($err_str);
            chdir($now);
            if (!headers_sent() && http_response_code() == 200) {
                // this shouldn't be a 200
                header(Utils::getHTTPHeader(500));
            }
            if (ini_get('display_errors') && isset($_SERVER['REQUEST_METHOD'])) {
                echo '<pre>' . $err_str . '</pre>';
            }
        }
        public static function errStr($error) {
            $msg = $error["type"] . ' ' . $error["message"] . ' in ' . $error["file"] . ' at line ' . $error["line"];
            list($hcfqn, $assembly, $line) = self::locateAssembly($error["file"], $error["line"]);
            if (!is_null($hcfqn) && !is_null($assembly) && !is_null($line)) {
                $msg = $msg . "\n" . '  <span style="color:#ff0000">located in ' . $hcfqn . '@' . $assembly . ' around line ' . $line . '</span>';
            }
            return $msg;
        }
        public static function exStr($e, $with_markup = false) {
            // source: http://php.net/manual/de/function.set-exception-handler.php#98201
            // these are our templates
            $traceline = null;
            $msg = "Uncaught exception '%s' with message '%s' in %s:%s\nStack trace:\n%s\n  thrown in %s on line %s";
            if ($with_markup) {
                $traceline = "#%s %s(%s): %s(%s) <span style=\"color:#ff0000\">%s</span>";
            } else {
                $traceline = "#%s %s(%s): %s(%s) %s";
            }
            list($trace, $file, $line) = self::remapOrigin($e);
            list($hcfqn, $assembly, $line) = self::locateAssembly($file, $line);
            $trace = self::expandTrace($trace);
            if (!is_null($hcfqn) && !is_null($assembly) && !is_null($line)) {
                if ($with_markup) {
                    $msg = $msg . "\n" . '  <span style="color:#ff0000">located in ' . $hcfqn . '@' . $assembly . ' around line ' . $line . '</span>';
                } else {
                    $msg = $msg . "\n" . '  located in ' . $hcfqn . '@' . $assembly . ' around line ' . $line;
                }
            }
            // alter your trace as you please, here
            foreach ($trace as $key => $stack_point) {
                // I'm converting arguments to their type
                // (prevents passwords from ever getting logged as anything other than 'string')
                if (!isset($trace[$key]['args'])) {
                    $trace[$key]['args'] = []; // if php.ini's exception_ignore_args is Off/false no args will exist (default in PHP 7.4)
                    
                } else {
                    $trace[$key]['args'] = array_map('gettype', $trace[$key]['args']);
                }
            }
            // build your tracelines
            $result = array();
            $i = 0;
            foreach ($trace as $key => $stack_point) {
                $result[] = sprintf($traceline, $i, ((isset($stack_point['file'])) ? $stack_point['file'] : 'INTERNAL'), ((isset($stack_point['line'])) ? $stack_point['line'] : '-'), $stack_point['function'], implode(', ', $stack_point['args']), (isset($stack_point['suffix']) ? $stack_point['suffix'] : ''));
                $i++;
            }
            // trace always ends into main
            $result[] = '#' . $i . ' {main}';
            // write tracelines into main template
            $msg = sprintf($msg, get_class($e), $e->getMessage(), $e->getFile(), $e->getLine(), implode("\n", $result), $e->getFile(), $e->getLine());
            return $msg;
        }
        private static function expandTrace($trace) {
            foreach ($trace as $i => $sp) {
                switch ($sp['function']) {
                    case '_constant':
                    case '_property':
                    case '_arg':
                    case '_call':
                        $t = str_replace('_', '', $sp['function']);
                        $t = ($t == 'call' ? 'method' : $t);
                        $trace[$i]['suffix'] = '-> ' . $t . '-placeholder call';
                        $trace[$i + 1]['suffix'] = '-> template assembly method';
                        if ($trace[$i + 1]['function'] == '__toString') {
                            $trace[$i + 1]['suffix'] = '-> output assembly method';
                        }
                    break;
                }
                if (!isset($sp['file']) && $trace[$i + 1]['function'] == 'invoke') {
                    $trace[$i]['file'] = 'hcf.core.remote.Invoker';
                    $trace[$i]['line'] = $trace[$i]['class'];
                }
            }
            return $trace;
        }
        public static function remapOrigin($e) {
            $trace = $e->getTrace();
            $file = $e->getFile();
            $line = $e->getLine();
            if (strpos($file, 'Internal.php') === false) {
                return [$trace, $file, $line];
            }
            // Internal method like _call or _arg
            $internal_call = $trace[0]['function'];
            switch ($internal_call) {
                case '__construct': // Reflection stuff in internal
                    if (isset($trace[1]) && isset($trace[1]['file']) && isset($trace[2])) {
                        $t = str_replace('_', '', $trace[1]['function']);
                        $t = ($t == 'call') ? 'method' : $t;
                        $sp = $trace[1];
                        $file = $sp['file'];
                        $line = $sp['line'];
                    }
                break;
                case '_constant':
                case '_property':
                case '_arg':
                case '_call':
                    if (isset($trace[0]) && isset($trace[0]['file']) && isset($trace[1])) {
                        $t = str_replace('_', '', $internal_call);
                        $t = ($t == 'call') ? 'method' : $t;
                        $sp = $trace[0];
                        $file = $sp['file'];
                        $line = $sp['line'];
                    }
                break;
                default:
                    InternalLogger::log()->warn(self::FQN . ' - unknown internal call "' . $internal_call . '"');
                break;
            }
            return [$trace, $file, $line];
        }
        public static function locateAssembly($_file, $_line) {
            if (!isset($_file) || !isset($_line)) {
                return [null, null, null];
            }
            $hcfqn = null;
            $assembly = null;
            $distance = 0;
            $line_str = null;
            $line_no = $_line;
            $path = $_file;
            $fc = file($path);
            $fc_full = implode("\n", $fc);
            $fc = array_slice($fc, 0, $line_no);
            $fc = array_reverse($fc);
            $line_str = isset($fc[0]) ? trim($fc[0]) : null;
            if (is_null($line_str)) {
                InternalLogger::log()->warn(self::FQN . ' - cannot locate assembly in ' . $path);
                return [null, null, null];
            }
            foreach ($fc as $line) {
                $distance++;
                $matches = [];
                preg_match_all('/.*(?:BEGIN (?:EXECUTABLE|ASSEMBLY) FRAME )([A-Z\.]*)/', str_replace('OF ', '', $line), $matches, PREG_OFFSET_CAPTURE);
                if (count($matches) > 1 && count($matches[1]) && count($matches[1][0])) {
                    $assembly = strtolower($matches[1][0][0]);
                    if (substr($assembly, 0, 3) == 'of ') {
                        $assembly = substr($assembly, 3);
                    }
                    break;
                }
            }
            $fqn_match = [];
            preg_match_all('/.*const FQN = \'(.*)\';/', $fc_full, $fqn_match, PREG_OFFSET_CAPTURE);
            if (count($fqn_match) > 1 && count($fqn_match[1]) && count($fqn_match[1][0])) {
                $hcfqn = $fqn_match[1][0][0];
            }
            if (is_null($assembly)) {
                InternalLogger::log()->warn(self::FQN . ' - cannot locate assembly in ' . $path);
            }
            if (is_null($hcfqn)) {
                InternalLogger::log()->warn(self::FQN . ' - cannot locate hcfqn in ' . $path);
            }
            if (!is_null($line_str) && !is_null($hcfqn) && !is_null($assembly)) {
                $new_distances = self::relocateRow($line_str, $path, $hcfqn, $assembly); // useful in case of e.g. controller.php where much of the source is reformatted
                if ($new_distances !== false) {
                    if (count($new_distances) == 1) {
                        $distance = $new_distances[0];
                    } else {
                        $nearest = 10000;
                        foreach ($new_distances as $new_distance) {
                            if (($new_distance - $distance) < ($nearest - $distance)) {
                                $nearest = $new_distance;
                            }
                        }
                        $distance = implode(', ', $new_distances) . ' (multiple rows matched). Nearest to unlocated line-number (' . $distance . ') is ' . $nearest;
                    }
                } else {
                    $distance.= ' (inaccurate)';
                }
            }
            return [$hcfqn, $assembly, $distance];
        }
        private static function relocateRow($line_str, $path, $hcfqn, $assembly) {
            $path = str_replace('\\', '/', dirname($path));
            $pp = explode('/', $path);
            $search = implode('/', $pp);
            $map = CS_MAP_NAME;
            $ini = str_replace('map', 'ini', $map);
            while ($search != '') {
                if (file_exists($search . '/' . $map)) {
                    if (!file_exists($search . '/' . $ini)) {
                        InternalLogger::log()->warn(self::FQN . ' - unable to relocate ' . $hcfqn . '@' . $assembly . ' - cellspace.ini is named differently to the map file ' . CS_MAP_NAME . ' or source-files not existing for cellspace of ' . $hcfqn);
                        return false;
                    }
                    $ini = $search . '/' . $ini;
                    break;
                }
                array_pop($pp);
                $search = implode('/', $pp);
            }
            $conf = new \IniParser($ini);
            $conf = $conf->parse();
            if (!isset($conf->source)) {
                InternalLogger::log()->warn(self::FQN . ' - unable to relocate ' . $hcfqn . '@' . $assembly . ' - configuration for source-directory does not exist in ' . $ini);
                return false;
            }
            $src = $conf->source;
            $base = $search . '/' . $src;
            $target = $base . '/' . Utils::HCFQNtoPath($hcfqn, true) . '/' . $assembly;
            $fc = null;
            $nospace = '/\s+/';
            $line_str = trim(preg_replace($nospace, '', $line_str)); // remove every whitespace (unusable for comparsion due formatting)
            if (file_exists($target)) {
                $fc = file($target);
            } else {
                InternalLogger::log()->warn(self::FQN . ' - unable to relocate ' . $hcfqn . '@' . $assembly . ' - assembly is not located at expected path ' . $target . ' either some configuration differs or sources are missing.');
                return false;
            }
            $lines_matched = [];
            foreach ($fc as $line => $str) {
                $add = null;
                $test_str = trim(preg_replace($nospace, '', $str));
                if (strpos($test_str, $line_str) !== false) {
                    $add = $line + 1;
                } else if (isset($fc[$line + 1]) && strpos($test_str . trim(preg_replace($nospace, '', $fc[$line + 1])), $line_str) !== false) // lookahead (missing ; causes lines to be merged due formatting)
                {
                    $add = $line + 2; // +2 here -> we came from the lookahead target line is the next from our current + 1 due 0 based array index
                    
                }
                if (!is_null($add) && !in_array($add, $lines_matched)) {
                    $lines_matched[] = $add; // array index is 0 based
                    
                }
            }
            if (!count($lines_matched)) {
                InternalLogger::log()->warn(self::FQN . ' - unable to relocate ' . $hcfqn . '@' . $assembly . ' - cannot find line ' . $line_str . ' in ' . $target);
                return false;
            }
            return $lines_matched;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



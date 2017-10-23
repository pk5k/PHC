<?php #HYPERCELL hcf.core.log.Internal - BUILD 17.10.11#150
namespace hcf\core\log;
class Internal {
    use Internal\__EO__\Controller, \hcf\core\dryver\Log, \hcf\core\dryver\Internal;
    const FQN = 'hcf.core.log.Internal';
    const NAME = 'Internal';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME LOG.XML
    protected static function getLogAttachment() {
        return self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'LOG', 'XML');
    }
    # END ASSEMBLY FRAME LOG.XML
    
}
namespace hcf\core\log\Internal\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\core\Utils as Utils;
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
        self::log()->error($ex_str);
        if (!headers_sent()) {
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
        self::log()->error($err_str);
        chdir($now);
        if (!headers_sent()) {
            header(Utils::getHTTPHeader(500));
        }
        if (ini_get('display_errors') && isset($_SERVER['REQUEST_METHOD'])) {
            echo '<pre>' . $err_str . '</pre>';
        }
    }
    private static function errStr($error) {
        return $error["type"] . ' ' . $error["message"] . ' in ' . $error["file"] . ' at line ' . $error["line"];
    }
    private static function exStr($e) {
        // source: http://php.net/manual/de/function.set-exception-handler.php#98201
        // these are our templates
        $traceline = "#%s %s(%s): %s(%s)";
        $msg = "Uncaught exception '%s' with message '%s' in %s:%s\nStack trace:\n%s\n  thrown in %s on line %s";
        // alter your trace as you please, here
        $trace = $e->getTrace();
        foreach ($trace as $key => $stackPoint) {
            // I'm converting arguments to their type
            // (prevents passwords from ever getting logged as anything other than 'string')
            $trace[$key]['args'] = array_map('gettype', $trace[$key]['args']);
        }
        // build your tracelines
        $result = array();
        foreach ($trace as $key => $stackPoint) {
            $result[] = sprintf($traceline, $key, ((isset($stackPoint['file'])) ? $stackPoint['file'] : 'INTERNAL'), ((isset($stackPoint['line'])) ? $stackPoint['line'] : '-'), $stackPoint['function'], implode(', ', $stackPoint['args']));
        }
        // trace always ends into main
        $result[] = '#' . ++$key . ' {main}';
        // write tracelines into main template
        $msg = sprintf($msg, get_class($e), $e->getMessage(), $e->getFile(), $e->getLine(), implode("\n", $result), $e->getFile(), $e->getLine());
        return $msg;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

BEGIN[LOG.XML]

<configuration xmlns="http://logging.apache.org/log4php/">
    <appender name="hcf.core.log.Internal" class="LoggerAppenderRollingFile">
        <layout class="LoggerLayoutPattern">
            <param name="conversionPattern" value="%date %logger %-5level %msg%n"/>
        </layout>
        <param name="file" value="hcf.log" />
        <param name="maxFileSize" value="1MB" />
        <param name="maxBackupIndex" value="5" />
    </appender>
    <root>
        <appender_ref ref="hcf.core.log.Internal" />
    </root>
</configuration>

END[LOG.XML]


?>



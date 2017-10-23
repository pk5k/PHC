<?php #HYPERCELL hcf.web.Router - BUILD 17.10.11#32
namespace hcf\web;
class Router {
    use \hcf\core\dryver\Config, Router\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Router';
    const NAME = 'Router';
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
namespace hcf\web\Router\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\core\Utils as Utils;
use \hcf\core\log\Internal as IL;
use \hcf\core\remote\Invoker as RI;
trait Controller {
    public static function route() {
        $arg = self::config()->arg;
        $route_section = null;
        $match = [];
        if (!isset($_GET['!'])) {
            if (isset($_GET[$arg])) {
                $route_section = htmlspecialchars($_GET[$arg]);
            } else if (isset(self::config()->default)) {
                $route_section = self::config()->default;
            } else {
                IL::log()->error(self::FQN . ' - cannot find routing-arg "' . $arg . '" in $_GET parameters and no default route was set - error 500 will be send');
                if (!headers_sent()) {
                    header(Utils::getHTTPHeader(500));
                }
                return false;
            }
        } else {
            $route_section = $_GET['!'];
        }
        return self::routeBySection($route_section);
    }
    private static function routeBySection($route_section) {
        $config = self::config();
        if (!isset($config->$route_section)) {
            IL::log()->error(self::FQN . ' - route-section "' . $route_section . '" doesn\'t exist - error 404 will be send');
            if (!headers_sent()) {
                header(Utils::getHTTPHeader(404));
            }
            return false;
        }
        $req_method = strtolower($_SERVER['REQUEST_METHOD']);
        $output_hc = null;
        if (isset($config->$route_section->output)) {
            $output_hc = $config->$route_section->output;
        } else if (isset($config->$route_section->$req_method)) {
            $output_hc = $config->$route_section->$req_method->output;
        } else {
            IL::log()->error(self::FQN . ' - route-section "' . $route_section . '" doesn\'t have an output nor ' . $req_method . '.output configuration - error 404 will be send');
            if (!headers_sent()) {
                header(Utils::getHTTPHeader(404));
            }
            return false;
        }
        return self::getOutput($output_hc, $route_section);
    }
    private static function constructorArgs() {
        return [$_GET];
    }
    private static function catchException(\Exception $e, $output_hc, $route_section) {
        $config = self::config();
        $new_route_section = false;
        $type = get_class($e);
        $type_hcfqn = Utils::PHPFQN2HCFQN($type);
        $scope = null;
        if (isset($config->$route_section->catch)) {
            $scope = $config->$route_section->catch;
        }
        // maybe the php-class name was used (or something like "Exception")
        if (isset($scope->$type) && is_string($scope->$type)) {
            $new_route_section = $scope->$type;
        } else if (!is_null($scope)) {
            // INI Parser maps catch[hcfqn.to.an.Exception] into sub-objects splittet by dots
            $type_parts = explode('.', $type_hcfqn);
            foreach ($type_parts as $part) {
                if (isset($scope->$part)) {
                    if (is_object($scope->$part)) {
                        $scope = $scope->$part;
                    } else if (is_string($scope->$part)) {
                        $new_route_section = $scope->$part;
                    }
                }
            }
        }
        IL::log()->info($e);
        if (!is_string($new_route_section)) {
            IL::log()->info(self::FQN . ' - hypercell ' . $output_hc . ' failed during execution of route-section ' . $route_section . ' and no catch was found for Exception ' . $type_hcfqn . ' - exception will be thrown up');
            throw $e;
        } else {
            IL::log()->info(self::FQN . ' - hypercell ' . $output_hc . ' failed during execution of route-section ' . $route_section . ' - redirecting to route-section ' . $new_route_section);
            return self::routeBySection($new_route_section);
        }
    }
    private static function getOutput($output_hc, $route_section) {
        $config = self::config();
        try {
            RI::implicitConstructor(true);
            $ri = new RI($output_hc, self::constructorArgs());
            $output = $ri->invoke('toString');
            return $output;
        }
        catch(\Exception $e) {
            return self::catchException($e, $output_hc, $route_section);
        }
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

arg = "route"; key of the $_GET array that will be used as the value of the route-section.
default = "-bridge"; if the arg is not set, this route will be used

; TIP: before checking the $_GET array against the argument above, $_GET['!'] will be checked.
; 	example: http://blablabla.com?!=-internal-route
; The ! argument is used by the hcf, to force the current http-hook (independent of the http-hooks array
; inside the surface.ini). The value of this argument will be used as route-section. If the argument
; of the configuration above is also set, it will be ignored.
; This feature is used for internal-routing like the hcf.web.Bridge hypercell.

; one section = one route
; internal routes (that use the $_GET['!'] arg) should be marked with a leading dash,
; because they have to be present in every hcf.http.Router configuration

[-bridge]
; DON'T REMOVE THIS SECTION AND ADD IT TO YOUR ATTACHMENT IN CASE OF OVERRIDING IT
; THIS IS REQUIRED AS LOOPBACK FOR hcf.web.Bridge
post.output = "hcf.web.Bridge"; HCFQN which will be instantiated with the $_GET parameters. The response (trough the HCs output assembly) will be returned from ::route()

[-style]
; DON'T REMOVE THIS SECTION AND ADD IT TO YOUR ATTACHMENT IN CASE OF OVERRIDING IT
; THIS IS REQUIRED AS STYLE-LINK FOR hcf.web.Container
get.output = "hcf.web.Container.Autoloader.provider.Style"; this will be used as fake-file: <style link="?!-style" type="text/css"/>

[-script]
; DON'T REMOVE THIS SECTION AND ADD IT TO YOUR ATTACHMENT IN CASE OF OVERRIDING IT
; THIS IS REQUIRED AS SCRIPT-SOURCE FOR hcf.web.Container
get.output = "hcf.web.Container.Autoloader.provider.Script"; this will be used as fake-file: <script src="?!-script" language="javascript"/>


END[CONFIG.INI]


?>



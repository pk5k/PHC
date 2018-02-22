<?php #HYPERCELL hcf.web.Container.Autoloader.provider - BUILD 18.02.22#11
namespace hcf\web\Container\Autoloader;
abstract class provider {
    use provider\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.web.Container.Autoloader.provider';
    const NAME = 'provider';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
}
namespace hcf\web\Container\Autoloader\provider\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\web\Container\Autoloader;
trait Controller {
    protected static function provideAssembliesOfType($which_type) {
        $autoloader_conf = Autoloader::config();
        if (!isset($autoloader_conf->assemblies->$which_type) || !is_array($autoloader_conf->assemblies->$which_type->hypercells)) {
            throw new \Exception(self::FQN . ' - config-assembly of ' . Autoloader::FQN . ' does not contain a ' . $which_type . ' configuration');
        }
        $al = new Autoloader(false);
        $ao = new \stdClass(); //= $autoloader_conf->assemblies
        $ao->$which_type = $autoloader_conf->assemblies->$which_type; // extract this part of the config
        $ao->$which_type->link = false; // embed this time (was true, otherwise we won't be here)
        $ad = $al->assemblyLoader($ao);
        return $ad->$which_type;
    }
    protected static function provideFileTypeHeader($mime_type) {
        header('Content-Type: ' . $mime_type);
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



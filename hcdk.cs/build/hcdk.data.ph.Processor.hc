<?php #HYPERCELL hcdk.data.ph.Processor - BUILD 17.10.11#38
namespace hcdk\data\ph;
class Processor {
    use Processor\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.ph.Processor';
    const NAME = 'Processor';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
}
namespace hcdk\data\ph\Processor\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
trait Controller {
    public static function process($content, $between_double_quotes = true) {
        return $content;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



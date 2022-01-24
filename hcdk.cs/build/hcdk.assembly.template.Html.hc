<?php #HYPERCELL hcdk.assembly.template.Html - BUILD 21.07.08#199
namespace hcdk\assembly\template;
class Html extends \hcdk\assembly\template\Xml {
    use \hcf\core\dryver\Base, Html\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.template.Html';
    const NAME = 'Html';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    }
    namespace hcdk\assembly\template\Html\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    use \hcdk\data\xml\Parser as XMLParser;
    trait Controller {
        // Assembly inherits from template.xml - only override traits and type here
        public function getType() {
            return 'HTML';
        }
        public function getTraits() {
            return ['Template' => '\\hcf\\core\\dryver\\Template', 'TemplateHtml' => '\\hcf\\core\\dryver\\Template\\Html'];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



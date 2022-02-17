<?php #HYPERCELL hcdk.assembly.view.Html - BUILD 22.02.15#207
namespace hcdk\assembly\view;
class Html extends \hcdk\assembly\view\Xml {
    use \hcf\core\dryver\Base, Html\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.view.Html';
    const NAME = 'Html';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkassemblyviewHtml_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblyviewHtml_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\assembly\view\Html\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    use \hcdk\data\xml\Parser as XMLParser;
    trait Controller {
        // Assembly inherits from template.xml - only override traits and type here
        public function getType() {
            return 'HTML';
        }
        public function getTraits() {
            return ['View' => '\\hcf\\core\\dryver\\View', 'ViewHtml' => '\\hcf\\core\\dryver\\View\\Html'];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
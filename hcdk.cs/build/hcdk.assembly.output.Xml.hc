<?php #HYPERCELL hcdk.assembly.output.Xml - BUILD 18.06.15#176
namespace hcdk\assembly\output;
class Xml extends \hcdk\assembly\output {
    use \hcf\core\dryver\Base, Xml\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.output.Xml';
    const NAME = 'Xml';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function template__toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "
\$output = '';
{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }

return \$output;
";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
}
namespace hcdk\assembly\output\Xml\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcdk\raw\Method as Method;
use \hcdk\data\xml\Parser as XMLParser;
trait Controller {
    public function getType() {
        return 'XML';
    }
    public function build__toString() {
        // The Fragment-implementations inside hcdk.xml will process the placeholder by themselfes, because we can't detect, if the placeholder
        // is added in- or outside of the output-variable (the $betweem_double_quotes flag for Placeholder::process)
        // in further implementations, the placeholders should be processed here, to keep the Fragments "placeholder-independet"
        // $ph_output  = $this->processPlaceholders($this->raw_input);
        $output = XMLParser::parse($this->rawInput(), $this->for_file);
        $method = new Method('__toString', ['public']);
        $method->setBody($this->prependControlSymbols($this->template__toString($output)));
        return $method->toString();
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



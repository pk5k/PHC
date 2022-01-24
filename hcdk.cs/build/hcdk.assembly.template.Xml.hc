<?php #HYPERCELL hcdk.assembly.template.Xml - BUILD 22.01.24#200
namespace hcdk\assembly\template;
class Xml extends \hcdk\assembly\template {
    use \hcf\core\dryver\Base, Xml\__EO__\Controller, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.assembly.template.Xml';
    const NAME = 'Xml';
    public function __construct() {
        if (method_exists($this, 'hcdkassemblytemplateXml_onConstruct')) {
            call_user_func_array([$this, 'hcdkassemblytemplateXml_onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME TEMPLATE.TEXT
    protected function buildTemplateMethod() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $_func_args = \func_get_args();
        $output = "
\$output = '';
{$__CLASS__::_arg($_func_args, 0, $__CLASS__, $_this) }

return self::_postProcess(\$output, [{$__CLASS__::_arg($_func_args, 1, $__CLASS__, $_this) }], [{$__CLASS__::_arg($_func_args, 2, $__CLASS__, $_this) }]);";
        return $output;
    }
    # END ASSEMBLY FRAME TEMPLATE.TEXT
    
    }
    namespace hcdk\assembly\template\Xml\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\raw\Method as Method;
    use \hcdk\data\xml\Parser as XMLParser;
    use \hcdk\data\xml\Fragment\render\PipelineFragment;
    trait Controller {
        public function getType() {
            return 'XML';
        }
        public function buildTemplate($name, $data) {
            // The Fragment-implementations inside hcdk.xml will process the placeholder by themselfes, because we can't detect, if the placeholder
            // is added in- or outside of the output-variable (the $betweem_double_quotes flag for Placeholder::process)
            // in further implementations, the placeholders should be processed here, to keep the Fragments "placeholder-independet"
            // $ph_output  =
            PipelineFragment::resetInstanceCounter(); // begin at $instance_0 in each template-method
            $input = $data['content'];
            $opt_attrs = XMLParser::matchOptionalAttributes($input);
            $opt_tags = XMLParser::matchOptionalTags($input);
            $output = XMLParser::parse($input, $this->for_file . ', template-section "' . $name . '"');
            $method = new Method($name, $data['mod']);
            $attrs = '';
            $tags = '';
            if (count($opt_attrs) > 0) {
                $attrs = "'" . implode("','", $opt_attrs) . "'";
            }
            if (count($opt_tags) > 0) {
                $tags = "'" . implode("','", $opt_tags) . "'";
            }
            $method->setBody($this->prependControlSymbols($this->buildTemplateMethod($output, $attrs, $tags)));
            return $method->toString();
        }
        public function getTraits() {
            return ['Template' => '\\hcf\\core\\dryver\\Template', 'TemplateXml' => '\\hcf\\core\\dryver\\Template\\Xml'];
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



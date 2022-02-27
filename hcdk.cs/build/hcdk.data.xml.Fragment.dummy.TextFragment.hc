<?php #HYPERCELL hcdk.data.xml.Fragment.dummy.TextFragment - BUILD 22.02.23#81
namespace hcdk\data\xml\Fragment\dummy;
class TextFragment extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, TextFragment\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.dummy.TextFragment';
    const NAME = 'TextFragment';
    public function __construct() {
        if (method_exists($this, 'hcdkdataxmlFragmentdummyTextFragment_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkdataxmlFragmentdummyTextFragment_onConstruct_Controller'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\dummy\TextFragment\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    
    /**
     * Text
     * This Fragment will replace itself with dummy text (lorem ipsum) with a given length
     *
     * @category XML Fragment
     * @package hcdk.xml.fragment.dummy
     * @author Philipp Kopf
     */
    trait Controller {
        private static $lorem_ipsum = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';
        public static function build($root, $file_scope) {
            $length = 1000; //1000 chars as default length
            if (isset($root['length'])) {
                $length = (int)$root['length'];
            }
            $output = self::$lorem_ipsum;
            while (strlen($output) < $length) {
                $output.= self::$lorem_ipsum;
            }
            if (strlen($output) > $length) {
                $output = substr($output, 0, $length);
            }
            $output = parent::FRGMNT_OUTPUT_START() . $output . parent::FRGMNT_OUTPUT_END();
            return $output;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
<?php #HYPERCELL hcdk.data.xml.Fragment.condition - BUILD 22.02.23#84
namespace hcdk\data\xml\Fragment;
abstract class condition extends \hcdk\data\xml\Fragment {
    use \hcf\core\dryver\Base, condition\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.data.xml.Fragment.condition';
    const NAME = 'condition';
    public function __construct() {
        if (method_exists($this, 'hcdkdataxmlFragmentcondition_onConstruct_Controller')) {
            call_user_func_array([$this, 'hcdkdataxmlFragmentcondition_onConstruct_Controller'], func_get_args());
        }
    }
    }
    namespace hcdk\data\xml\Fragment\condition\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcdk\data\xml\Parser as XMLParser;
    use \hcdk\data\ph\Parser as PlaceholderParser;
    /**
     * Fragment
     * Abstract parent class for If/Else Fragments
     *
     * @category XML Fragment
     * @package hcdk.xml.fragment
     * @author Philipp Kopf
     */
    trait Controller {
        protected static $possible_conditions = ['is-not-set' => '!isset(#)', 'is-set' => 'isset(#)', 'isset' => 'isset(#)', 'is' => '==', 'is-not' => '!=', 'gt' => '>', 'lt' => '<', 'gte' => '>=', 'lte' => '<=', 'is-bool' => '(bool)']; // key = attribute name to use this condition, value = the condition in php
        public static function getConditionAttribute($root, $file_scope) {
            // return: [0 => 'attr_php_representation', 1 => 'attr_value']
            foreach ($root->attributes() as $attr_name => $value) {
                if (isset(self::$possible_conditions[$attr_name])) {
                    $between_double_quotes = true;
                    if (strpos(self::$possible_conditions[$attr_name], '#') !== false) {
                        $between_double_quotes = false; // no quotes for direct function pass
                        
                    }
                    return [self::$possible_conditions[$attr_name], PlaceholderParser::parse($value, $between_double_quotes) ];
                }
            }
            throw new \XMLParseException(self::FQN . ' - No condition set in ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
        }
        public static function buildBody($root, $file_scope) {
            $body = '';
            if (count($root->children()) > 0) {
                foreach ($root->children() as $child) {
                    $body.= XMLParser::renderFragment($child, $file_scope);
                }
            } else {
                throw new \XMLParseException(self::FQN . ' - Fragment cannot be empty. In ' . $file_scope . ' for element "' . str_replace(XMLParser::TMP_OPT_TAG_MARKER, '?', $root->getName()) . '"');
            }
            return $body;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>
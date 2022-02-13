<?php #HYPERCELL hcdk.cli.exec.Tree - BUILD 22.01.24#83
namespace hcdk\cli\exec;
class Tree extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Tree\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Tree';
    const NAME = 'Tree';
    public function __construct() {
        call_user_func_array('parent::__construct', func_get_args());
        if (method_exists($this, 'hcdkcliexecTree_onConstruct')) {
            call_user_func_array([$this, 'hcdkcliexecTree_onConstruct'], func_get_args());
        }
    }
    }
    namespace hcdk\cli\exec\Tree\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    use \hcf\core\Utils as Utils;
    use \hcf\core\log\Internal as InternalLogger;
    use \hcf\cli\Colors as CliColors;
    use \hcdk\raw\Cellspace as Cellspace;
    trait Controller {
        public function execute($argv, $argc) {
            $__arg_dir = realpath($argv[0]);
            $__arg_details = false;
            $__arg_flat = false;
            foreach ($argv as $arg_i => $arg) {
                switch ($arg) {
                    case '--details':
                    case '-d':
                        $__arg_details = true;
                    break;
                    case '--at':
                    case '-at':
                        $__arg_dir = realpath($argv[$arg_i + 1]); //next argument must be the directory
                        
                    break;
                    case '--flat':
                    case '-f':
                        $__arg_flat = true;
                    break;
                }
            }
            define('HCDK_HC_MARKER', '#HC');
            // CLI colors
            define('HCDK_ABSTRACT_BG', 'cyan');
            define('HCDK_HYPERCELL_BG', 'blue');
            define('HCDK_NOT_EXEC_BG', 'red');
            define('HCDK_REBUILD_FG', 'purple');
            define('HCDK_INFO_FG', 'light-gray');
            try {
                $tree = [];
                $cellspace = new Cellspace($__arg_dir);
                $hypercells = $cellspace->getHypercells();
                foreach ($hypercells as $hypercell) {
                    $hcfqn = $hypercell->getName()->long;
                    $hcfqn_stack = explode('.', $hcfqn);
                    $node = $this->pushNode($hypercell, $hcfqn_stack);
                    $tree = array_merge_recursive($tree, $node);
                }
                $this->printNode($tree, 0, $__arg_details, $__arg_flat);
                echo Utils::newLine();
            }
            catch(\Exception $e) {
                InternalLogger::log()->error('Unable to generate cellspace-tree due following exception:');
                InternalLogger::log()->error($e);
            }
        }
        private function pushNode($hypercell, $hcfqn_stack, $at = null) {
            if (!isset($at)) {
                $at = [];
            }
            // consume current package-node
            $current = array_shift($hcfqn_stack);
            if (count($hcfqn_stack) > 0) {
                $new_at = [];
                $new_at[$current] = $this->pushNode($hypercell, $hcfqn_stack, $at);
                $at = array_merge_recursive($at, $new_at);
            } else if ($hypercell->isBuildable()) {
                $at[$current][HCDK_HC_MARKER] = $hypercell;
            }
            return $at;
        }
        private function printNode($tree, $indent = 0, $print_details = false, $__arg_flat = false) {
            foreach ($tree as $node_name => $node) {
                $indent_string = $this->indentString($indent, $__arg_flat);
                $fg = null;
                $bg = null;
                if (isset($node[HCDK_HC_MARKER])) {
                    $hc = $node[HCDK_HC_MARKER];
                    if ($hc->isAbstract()) {
                        $bg = HCDK_ABSTRACT_BG;
                    } else if (!$hc->isExecutable()) {
                        $bg = HCDK_NOT_EXEC_BG;
                    } else {
                        $bg = HCDK_HYPERCELL_BG;
                    }
                    if ($hc->rebuildRequired()) {
                        $fg = HCDK_REBUILD_FG;
                    }
                }
                echo $indent_string . CliColors::apply($node_name, $fg, $bg);
                if (isset($node[HCDK_HC_MARKER]) && ($node[HCDK_HC_MARKER] instanceof \hcdk\raw\Hypercell)) {
                    if ($print_details) {
                        $this->printHCInfo($node[HCDK_HC_MARKER], $indent + 1, $__arg_flat);
                    }
                    unset($node[HCDK_HC_MARKER]); // remove after printing
                    
                }
                if (is_array($node)) {
                    $this->printNode($node, $indent + 1, $print_details, $__arg_flat);
                }
            }
        }
        private function printHCInfo($hc, $indent = 0, $__arg_flat = false) {
            $indent_string = $this->indentString($indent, $__arg_flat);
            $name = $hc->getName();
            $no = $hc->getBuildInfo()->no;
            $cs = $hc->getBuildInfo()->checksum;
            $assemblies = $hc->getAssemblies();
            $ais = $this->indentString($indent + 1, $__arg_flat);
            echo $indent_string . CliColors::apply('Information', HCDK_INFO_FG);
            echo $ais . ' - FQN = ' . $name->long;
            echo $ais . ' - Build = ' . $no;
            echo $ais . ' - Checksum = ' . $cs;
            echo $ais . ' - Buildable = ' . ($hc->isBuildable() ? 'yes' : 'no');
            echo $ais . ' - Executable = ' . ($hc->isExecutable() ? 'yes' : CliColors::apply('no', HCDK_NOT_EXEC_BG));
            echo $ais . ' - Abstract = ' . ($hc->isAbstract() ? 'yes' : 'no');
            echo $ais . ' - Rebuild = ' . ($hc->rebuildRequired() ? CliColors::apply('required', HCDK_REBUILD_FG) : 'not required');
            echo $indent_string . CliColors::apply('Assemblies', HCDK_INFO_FG);
            foreach ($assemblies as $assembly) {
                $file = $assembly->fileInfo();
                $a_type = ($assembly->isAttachment()) ? ', attachment' : '';
                $a_type.= ($assembly->isExecutable()) ? ', executable' : '';
                $an = strtolower($assembly->getName());
                $an.= ($assembly->getType() != '') ? ('.' . strtolower($assembly->getType())) : '';
                echo $ais . ' - ' . $an . ' (' . $file->getSize() . 'b' . $a_type . ')';
            }
        }
        private function indentString($indent = 0, $__arg_flat) {
            if ($__arg_flat) {
                return Utils::newLine();
            }
            $indent_char = '  ';
            $indent_string = Utils::newLine();
            for ($i = 0;$i < $indent;$i++) {
                $indent_string.= $indent_char;
            }
            return $indent_string;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__

?>



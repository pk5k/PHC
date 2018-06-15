<?php #HYPERCELL hcdk.cli.exec.Help - BUILD 18.06.15#58
namespace hcdk\cli\exec;
class Help extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Help\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Help';
    const NAME = 'Help';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "* * * * * * * * * * * * * * *
* HYPERCELL DEVELOPMENT KIT 
* COMMAND LINE INTERFACE HELP
*

 create --nsroot root-namespace [--source src/] [--target build/] [--format true] [--verbose]

 	Use this command inside an empty directory to 
 	create a new Cellspace.

 	nsroot (ns): the root-namespace the Hypercells
 	inside this cellspace belong to. This value
 	will be prepended to all HCFQNs at build-time.
 
 	source (s): the directory the Hypercell sources
 	are located.

 	target (t): the directory where the Hypercells
 	will be located after building.

 	format (f): format the PHP-script of the built 
 	Hypercell before writing it to it's output file.

 	verbose (v): set the hcf.core.log.Internal logging-level
 	from WARN down to INFO. This will print more information
 	about each script-execution to the std-output.

 add HCFQN [assembly-name.assembly-type [...]]

 	Add path + assembly-files for the given Hypercell-
 	Full-Qualified-Name + assemblies.

 	assembly-name.assembly-type: For example
 	\"output.xml\" or \"config.ini\". Each combination
 	will be created as assembly - splitted by blanks.

 build [--all] [--at /path/to/cellspace/] [--no-update] [--verbose]
	
	Build the current working directory that must 
	contain at least a cellspace setup file.

	all (a): force build of every Hypercell inside 
	this cellspace.

	at: path to a directory, that should be build
	instead the current working directory.

	no-update (nu): don't update the Hypercells build-information.

	verbose (v): set the hcf.core.log.Internal logging-level
 	from WARN down to INFO. This will print more information
 	about each script-execution to the std-output.

 map [--write-before] [--at /path/to/cellspace/]

 	Print the Cellspace map data.

 	write-before (wb): re-read all Hypercells, write new 
 	map-data and display it, instead of using 
 	the existing map data.

 	at: show the map file inside this directory

 tree [--details] [--at /path/to/cellspace/] [--flat]

 	Read the current Cellspace and display it's
 	structure in form of a tree.

 	details (d): Also show details of each Hypercell
 	inside this Cellspace.

 	at: path to a directory, that should be analyzed
	instead the current working directory.

	flat (f): Don't indent HC-information on the output
	by it's nesting level inside the cellspace

 version 
	
	Load the Hypercell Framework + SDK and display 
	their versions.

 [help]
	
	Show this help.

* 
* * * * * * * * * * * * * * *
";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    
}
namespace hcdk\cli\exec\Help\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
trait Controller {
    public function execute($argv, $argc) {
        echo $this;
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



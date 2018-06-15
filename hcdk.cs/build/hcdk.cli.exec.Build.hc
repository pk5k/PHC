<?php #HYPERCELL hcdk.cli.exec.Build - BUILD 18.06.15#65
namespace hcdk\cli\exec;
class Build extends \hcf\cli\exec {
    use \hcf\core\dryver\Base, Build\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcdk.cli.exec.Build';
    const NAME = 'Build';
    public function __construct() {
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
        call_user_func_array('parent::__construct', func_get_args());
    }
}
namespace hcdk\cli\exec\Build\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\core\Utils as Utils;
use \hcf\core\log\Internal as InternalLogger;
use \hcdk\raw\Cellspace as Cellspace;
trait Controller {
    private function backupFix($directory) {
        // moving directories while opened inside the terminal, will confuse it (on Mac)
        // move to another directory and from there, switch to the original
        @chdir($_SERVER['HOME']); //use the home directory
        @chdir($directory);
    }
    public function execute($argv, $argc) {
        $origin = getcwd();
        $__arg_dir = realpath($argv[0]);
        $__arg_rebuild_all = false;
        $__arg_nu = false;
        $__arg_verbose = false;
        foreach ($argv as $arg_i => $arg) {
            switch ($arg) {
                case '--all':
                case '-a':
                    $__arg_rebuild_all = true;
                break;
                case '--at':
                case '-at':
                    $__arg_dir = realpath($argv[$arg_i + 1]); //next argument must be the directory
                    
                break;
                case '--no-update':
                case '-nu':
                    $__arg_nu = true;
                break;
                case '--verbose':
                case '-v':
                    $__arg_verbose = true;
                break;
            }
        }
        if ($__arg_verbose) {
            InternalLogger::log()->setLevel(\LoggerLevel::getLevelInfo());
        }
        /*
         * if backup_dir is null
         * it won't be removed after the build succeeded
         * it won't be rollbacked after the build failed
        */
        $backup_dir = null;
        $cellspace = null;
        $failed = false;
        define('HCDK_TRANSITION_PREFIX', '#~'); //directory-name prefix for the backup process
        try {
            $ms_total = time();
            InternalLogger::log()->info('Initialising Cellspace "' . $__arg_dir . '" from ."' . getcwd() . '"...');
            $cellspace = new Cellspace($__arg_dir);
            InternalLogger::log()->info('Collecting Hypercells...');
            $hypercells = $cellspace->getHypercells();
            InternalLogger::log()->info('...finished - found ' . count($hypercells) . ' possible Hypercells');
            InternalLogger::log()->info('...initialisation for Cellspace "' . $__arg_dir . '" finished');
            $dirname = dirname($cellspace->getRoot());
            $basename = HCDK_TRANSITION_PREFIX . basename($cellspace->getRoot());
            $backup_dir = $dirname . '/' . $basename;
            InternalLogger::log()->info('Creating backup-directory of Cellspace at "' . $backup_dir . '"...');
            if (file_exists($backup_dir)) {
                $ba_dir_str = $backup_dir;
                $backup_dir = null; //do not remove the existing backup-dir, because we do not know why it exists
                throw new \Exception('Backup-directory "' . $ba_dir_str . '" already exists - ABORTING FOR SAFETY');
            }
            try {
                Utils::copyPath($__arg_dir, $backup_dir); // todo: just copy target + src dir
                InternalLogger::log()->info('...backup-directory successfully created');
            }
            catch(\Exception $e) {
                // set backup_dir null here, to avoid a rollback
                $backup_dir = null;
                // throw again
                throw $e;
            }
            InternalLogger::log()->info('Build process begins');
            $built = 0;
            $skipped = 0;
            foreach ($hypercells as $hypercell) {
                InternalLogger::log()->info($hypercell->getName()->long . '[RR:' . ($hypercell->rebuildRequired() ? 'true' : 'false') . ', AB:' . ($hypercell->isAbstract() ? 'true' : 'false') . ', BA:' . ($hypercell->isBuildable() ? 'true' : 'false') . ', EX:' . ($hypercell->isExecutable() ? 'true' : 'false') . ']:');
                foreach ($hypercell->getAssemblies() as $assembly) {
                    $an = $assembly->getName();
                    $an.= ($assembly->getType() != '') ? ('.' . $assembly->getType()) : '';
                    InternalLogger::log()->info(' - ' . strtolower($an));
                }
                if ($hypercell->isBuildable()) {
                    if ($hypercell->rebuildRequired() || $__arg_rebuild_all) {
                        $ms = time();
                        InternalLogger::log()->info('Building ' . $hypercell->getName()->long . '...');
                        InternalLogger::log()->info(' - writing Hypercell');
                        $hypercell->write();
                        if (!$__arg_nu) {
                            InternalLogger::log()->info(' - updating build information');
                            $hypercell->writeBuildInfo(true);
                        }
                        $built++;
                        $ms = time() - $ms;
                        InternalLogger::log()->info('...building ' . $hypercell->getName()->long . ' finished - took ' . $ms . 'ms');
                    } else {
                        $skipped++;
                        InternalLogger::log()->info($hypercell->getName()->long . ' does not need a rebuild and therefore was skipped');
                    }
                } else {
                    $skipped++;
                    InternalLogger::log()->info($hypercell->getName()->long . ' is not buildable and therefore was skipped');
                }
            }
            $ms_total = time() - $ms_total;
            InternalLogger::log()->info('Build process finished - built ' . $built . ', skipped ' . $skipped . ', took ' . $ms_total . 'ms');
            InternalLogger::log()->info('Updating Cellspace map file "' . $cellspace->getRoot() . Cellspace::config()->file->map . '"...');
            $cellspace->writeMap(true);
            InternalLogger::log()->info('...updating Cellspace map file done');
        }
        catch(\Exception $e) {
            $failed = true;
            InternalLogger::log()->error('Unable to proceed due following exception:');
            InternalLogger::log()->error($e);
            if (isset($backup_dir) && isset($cellspace)) {
                // rename the dirty cellspace before removeing it to do not lose data if the backup-directory can't be restored
                $rm_name = dirname($cellspace->getRoot()) . '/' . HCDK_TRANSITION_PREFIX . 'trash-' . basename($cellspace->getRoot());
                InternalLogger::log()->info('Rolling back Cellspace "' . $cellspace->getRoot() . '" by backup-directory "' . $backup_dir . '"...');
                InternalLogger::log()->info(' - renaming dirty Cellspace "' . $cellspace->getRoot() . '" to "' . $rm_name . '"');
                if (!rename($cellspace->getRoot(), $rm_name)) {
                    InternalLogger::log()->error('Unable to rename - cannot restore backup automatically - abort');
                    die();
                }
                InternalLogger::log()->info(' - renaming backup-directory "' . $backup_dir . '" to original Cellspace "' . $cellspace->getRoot() . '"');
                if (!rename($backup_dir, $cellspace->getRoot())) {
                    InternalLogger::log()->error('Unable to rename - cannot restore backup automatically - abort');
                    die();
                }
                InternalLogger::log()->info(' - removing dirty Cellspace "' . $rm_name . '"');
                try {
                    Utils::removePath($rm_name);
                }
                catch(\Exception $ee) {
                    InternalLogger::log()->error('Unable to remove dirty Cellspace "' . $rm_name . '" due following exception:');
                    InternalLogger::log()->error($ee);
                    die();
                }
                InternalLogger::log()->info('Rolling back Cellspace completed successfully');
            } else {
                InternalLogger::log()->info('No backup-directory was created during this execution - NO ROLLBACK WILL BE PERFORMED');
            }
        }
        if (!$failed && is_string($backup_dir)) {
            InternalLogger::log()->info('Removing backup Cellspace "' . $backup_dir . '"...');
            try {
                Utils::removePath($backup_dir);
            }
            catch(\Exception $e) {
                InternalLogger::log()->error('Unable to remove backup Cellspace "' . $backup_dir . '" due following exception:');
                InternalLogger::log()->error($e);
                die();
            }
            InternalLogger::log()->info('...done');
        }
        $this->backupFix($origin);
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

?>



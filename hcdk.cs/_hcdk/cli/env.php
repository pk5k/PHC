#!/usr/bin/php
<?php
// if you are running this script over an XAMPP installation PHP-CLI, the PEAR.php won't be found inside the PHP_Beautifier package
// to fix this, uncomment the line below
set_include_path('/Applications/XAMPP/xamppfiles/lib/php');
date_default_timezone_set('America/Los_Angeles');
define('HCDK_CLI_BASE', 'hcdk.cli.exec.');// root-package, the hcf.cli.exec generalisations are located at

$origin = getcwd();

chdir(__DIR__);// load hypercell-framework with the surface.ini inside this directory
require_once __DIR__.'/../../../PHC.php';
chdir($origin);// switch back here, so hcdk's initialisation log below will show the CWD where the script was called from, also we must work inside this directory
require_once __DIR__.'/../../_hcdk/_hcdk.php';

use \hcf\core\remote\Invoker as RemoteInvoker;

RemoteInvoker::implicitConstructor(true);
$cli_hc = ucfirst($argv[1]);
$ri = new RemoteInvoker(HCDK_CLI_BASE.$cli_hc);
$cli_exec = $ri->getInstance();

$pass_argv = array_slice($argv, 2);
$pass_argc = count($pass_argv);

if ($cli_exec instanceof \hcf\cli\exec)
{
	$cli_exec->execute($pass_argv, $pass_argc);
}
else
{
	throw new \RuntimeException(HCDK_CLI_BASE.$cli_hc.' is not an hcf.cli.exec instance');
}

?>

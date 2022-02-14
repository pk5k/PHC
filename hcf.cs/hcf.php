<?php
define('HCF_VERSION', '1.1.0');// version of this copy
define('HCF_INI_FILE', 'surface.ini');// name of the cores initialisation file
define('CS_MAP_NAME', 'cellspace.map');// name of the cellspace's map file - also set inside the hcdk.cellspace.DataMapper
define('HCF_ROOT', __DIR__);// publish root directory of this cellspace (mainly for cellspace.ini include in hcdk)
ob_start();// buffer all output before hcf.web.Router calls the echo for the output

require_once __DIR__.'/_hcf.core/_hcf.core.php';

use \hcf\core\loader\AutoLoader as AutoLoader;
use \hcf\core\log\Internal as InternalLogger;
use \hcf\core\ExceptionHandler as ExceptionHandler;
use \hcf\core\loader\LibLoader as LibLoader;
use \hcf\core\Utils as Utils;
use \hcf\core\remote\Invoker as RemoteInvoker;
use \hcf\web\Router as Router;

// this will load the hcf
new AutoLoader(__DIR__, __DIR__.'/'.CS_MAP_NAME);

$elfqn = '\\'.Utils::HCFQN2PHPFQN(ExceptionHandler::FQN);

set_exception_handler([$elfqn, 'exceptionHandler']);
register_shutdown_function([$elfqn, 'errorHandler'], getcwd());// getcwd for php/apache path-change on shutdown (to resolve relative paths correctly)

// CELLSPACES
$include_dirs = $hcf_config->include;

if (is_string($include_dirs))
{
	// Force include_dirs be an array
	$include_dirs = [$include_dirs];
}
else if (!is_array($include_dirs))
{
	$include_dirs = [];
}

$cs = implode(',', $include_dirs);

InternalLogger::log()->info(' - CELLSPACES = ['.$cs.']');

foreach ($include_dirs as $dir)
{
	new AutoLoader($dir, $dir.'/'.CS_MAP_NAME);
}

// LIBS
$lib_dirs = $hcf_config->libs;

if (is_string($lib_dirs))
{
	$lib_dirs = [$lib_dirs];
}
else if (!is_array($lib_dirs))
{
	$lib_dirs = [];
}

$ls = implode(',', $lib_dirs);

InternalLogger::log()->info(' - LIBS = ['.$ls.']');

foreach ($lib_dirs as $dir)
{
	if (trim($dir) == '')
	{
		continue;
	}

	new LibLoader($dir);
}

$http_hooks = (isset($hcf_config->{'http-hooks'}) && is_array($hcf_config->{'http-hooks'})) ? $hcf_config->{'http-hooks'} : [];
$hh = implode(',', $http_hooks);

InternalLogger::log()->info('HYPERCELL FRAMEWORK '.HCF_VERSION.' - core initialized for:' . $os . 
	' PHP-version: ' . PHP_VERSION . 
	' at: ' . realpath($cwd) . 
	' config: ' . $hcf_ini_path . 
	' shared-dir: ' . ((defined('HCF_SHARED')) ? HCF_SHARED : 'NONE') . 
	' attachment-dir: ' .((defined('HCF_ATT_OVERRIDE')) ? HCF_ATT_OVERRIDE : 'NONE') .
	' active hooks: '. '['.$hh.']'
);

// read the http-hooks section inside _hcf.core/surface.ini
if ((isset($_GET['!']) && isset($_SERVER['REQUEST_METHOD'])) ||
	(is_array($http_hooks) && isset($_SERVER['REQUEST_METHOD']) && in_array($_SERVER['REQUEST_METHOD'], $http_hooks)))
{
	$method = $_SERVER['REQUEST_METHOD'];
	$output = '';

	InternalLogger::log()->info('Using '.$method.'-HOOK...');

	try 
	{
		$output = Router::route();
	}
	catch (Exception $e) 
	{
		InternalLogger::log()->error($method.'-HOOK failed due following Exception (will be rethrown to surface):');
		InternalLogger::log()->error($e);

		throw $e;
	}

	InternalLogger::log()->info('...'.$method.'-HOOK finished - sending output: '.$output);
	
	if (ob_get_length() > 0)
	{
		$unexpected_output = ob_get_contents();
		InternalLogger::log()->warn('Unexpected output detected before sending router-response: ' . $unexpected_output);
	}

	ob_end_flush(); // if display-errors is true, this will be visible on the surfaces output (in most cases it's the browser)

	echo $output;
	exit;
}

if (ob_get_length() > 0)
{
	$unexpected_output = ob_get_contents();
	InternalLogger::log()->warn('Unexpected output detected before returning to surface: ' . $unexpected_output);
}

ob_end_flush(); // if display-errors is true, this will be visible on the surfaces output (in most cases it's the browser)

InternalLogger::log()->info('Returning to surface');
?>

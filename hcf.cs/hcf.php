<?php
define('HCF_VERSION', '1.0.0');// version of this copy
define('HCF_INI_FILE', 'surface.ini');// name of the cores initialisation file
define('CS_MAP_NAME', 'cellspace.map');// name of the cellspace's map file - also set inside the hcdk.cellspace.DataMapper

require_once __DIR__.'/_hcf.core/_hcf.core.php';

use \hcf\core\loader\AutoLoader as AutoLoader;
use \hcf\core\log\Internal as InternalLogger;
use \hcf\core\loader\LibLoader as LibLoader;
use \hcf\core\Utils as Utils;
use \hcf\core\remote\Invoker as RemoteInvoker;
use \hcf\web\Router as Router;

// this will load the hcf
new AutoLoader(__DIR__, __DIR__.'/'.CS_MAP_NAME);

$ilfqn = '\\'.Utils::HCFQN2PHPFQN(InternalLogger::FQN);

set_exception_handler([$ilfqn, 'exceptionHandler']);
register_shutdown_function([$ilfqn, 'errorHandler'], getcwd());// getcwd for php/apache path-change on shutdown (to resolve relative paths correctly)

InternalLogger::log()->info('HYPERCELL FRAMEWORK '.HCF_VERSION.' - core initialized for following environment:');
InternalLogger::log()->info(' - OS = ' . $os);
InternalLogger::log()->info(' - PHP = ' . PHP_VERSION);
InternalLogger::log()->info(' - CWD = ' . realpath($cwd));
InternalLogger::log()->info(' - INI = ' . $hcf_ini_path);

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

InternalLogger::log()->info(' - SHARE DIR = '.((defined('HCF_SHARED')) ? HCF_SHARED : 'NONE'));
InternalLogger::log()->info(' - ATTACHMENT DIR = '.((defined('HCF_ATT_OVERRIDE')) ? HCF_ATT_OVERRIDE : 'NONE'));

$http_hooks = (isset($hcf_config->{'http-hooks'}) && is_array($hcf_config->{'http-hooks'})) ? $hcf_config->{'http-hooks'} : [];
$hh = implode(',', $http_hooks);

InternalLogger::log()->info(' - HTTP-HOOKS = ['.$hh.']');

// read the http-hooks section inside _hcf.core/surface.ini
if ((isset($_GET['!']) && isset($_SERVER['REQUEST_METHOD'])) ||
	(is_array($http_hooks) && isset($_SERVER['REQUEST_METHOD']) && in_array($_SERVER['REQUEST_METHOD'], $http_hooks)))
{
	$method = $_SERVER['REQUEST_METHOD'];
	$output = '';

	InternalLogger::log()->info('Using '.$method.'-HOOK...');
	$output = Router::route();
	InternalLogger::log()->info('...'.$method.'-HOOK finished - sending output: '.$output);

	echo $output;
	exit;
}

InternalLogger::log()->info('Returning to surface');
?>

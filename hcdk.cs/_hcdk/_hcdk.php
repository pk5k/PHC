<?php
define('HCDK_VERSION', '1.0.0');

require_once __DIR__.'/vendor/vendor.php';

// hcdk.php.ClassParser exceptions
class MethodResolveException extends Exception {}
class PropertyResolveException extends Exception {}
class ClassParserException extends Exception {}

if( version_compare(PHP_VERSION, '5.4') < 0)
{
	throw new \RuntimeException('Hypercell Development Kit '.HCDK_VERSION.' requires PHP 5.4 or above');
}

// Get the internal logger
use \hcf\core\log\Internal as InternalLogger;

$os = php_uname();
$cwd = getcwd();

InternalLogger::log()->info('HYPERCELL DEVELOPMENT KIT '.HCDK_VERSION.' - initialized for environment:');
InternalLogger::log()->info(' - OS = ' . $os);
InternalLogger::log()->info(' - PHP = ' . PHP_VERSION);
InternalLogger::log()->info(' - CWD = ' . realpath($cwd));

InternalLogger::log()->info('Returning into {main}');
?>

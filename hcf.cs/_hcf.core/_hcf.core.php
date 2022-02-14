<?php
require_once __DIR__.'/vendor/vendor.php';
require_once __DIR__.'/loader/loader.php';
require_once __DIR__.'/dryver/dryver.php';

// placeholder exceptions
class PlaceholderException extends Exception {}
class PlaceholderParseException extends Exception {}

// xml exceptions
class XMLParseException extends Exception {}
class AttributeNotFoundException extends Exception {}

class FileNotFoundException extends Exception {}
class DirectoryNotFoundException extends Exception {}

// set timezone
date_default_timezone_set(ini_get('date.timezone'));

$hcf_ini_path = null;

// first, look in the current working directory if there is a initialisation file - this will override the rme.ini inside this directory
if (file_exists('./'.HCF_INI_FILE))
{
	$hcf_ini_path = './'.HCF_INI_FILE;
}
// try the ini inside the root directory
else if (file_exists(__DIR__.'/../'.HCF_INI_FILE))
{
	$hcf_ini_path = __DIR__.'/../'.HCF_INI_FILE;
}
// no? die.
else
{
	throw new \RuntimeException('initialisation file "'.HCF_INI_FILE.'" for hcf.core does not exist inside the engine-package\'s root, nor inside the current working directory - cannot proceed');
}

$hcf_config_parser = new IniParser($hcf_ini_path);
$hcf_config = $hcf_config_parser->parse();

// check if the configuration uses document-sections
if (!array_key_exists('include', (array)$hcf_config))
{
	// if the include array does not exist on the highest node-level of the parsed configuration, it must be an ini with document sections
	$sec = basename($_SERVER['PHP_SELF'], '.php');// resolve the section name by the called document

	if (isset($hcf_config->$sec))
	{
		$hcf_config = $hcf_config->$sec;
		$hcf_ini_path .= '['.$sec.']';//for the logs
	}
	else 
	{
		throw new \RuntimeException('Document-section "'.$sec.'" does not exist inside '.$hcf_ini_path);
	}
}
// else, the configuration will be used for every document inside this working directory

$cwd = getcwd();
$os = php_uname();

// INCLUDES
if (!isset($hcf_config->include))
{
	throw new \RuntimeException('Missing configuration "include" in "'.$hcf_ini_path.'". Unable to proceed.');
}

// ATTACHMENT DIR
if (isset($hcf_config->attachments) && is_string($hcf_config->attachments))
{
	$att_dir = realpath($hcf_config->attachments);// make absolute to be independent of the cwd

	if (substr($att_dir, -1) !== '/')
	{
		// add trailing slash if not set...
		$att_dir .= '/';
	}

	define('HCF_ATT_OVERRIDE', $att_dir);
	// don't define a default value - use the defined method
}

// SHARED DIR
if (isset($hcf_config->shared) && is_string($hcf_config->shared))
{
	$shared_dir = $hcf_config->shared;// dont use realpath here - this value is also meant for browsers

	if (substr($shared_dir, -1) !== '/')
	{
		// add trailing slash if not set...
		$shared_dir .= '/';
	}

	define('HCF_SHARED', $shared_dir);
}

// STRICT MODE
if (!isset($hcf_config->strict) || $hcf_config->strict == true)
{
	error_reporting(E_ALL);
	define('HCF_STRICT', true);
}
else 
{
	define('HCF_STRICT', false);
}

// ERROR REPORTING
if (isset($hcf_config->{'display-errors'}) && $hcf_config->{'display-errors'} == true)
{
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
}
else if (!isset($hcf_config->{'display-errors'}) || $hcf_config->{'display-errors'} == false)
{
	ini_set('display_errors', 0);
	ini_set('display_startup_errors', 0);
}

// core initialisation finished.
?>

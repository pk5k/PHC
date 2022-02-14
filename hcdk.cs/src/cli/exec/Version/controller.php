<?php
use \hcf\core\Utils as Utils;

trait Controller
{
	public function execute($argv, $argc)
	{
		echo Utils::newLine().'> PHP: '.PHP_VERSION.'@'.php_sapi_name();
		echo Utils::newLine().'> Hypercell Framework (HCF): '.HCF_VERSION;
		echo Utils::newLine().'> Hypercell Development Kit (HCDK): '.HCDK_VERSION;
		echo Utils::newLine().Utils::newLine();
	}
}
?>
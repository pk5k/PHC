<?php
if (version_compare(PHP_VERSION, '5.4') < 0)
{
	throw new \RuntimeException('Hypercell Framework '.HCF_VERSION.' requires PHP 5.4 or above');
}

if (!file_exists(__DIR__.'/hcf.cs'))
{
	throw new \RuntimeException('Cellspace "hcf.cs" does not exist inside "'.__DIR__.'"');
}

require_once __DIR__.'/hcf.cs/hcf.php';
?>
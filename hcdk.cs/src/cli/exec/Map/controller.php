<?php
use \hcf\core\Utils as Utils;
use \hcf\core\log\Internal as InternalLogger;
use \hcf\cli\Colors as CliColors;
use \hcdk\raw\Cellspace as Cellspace;

trait Controller
{
	public function execute($argv, $argc)
	{
		$__arg_dir = realpath($argv[0]);
		$__arg_wb = false;

		foreach ($argv as $arg_i => $arg) 
		{
			switch ($arg) 
			{
				case '--write-before':
				case '-wb':
					$__arg_wb = true;
					break;

				case '--at':
				case '-at':
					$__arg_dir = realpath($argv[$arg_i+1]);//next argument must be the directory
					break;
			}
		}

		try 
		{
			$tree = [];

			$cellspace = new Cellspace($__arg_dir);
			$map_data = $cellspace->readMap($__arg_wb);

			echo $map_data.Utils::newLine();
		}
		catch(\Exception $e)
		{
			InternalLogger::log()->error('Unable to generate cellspace-tree due following exception:');
			InternalLogger::log()->error($e);
		}
	}	
}
?>
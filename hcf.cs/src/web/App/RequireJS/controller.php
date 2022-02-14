<?php
use \ReflectionClass;
use \hcf\core\Utils;
use \hcf\core\log\Internal as InternalLogger;
use \hcf\core\loader\Autoloader;

trait Controller
{
	public static function provide()
	{
		$file = htmlspecialchars($_GET['js']);
		$name = substr($file, 1, -3);// omit leading / and trailing .js
		$class_name = Utils::HCFQN2PHPFQN($name);

		if (class_exists($class_name))
		{
			return self::fromHypercell($class_name, $file);
		}
		else 
		{
			return self::fromNodeModules($file, $name);
		}		
	}

	private static function getMappedFiles($base, $module_name, $module_path)
	{
		$map = $base.self::NODE_MODULES.self::NM_MAP;

		if (!file_exists($map))
		{
			return '';
		}

		$lines = file($map);
		$files = [];

		foreach ($lines as $line)
		{
			$parts = explode('=', $line);

			if (count($parts) < 2)
			{
				InternalLogger::log()->warn(self::FQN.' - node_modules map '.$map.' line '.$line.' is invalid. Skipping.');
				continue;
			}

			if (strtolower($parts[0]) == strtolower($module_name) ||
				strtolower($parts[1]) == strtolower($module_path))
			{
				$files[] = file_get_contents(trim($base.self::NODE_MODULES.str_replace('./', $parts[0].'/', $parts[1])));
			}
		}

		if (count($files) == 0)
		{
			return '';
		}

		return implode(Utils::newLine(), $files);
	}

	private static function fromNodeModules($file, $name)
	{
		$found = ''; 

		foreach (Autoloader::getInstances() as $active_cellspace)
		{
			$base = $active_cellspace->getDirectory();
			$found = self::getMappedFiles($base, $name, $file);

			if ($found != '')
			{
				header('Content-Type: '.Utils::getMimeTypeByExtension($file));
				return $found;
			}
		}

		header(Utils::getHTTPHeader(404));
		die();
	}

	private static function makeRequireAsync($base, $file, $content)
	{ 
		$c_base = $base;
		$c_file = $file;

		if (!isset($c_base) || !isset($c_file))
		{
			return '';
		}

		$matches = [];
		preg_match_all('^require\(([\'\.\/0-9a-zA-Z\"\_\-\@]+)\)\s?;\s?$^m', $content, $matches);

		$full = $matches[0];
		$paths = $matches[1];

		foreach ($paths as $i => $path) 
		{
			$use = $path;

			if (substr($path, 0, 3) == "'./")
			{
				$offset = Utils::getOffset(dirname($file), $base);
				$use = str_replace("'./", "'".$offset.'/', $path);
			}

			$content = str_replace($full[$i], self::requireAsync($use), $content);
		}

		return $content;
	}

	private static function fromHypercell($class_name, $file)
	{
		$rc = null;

		try 
		{
			$rc = new ReflectionClass($class_name);
		}
		catch (ReflectionException $e)
		{
			InternalLogger::log()->error($e);
			header(Utils::getHTTPHeader(404));
			die();
		}

		if ($rc->hasMethod('script'))
		{
			header('Content-Type: '.Utils::getMimeTypeByExtension($file));

			return $rc->getMethod('script')->invoke(null);
		}
		else 
		{
			header(Utils::getHTTPHeader(404));
			die();
		}
	}
}

?>
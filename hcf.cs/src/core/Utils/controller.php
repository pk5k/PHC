<?php
/**
 * Utils
 * A collection of static-methods, used across the framework
 *
 * @category Utils
 * @package rmf.core
 * @author Philipp Kopf
 */
trait Controller
{
	/**
	 * cutTrailingSlash
	 * Cut of the trailing "/" of a given path
	 *
	 * @param $path - string - the path where the trailing slash should be removed
	 *
	 * @return string - the path without the trailing slash
	 */
	public static function cutTrailingSlash($path)
	{
		if(strlen($path) > 2 && substr($path, -1) == '/')
		{
			$path = substr($path, 0, strlen($path) - 1);
		}

		return $path;
	}

	/**
	 * cleanPath
	 * Replaces backslashes with slashes and remove multiple slashes with a single one
	 *
	 * @param $path - string - the path to clean
	 *
	 * @return string - the cleaned path
	 */
	public static function cleanPath($path)
	{
		// replace backslashes with slashes
		$path = str_replace('\\', '/', $path);

		// remove multiple slashes
		$path = preg_replace('/\/+/', '/', $path);

		// and done
		return $path;
	}

	/**
	 * isValidRMFQN
	 * Checks, if a given string is a valid raw-merge full-qualified-name
	 *
	 * @param $rmfqn - string - the rmfqn which should be checked
	 *
	 * @return boolean - true, if the given rmfqn is valid, false if not
	 */
	public static function isValidRMFQN($rmfqn)
	{
		$regex 	= '/^([a-zA-Z0-9\._]+)$/';
		$result = preg_match($regex, $rmfqn);

		if($result === 1)
		{
			return true;
		}
		else if($result === false)
		{
			throw new \RuntimeException('An error occured while checking "'.$rmfqn.'" against regex '.$regex);
		}
		else
		{
			return false;
		}
	}

	/**
	 * pathToRMName
	 * Converts a given path to a raw-merge name
	 *
	 * @param $path - string - the path to convert
	 *
	 * @return string - the path, converted to a raw-merge name
	 */
	public static function pathToRMName($path)
	{
		//First, remove all non-classname-conform chars (excepts \ and /)
		$path = preg_replace('~[^\\w/\\\\]+~i', '', $path);

		// And now convert all back-/slashes to dots
		$path = str_replace('/', '.', str_replace('\\', '/', $path));

		// Cut off dots at the beginning/end
		$path = trim($path, '.');

		return $path;
	}

	/**
	 * pathToHCName
	 * Converts a given path to a hypercell-name
	 *
	 * @param $path - string - the path to convert
	 *
	 * @return string - the path, converted to a raw-merge name
	 */
	public static function pathToHCName($path)
	{
		//First, remove all non-classname-conform chars (excepts \ and /)
		$path = preg_replace('~[^\\w/\\\\]+~i', '', $path);

		// And now convert all back-/slashes to dots
		$path = str_replace('/', '.', str_replace('\\', '/', $path));

		// Cut off dots at the beginning/end
		$path = trim($path, '.');

		return $path;
	}

	/**
	 * HCFQN2PHPFQN
	 * HyperCellFullQualifiedName2PHPFullQualifiedName
	 * Converts a HCFQN (FQN with dots) to a PHPFQN (FQN with backslashes)
	 *
	 * @param $hypercell_fqn - string - the full-qualified-name which should be converted to a PHPFQN
	 *
	 * @return string - the RMFQN converted to a PHPFQN
	 */
	public static function HCFQN2PHPFQN($hypercell_fqn)
	{
		$php_fqn = str_replace('.', '\\', $hypercell_fqn);

		return $php_fqn;
	}

	/**
	 * PHPFQN2HCFQN
	 * PHPFullQualifiedName2HyperCellFullQualifiedName
	 * Converts a PHPFQN (FQN with backslashes) to a HCFQN (FQN with dots)
	 *
	 * @param $php_fqn - string - the full-qualified-name which should be converted to a HCFQN
	 *
	 * @return string - the PHPFQN converted to a HCFQN
	 */
	public static function PHPFQN2HCFQN($php_fqn)
	{
		$hc_fqn = str_replace('\\', '.', $php_fqn);

		return $hc_fqn;
	}

	/**
	 * newLine
	 * Adds a line-break to a string
	 *
	 * @return string - a line-break
	 */
	public static function newLine()
	{
		return "\r\n";
	}

	/**
	 * getAllSubDirectories
	 * Iterates over a given directory recursively to collect all contained directories
	 *
	 * @param $directory - string - the directory where all sub-directories should be found
	 * @param $directory_seperator - string - optional - specifies which character should be used, to split the directory-path
	 *
	 * @return array - an array, filled with all found directories inside $directory
	 */
	public static function getAllSubDirectories($directory, $directory_seperator = '/')
	{
		$dirs = array_map(function($item) use ($directory_seperator) { return $item . $directory_seperator;}, array_filter( glob( $directory . '*' ), 'is_dir') );

		foreach($dirs as $dir)
		{
			$dirs = array_merge($dirs, self::getAllSubDirectories($dir, $directory_seperator));
		}

		return $dirs;
	}

	/**
	 * getFilesByExtension
	 * Get all files recursively, starting from a given directory, which have a specified file-extension
	 *
	 * @param $extension - string/array - the file-extension/-s which should be searched; WITHOUT the "."
	 * @param $dir - string - the directory, the search starts from
	 *
	 * @throws UnexpectedValueException, DirectoryNotFoundException
	 * @return array - containing the full filepath for each file with the given extension
	 */
	public static function getFilesByExtension($extension, $dir)
	{
		$files = [];

		if(is_array($extension))
		{
			foreach ($extension as $key => $value)
			{
				$new_files = self::getFilesByExtension($value, $dir);
				$files = array_merge($files, $new_files);
			}

			return $files;
		}

		if(!is_string($extension))
		{
			throw new \UnexpectedValueException('Argument $extension is not a string.');
		}

		if(!isset($dir) && !file_exists($dir))
		{
			throw new \DirectoryNotFoundException('Directory "'.$dir.'" does not exist.');
		}

		if(substr($extension, 0, 1) === '.')
		{
			// Cut off the dot
			$extension = substr($extension, 1);
		}

		$directory = new \RecursiveDirectoryIterator($dir);
		$iterator = new \RecursiveIteratorIterator($directory);
		$regex = new \RegexIterator($iterator, '/^.+\.'.$extension.'$/i', \RecursiveRegexIterator::GET_MATCH);


		foreach($regex as $k => $v)
		{
			$files[] = $k;
		}

		return $files;
	}

	/**
	 * getOffset
	 * Make a path relative to another
	 *
	 * @param $absolute_path - string - the path which should made relative, e.g. $absolute_path = "/path/to/some/thing/"
	 * @param $absolute_origin - string - must be identical to beginning-part of $absolute_path, e.g. $absolute_origin = "/path/to/"
	 *
	 * @throws UnexpectedValueException
	 * @return string - the absolute path, relative to the absolute origin, e.g. "some/thing/"
	 */
	public static function getOffset($absolute_path, $absolute_origin)
	{
		// clean paths first
		$absolute_path 		= realpath(self::cleanPath($absolute_path));
		$absolute_origin 	= realpath(self::cleanPath($absolute_origin));

		$pos = strpos($absolute_path, $absolute_origin);

		if($pos === false)
		{
			throw new \UnexpectedValueException('Origin "'.$absolute_origin.'" is not part of path "'.$absolute_path.'"');
		}

		$out = substr($absolute_path, $pos + strlen($absolute_origin));

		if(substr($out, 0, 1) === '/')
		{
			// remove / at beginning, to make it relative to the absolute origin
			$out = substr($out, 1);
		}

		return $out;
	}

	/**
	 * buildPath
	 * Build a path on the filesystem recursively
	 *
	 * @param $path - string - the path which should be build
	 * @param $rights - int - optional - the permissions the new directories should get
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public static function buildPath($path, $rights = 0755)
	{
		$path = self::cleanPath($path);

		if(is_dir($path))
		{
			// If path already exists, we have nothing to do here.
			return;
		}

		// somehow, recursive mkdir doesn't work on xampp and mac
		$path = str_replace('\\', '/', $path);
		$dirs = explode('/', $path);
		$dir 	= '';

		foreach ($dirs as $part)
		{
			$dir.= $part.'/';

			if(!is_dir($dir) && strlen($dir)>0)
			{
				// http://stackoverflow.com/questions/6229353/permissions-with-mkdir-wont-work
				$old = umask(0);

				if(!(mkdir($dir)))
				{
					throw new \RuntimeException('Unable to create path "'.$path.'" in "'.getcwd().'".');
				}

				chmod($dir, (int)$rights);
				umask($old);
			}
	  	}
	}

	/**
	 * HCFQNtoPath
	 * Converts a full-qualified-name of a hypercell to a (theoretical) file-path
	 *
	 * @param $hcfqn - string - the FQN which should be converted into a path
	 *
	 * @return string - the converted FQN as path
	 */
	public static function HCFQNtoPath($hcfqn)
	{
		$out = str_replace('.', '/', $hcfqn);

		return $out;
	}

	/**
	 * getMimeTypeByExtension
	 * Returns the MIME-type for a given file-extension
	 *
	 * @param $filename - string - the file-extension for the MIME-type you want to find
	 *
	 * @return string - the MIME-type the given file-extension is associated with
	 */
	public static function getMimeTypeByExtension($filename)
	{
		$extension = substr($filename, strpos($filename, '.')+1);
    	$extension = strtolower($extension);

		if(isset(self::config()->MIME->{$extension}))
		{
			return self::config()->MIME->{$extension};
		}

		return null;
	}

	/**
	 * getHTTPHeader
	 * Get the header string (for PHP's header(...) function) for a given http-response-code
	 *
	 * @param $code - int - the code which should be translated to a header string
	 *
	 * @throws RuntimeException
	 * @return string - the given http code as header string
	 */
	public static function getHTTPHeader($code)
	{
		if(!isset(self::config()->HTTP->{$code}))
		{
			throw new \RuntimeException('No header definition found for HTTP-code '.$code.'.');
		}

		return self::config()->HTTP->{$code};
	}

	/**
	 * loadScript
	 * Loads a given PHP-file by PHPs "require" function and returns an array,
	 * containing classes, which where loaded trough this file
	 *
	 * @param $file - string - the path to the PHP-script, you want to load
	 *
	 * @throws FileNotFoundException
	 * @return array - each index is a class, loaded trough this method-execution
	 */
	public static function loadScript($file)
	{
		if(!file_exists($file))
		{
			throw new \FileNotFoundException('File "'.$file.'" does not exist');
		}

		$before = get_declared_classes();
		require_once $file;
		$after = get_declared_classes();

		$diff = array_diff($after, $before);

		return $diff;
	}

	/**
	 * removePath
	 * Removes a given path recursively - no matter if it's a directory or file
	 *
	 * @param $path - string - the path you want to remove from your filesystem
	 *
	 * @throws Exception
	 * @return void
	 */
	public static function removePath($path)
	{
		$iterator = new \DirectoryIterator($path);

        foreach($iterator as $fileinfo)
        {
			if($fileinfo->isDot())
			{
				continue;
			}

			if($fileinfo->isDir())
			{
				self::removePath($fileinfo->getPathname());

				@rmdir($fileinfo->getPathname());
			}

			if($fileinfo->isFile())
			{
				@unlink($fileinfo->getPathname());
			}
        }

        @rmdir($path);
    }

    /**
	 * copyPath
	 * Copies a given path recursively - no matter if it's a directory or file
	 *
	 * @param $src - string - the path you want to copy
	 * @param $dst - string - the destination directory of the copy
	 * @param $exc - array - names that won't be copied
	 * @throws Exception
	 * @return void
	 */
	public static function copyPath($src, $dst, $exc = null)
	{
		$exc = $exc ?: [];
    	$dir = opendir($src);

    	@mkdir($dst);

    	while(false !== ($file = readdir($dir)))
    	{
	        if (($file != '.' ) && ( $file != '..' ) && !in_array($file, $exc))
	        {
	            if(is_dir($src . '/' . $file))
	            {
	                self::copyPath($src . '/' . $file,$dst . '/' . $file);
	            }
	            else
	            {
	                copy($src . '/' . $file, $dst . '/' . $file);
	            }
	        }
	    }

	    closedir($dir);
    }

	/**
	 * isEmptyDirectory
	 * Check, if a given directory contains files, except hidden and system files
	 * like Thumbs.db or .DS_Store
	 *
	 * @param $dir - string - the directory to check
	 *
	 * @return boolean - true if no non-system files were found inside this directory, otherwise false
	 */
	public static function isEmptyDirectory($dir)
	{
	 	$contents = scandir($dir);
    	$bad = self::config()->{'system-files'};
    	$files = array_diff($contents, $bad);

		return (!count($files) ? true : false);
	}

	/**
	 * isValidAsName
	 * Check, if a given string can be used as variable/function name
	 * NOTICE: Source http://stackoverflow.com/a/3980179
	 *
	 * @param $string - string - the string that should be checked
	 *
	 * @return boolean - true, if it can be used as variable/function name, otherwise false
	 */
	public static function isValidAsName($string)
	{
		return ((preg_match('/^[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*$/', $string)) ? true : false);
	}

	/**
	* parseByteString
	* Converts e.g. an php.ini file-size string like 8M or 19mb to it's int value in bytes
	* NOTICE: Source http://php.net/manual/de/function.ini-get.php#106518
	*
	* @param $val - string - the file-size string to convert
	*
	* @return int - bytes which are represented by the input file-size string
	*/
	public static function parseByteString($val)
	{
		if (empty($val))
		{
			return 0;
		}

    $val = trim($val);

    preg_match('#([0-9]+)[\s]*([a-z]+)#i', $val, $matches);

    $last = '';

		if(isset($matches[2]))
		{
      $last = $matches[2];
    }

    if(isset($matches[1]))
		{
      $val = (int) $matches[1];
    }

    switch (strtolower($last))
    {
        case 'g':
        case 'gb':
            $val *= 1024;
        case 'm':
        case 'mb':
            $val *= 1024;
        case 'k':
        case 'kb':
            $val *= 1024;
    }

    return (int) $val;
	}
}
?>

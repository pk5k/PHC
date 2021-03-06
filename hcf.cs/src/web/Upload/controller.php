<?php
// TODO: add an client.js assembly?
use \hcf\core\log\Internal as InternalLogger;
use \hcf\core\Utils;

trait Controller
{
	public $message = array();
	public $state_indicator = null; //determinates, if upload was successful or not

	public function onConstruct($tunnel = null)
	{
		if (!self::uploadingAllowed())
		{
			throw new \Exception(self::FQN.' - unable to proceed, php.ini setting "file_uploads" is set to false');
		}

		if (isset($tunnel))
		{
			$config = self::config();

			if (!isset($config[$tunnel]))
			{
				throw new \Exception(self::FQN.' - Tunnel "'.$tunnel.'" doesn\'t exist in configuration');
			}

			$tunnel_obj = $config[$tunnel];
			$message = self::processFiles($tunnel_obj, $tunnel);

			$this->setMessage($message);

			if (count($message['errors'])>0)
			{
				if (isset($tunnel_obj->on->error))
				{
					$this->state_indicator = $tunnel_obj->on->error;
				}
				else
				{
					$this->state_indicator = 'error';
				}
			}
			else
			{
				if (isset($tunnel_obj->on->success))
				{
					$this->state_indicator = $tunnel_obj->on->success;
				}
				else
				{
					$this->state_indicator = 'success';
				}
			}
		}
		else
		{
			throw new \Exception(self::FQN.' - unable to proceed, no tunnel-id given');
		}
	}

	private static function uploadingAllowed()
	{
		$ini_setting = strtolower(ini_get('file_uploads'));

		switch ($ini_setting)
		{
			case 'true':
			case 'ok':
			case 'allow':
			case '1':
			case 'yes':
			case 'on':
			case 'enable':
				return true;

			default:
				return false;
		}
	}

	private function getMessage()
	{
		return $this->message;
	}

	private function setMessage($message)
	{
		$this->message = json_encode($message);
	}

	private static function resolveErrorCode($code, $tunnel_obj)
	{
		$tunnel_error_map = $tunnel_obj->error ?: (new \stdClass());

		switch ($code)
		{
            case UPLOAD_ERR_INI_SIZE:
                if (isset($tunnel_error_map->UPLOAD_ERR_INI_SIZE))
                {
                	$error = $tunnel_error_map->UPLOAD_ERR_INI_SIZE;
                }
                else
                {
                	$error = 'The uploaded file exceeds the upload_max_filesize directive in php.ini';
                }
                break;

            case UPLOAD_ERR_FORM_SIZE:
                if (isset($tunnel_error_map->UPLOAD_ERR_FORM_SIZE))
                {
                	$error = $tunnel_error_map->UPLOAD_ERR_FORM_SIZE;
                }
                else
                {
                	$error = 'The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form';
                }
                break;

            case UPLOAD_ERR_PARTIAL:
                if (isset($tunnel_error_map->UPLOAD_ERR_PARTIAL))
                {
                	$error = $tunnel_error_map->UPLOAD_ERR_PARTIAL;
                }
                else
                {
                	$error = 'The uploaded file was only partially uploaded';
                }
                break;

            case UPLOAD_ERR_NO_FILE:
                if (isset($tunnel_error_map->UPLOAD_ERR_NO_FILE))
                {
                	$error = $tunnel_error_map->UPLOAD_ERR_NO_FILE;
                }
                else
                {
                	$error = 'No file was uploaded';
                }
                break;

            case UPLOAD_ERR_NO_TMP_DIR:
                if (isset($tunnel_error_map->UPLOAD_ERR_NO_TMP_DIR))
                {
                	$error = $tunnel_error_map->UPLOAD_ERR_NO_TMP_DIR;
                }
                else
                {
                	$error = 'Missing a temporary folder';
                }
                break;

            case UPLOAD_ERR_CANT_WRITE:
                if (isset($tunnel_error_map->UPLOAD_ERR_CANT_WRITE))
                {
                	$error = $tunnel_error_map->UPLOAD_ERR_CANT_WRITE;
                }
                else
                {
                	$error = 'Failed to write file to disk';
                }
                break;

            case UPLOAD_ERR_EXTENSION:
                if (isset($tunnel_error_map->UPLOAD_ERR_EXTENSION))
                {
                	$error = $tunnel_error_map->UPLOAD_ERR_EXTENSION;
                }
                else
                {
                	$error = 'File upload stopped by extension';
                }
                break;

            default:
            	$error = 'Unknown upload error';
        }

        return $error;
	}

	private static function sizeIsAllowed($current_file_size, $allowed_file_size, $tunnel_name)
	{
		$current_file_size = Utils::parseByteString($current_file_size);
		$allowed_file_size = Utils::parseByteString($allowed_file_size);
		$allowed_by_ini = Utils::parseByteString(ini_get('upload_max_filesize'));

		if ($allowed_by_ini <= $allowed_file_size)
		{
			InternalLogger::log()->warn(self::FQN.' - the php.ini setting "upload_max_filesize" (= '.$allowed_by_ini.'bytes) is lower than the allowed size of the configuration tunnel "'.$tunnel_name.'" (= '.$allowed_file_size.'bytes) - this may lead to problems due to further file processing');
		}

		if ($current_file_size <= $allowed_file_size)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	private static function extensionIsAllowed($current_file_extension, $allowed_extensions)
	{
		foreach ($allowed_extensions as $allowed_extension)
		{
			$lc_extension = strtolower($allowed_extension);
			$lc_current_file_extension = strtolower($current_file_extension);

			if ($lc_extension == $lc_current_file_extension)
			{
				return true;
			}
		}

		return false;
	}

	private static function moveUploadedFile($temp_path, $new_destination)
	{
		if (substr($new_destination, 0, 1) != '/')
		{
			// if a relative destination path is given, prepend the HCF_SHARED directory
			$new_destination = HCF_SHARED.'/'.$new_destination;
		}

		return move_uploaded_file($temp_path, $new_destination);
	}

	private static function processFile($current_file, $current_tunnel, $message, $tunnel_name)
	{
		$name = $current_file['name'];

		if ($current_file['error'] != 0)
    {
    	$message['errors'][] = self::resolveErrorCode($current_file['error'], $current_tunnel);
    }

    if ($current_file['error'] == 0)
    {
      if (!self::sizeIsAllowed($current_file['size'], $current_tunnel['max_size'], $tunnel_name))
      {
          $message['errors'][] = self::resolveErrorCode(UPLOAD_ERR_FORM_SIZE, $current_tunnel);
      }
			else if (!self::extensionIsAllowed(pathinfo($name, PATHINFO_EXTENSION), $current_tunnel['allow']))
			{
				$message['errors'][] = self::resolveErrorCode(UPLOAD_ERR_EXTENSION, $current_tunnel);
			}
	    else
	    { // No error found - move uploaded file
	    	$prefix = '';

	      if (isset($current_tunnel->overwrite) && !$current_tunnel['overwrite'])
	      {
	      	$prefix = microtime(true).'-';
	      }

	      if (self::moveUploadedFile($current_file["tmp_name"], $current_tunnel['destination'].$prefix.$name))
	      {
	      	$message['successful'][] = $current_tunnel['destination'].$prefix.$name;
	    	}
	    	else
	    	{
	    		$message['errors'][] = 'Unable to move file "'.$current_file['tmp_name'].'" to "'.$current_tunnel['destination'].$prefix.$name.'"';
	    	}
	    }
    }

    return $message;
	}

	private static function processFiles($current_tunnel, $tunnel_name)
	{
		$message = array();
		$message['errors'] = array();
		$message['successful'] = array();

		$key = key($_FILES);

		if (isset($key) && !is_null($key))
		{
			if (is_array($_FILES[$key]['name']))
			{
				foreach ($_FILES[$key]['name'] as $f => $name)
				{
				    $current_file = array();
				    $current_file['name'] = $_FILES[$key]['name'][$f];
				    $current_file['error'] = $_FILES[$key]['error'][$f];
				    $current_file['size'] = $_FILES[$key]['size'][$f];
				    $current_file['tmp_name'] = $_FILES[$key]['tmp_name'][$f];

				    $message = self::processFile($current_file, $current_tunnel, $message, $tunnel_name);
				}
			}
			else
			{
				$message = self::processFile($_FILES[$key], $current_tunnel, $message, $tunnel_name);
			}
		}
		else
		{
			$message['errors'][] = 'Unable to process request due to an unknown error';
		}

		return $message;
	}
}
?>

<?php
use \hcf\core\log\Internal as InternalLogger;
use \hcf\core\remote\Invoker as RemoteInvoker;
use \hcf\core\Utils as Utils;

/**
 * Server
 * This is the Bridge from http to the Hypercell framework
 *
 * @category Remote method invocation / http communication
 * @package hcf.access.http.Bridge
 * @author Philipp Kopf
 * @version 1.0.0
 */
trait Controller
{
	private $output = '';
	private $header_sent = false;

	/**
	 * __construct
	 * Sets up the instance and defines the http-response by a given list of arguments
	 *
	 * @param args - array - arguments which decide the target-Hypercell and what happens with it
	 */

	public function onConstruct()
	{
		try
		{
			$this->setup();

			$args = self::getArgs();

			if (!isset($args) || !is_array($args))
			{
				throw new \RuntimeException('Passed argument-array for Hypercell '.self::FQN.' is not a valid array');
			}

			$this->action($args);
		}
		catch(\Exception $e)
		{
			$this->sendHeader(500);

			throw $e;
		}
	}

	/**
	 * getArgs
	 * Get the arguments, the bridge should work with
	 *
	 * @throws RuntimeException
	 * @return array - the arguments, the bridge should work with
	 */
	private static function getArgs()
	{
		if (!isset($_POST))
		{
			return [];
		}

		return $_POST;
	}

	/**
	 * setup
	 * checks if the config.ini is ok for further processing
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	private function setup()
	{
		if (Utils::parseByteString(ini_get('post_max_size')) > 0 &&
				Utils::parseByteString(ini_get('post_max_size')) < Utils::parseByteString(ini_get('upload_max_filesize')))
		{
			InternalLogger::log()->warn(self::FQN.' - your php.ini setting "post_max_size" is neither set to 0 nor is it higher than the allowed "upload_max_filesize" configuration - this may lead to a loss of information when uploading big files trough '.self::FQN);
		}

		$config = self::config();

		if (!isset($config))
		{
			throw new \RuntimeException('Cannot find config for Hypercell '.self::FQN);
		}

		if (!isset($config->header->target))
		{
			throw new \RuntimeException('Hypercell '.self::FQN.' does not contain configuration for "header.target" - cannot proceed');
		}

		if (!isset($config->header->method))
		{
			throw new \RuntimeException('Hypercell '.self::FQN.' does not contain configuration for "header.target" - cannot proceed');
		}
	}

	/**
	 * action
	 * Triggers an action, decided by a list of passed arguments
	 * if target can't be decided, a 404 http-response will be sent
	 *
	 * @param args - array which decides the action that should be performed
	 *
	 * @throws RuntimeException
	 * @return void
	 */
	public function action($args)
	{
		$config = self::config();
		$action = null;
		$section = null;
		$whitelist = null;
		$target	= null;

		$method_header = 'HTTP_'.strtoupper(str_replace('-', '_', $config->header->method));
		$target_header = 'HTTP_'.strtoupper(str_replace('-', '_', $config->header->target));

		if (!isset($_SERVER[$target_header]))
		{
			$this->sendHeader(400);

			throw new \Exception(self::FQN.' - unable to find "target" http-header "'.$target_header.'"');
		}
		
		if (!isset($_SERVER[$method_header]))
		{
			$this->sendHeader(400);

			throw new \Exception(self::FQN.' - unable to find "method" http-header "'.$method_header.'"');
		}

		$target = $_SERVER[$target_header];
		$method = $_SERVER[$method_header];

		if (!isset($config->allow) || !is_array($config->allow))
		{
			throw new \RuntimeException(self::FQN.' - missing whitelist "allow" in configuration.');
		}

		$allow = false;

		foreach ($config->allow as $allowed_pattern)
		{
			if (fnmatch($allowed_pattern, $target))
			{
				$allow = true;
				break;
			}
		}

		if (!$allow)
		{
			$this->sendHeader(403);

			throw new \RuntimeException(self::FQN.' - target-Hypercell "'.$target.'" is not on the whitelist');
		}

		$output = $this->httpInvoke($target, $method, $args);

		$this->setOutput($output);
		// now output this Hypercell to send the response
	}

	/**
	 * setOutput
	 * Converts a given value to it's string-representation and defines the output property for the http-response
	 *
	 * @param data - mixed - the data which should be converted to a string
	 *
	 * @return void
	 */
	private function setOutput($data)
	{
		if (is_numeric($data) || is_string($data))
		{
			$this->output = $data;
		}
		else if (is_bool($data))
		{
			$this->output = ($data) ? 'true' : 'false';
		}
		else if (is_object($data))
		{
			$this->output = serialize($data);
		}
		else if (is_array($data))
		{
			$this->output = '['.implode(', ', $data).']';
		}
		else
		{
			$type = gettype($data);

			throw new \RuntimeException('data-type "'.$data.'" cannot be converted into string');
		}
	}

	/**
	 * sendHeader
	 * sends a given http-header via header(...)
	 *
	 * @param header_code - int - the code-number of the http-header (e.g. 500 for Internal Server Error)
	 *
	 * @return void
	 */
	private function sendHeader($header_code)
	{
		if (!$this->header_sent)
		{
			$header = Utils::getHTTPHeader($header_code);

			header($header);

			$this->header_sent = true;
		}
	}

	/**
	 * httpInvoke
	 * Invokes a given method of the target
	 *
	 * @param section - object - the config-section which leads to this method
	 * @param target - string - the target-Hypercell for this action
	 * @param args - array - the argument array which was used for this routing
	 *
	 * @return mixed - data, which should be send as http-response
	 */
	private function httpInvoke($target, $method, $args)
	{
		if (strpos($method, '#') === false)
		{
			// dont trigger the constructor for this
			RemoteInvoker::implicitConstructor(false);
		}
		else
		{
			list ($method, $flag) = explode('#', $method);

			switch (strtolower($flag))
			{
				case 'implicit':
					RemoteInvoker::implicitConstructor(true);
					break;

				default:
					InternalLogger::log()->warn(self::FQN. ' - found flag offset, but given flag "'.$flag.'" is unknown.');
					RemoteInvoker::implicitConstructor(false);
			}
		}

		$args = $this->filterArgs($args);
		$invoker = new RemoteInvoker($target, $args);

		return $invoker->invoke($method, $args);
	}

    private function filterArgs($args)
    {
        if (!is_array($args))
        {
            return [];
        }

        $ret = [];

        foreach ($args as $key => $arg)
        {
            if (!is_numeric($key))
            {
                continue;
            }

            $ret[$key] = $arg;
        }

        return $ret;
    }
}
?>

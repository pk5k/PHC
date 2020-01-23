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

			if(!isset($args) || !is_array($args))
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
		if(!isset($_POST))
		{
			throw new \RuntimeException('No arguments received - bridge "'.self::FQN.'" can\'t be executed');
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

		if(!isset($config))
		{
			throw new \RuntimeException('Cannot find config for Hypercell '.self::FQN);
		}

		if(!isset($config->header->action))
		{
			throw new \RuntimeException('Hypercell '.self::FQN.' does not contain configuration for "header.action" - cannot proceed');
		}

		if(!isset($config->header->target))
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

		$action_header = 'HTTP_'.strtoupper(str_replace('-', '_', $config->header->action));
		$target_header = 'HTTP_'.strtoupper(str_replace('-', '_', $config->header->target));

		if (!isset($_SERVER[$action_header]))
		{
			$this->sendHeader(400);

			throw new \Exception(self::FQN.' - unable to find "action" http-header "'.$action_header.'"');
		}

		$action = $_SERVER[$action_header];

		if (!isset($_SERVER[$target_header]))
		{
			$this->sendHeader(400);

			throw new \Exception(self::FQN.' - unable to find "target" http-header "'.$target_header.'"');
		}

		$target = $_SERVER[$target_header];

		if (!isset($config->$action))
		{
			throw new \Exception(self::FQN.' - unable to find section for action "'.$action.'"');
		}

		$section = $config->$action;

		if (!isset($section->action) || !is_string($section->action))
		{
			throw new \RuntimeException('missing action-method in configuration for action "'.$action.'"');
		}

		if (!is_callable([$this, $section->action]))
		{
			throw new \RuntimeException('action-method for action "'.$action.'" is not callable');
		}

		if (!isset($section->allow) || !is_array($section->allow))
		{
			throw new \RuntimeException('missing whitelist "allow" in configuration for action "'.$action.'"');
		}

		$allow = false;

		foreach ($section->allow as $allowed_pattern)
		{
			if(fnmatch($allowed_pattern, $target))
			{
				$allow = true;
				break;
			}
		}

		if(!$allow)
		{
			$this->sendHeader(403);

			throw new \RuntimeException('target-Hypercell "'.$target.'" is not on the whitelist for action "'.$action.'"');
		}

		$action_method = $section->action;
		$output = $this->$action_method($section, $target, $args);

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
		if(is_numeric($data) || is_string($data))
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
		if(!$this->header_sent)
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
	private function httpInvoke($section, $target, $args)
	{
		if(!isset($section->method_key))
		{
			throw new \RuntimeException('missing method-key in configuration for action "'.__METHOD__.'"');
		}

		$method_key = $section->method_key;

		if(!isset($args[$method_key]))
		{
			throw new \RuntimeException('missing method-key in arguments for action "'.__METHOD__.'"');
		}

		// clean arguments

		$method = $args[$method_key];
		$method_args = [];

		foreach($args as $key => $value)
		{
			if ($key !== $method_key)
			{
				$method_args[$key] = $value;
			}
		}

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

		$invoker = new RemoteInvoker($target, $method_args);

		return $invoker->invoke($method, $method_args);
	}

	/**
	 * httpRender
	 * Invokes the output channel of a Hypercell
	 *
	 * @param section - object - the config-section which lead to this method
	 * @param target - string - the target-Hypercell for this action
	 * @param args - array - the argument array which was used for this routing
	 *
	 * @return mixed - data, which should be send as http-response
	 */
	private function httpRender($section, $target, $args)
	{
		// trigger the constructor for this
		RemoteInvoker::implicitConstructor(true);

		$invoker = new RemoteInvoker($target, $args);// pass the arguments to it's constructor

		return $invoker->invoke('toString');
	}
}
?>

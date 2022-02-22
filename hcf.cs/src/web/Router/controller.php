<?php
use \hcf\core\Utils as Utils;
use \hcf\core\log\Internal as IL;
use \hcf\core\remote\Invoker as RI;
use \hcf\web\Page;

trait Controller
{
	public static function route()
	{
		$arg = self::config()->arg;
		$route_section = null;
		$match = [];

		if (!isset($_GET['!']))
		{
			if (isset($_GET[$arg]))
			{
				$route_section = htmlspecialchars($_GET[$arg]);
			}
			else if (isset(self::config()->default))
			{
				$route_section = self::config()->default;
			}
			else
			{
				IL::log()->error(self::FQN.' - cannot find routing-arg "'.$arg.'" in $_GET parameters and no default route was set - error 500 will be send');

				return self::renderError(500);
			}
		}
		else
		{
			$route_section = $_GET['!'];
		}

		return self::routeBySection($route_section);
	}

	public static function routeSectionTarget($route_section, $get_chosen_route = false)
	{
		$config = self::config();

		if (!isset($config->$route_section))
		{
			return null;
		}

		$req_method = strtolower($_SERVER['REQUEST_METHOD']);
		$output_hc = null;

		if (isset($config->$route_section->output))
		{
			$output_hc = $config->$route_section->output;
		}
		else if (isset($config->$route_section->$req_method))
		{
			$output_hc = $config->$route_section->$req_method->output;
		}
		else
		{
			IL::log()->error(self::FQN.' - route-section "'.$route_section.'" doesn\'t have an output nor '.$req_method.'.output configuration - error 404 will be send');

			return self::renderError(404);
		}

		return self::resolveTarget($output_hc, $route_section, $get_chosen_route);
	}

	public static function routeBySection($route_section, $return_instance = false)
	{
		$config = self::config();

		if (!isset($config->$route_section))
		{
			IL::log()->error(self::FQN.' - route-section "'.$route_section.'" doesn\'t exist - error 404 will be send');

			return self::renderError(404);
		}

		$req_method = strtolower($_SERVER['REQUEST_METHOD']);
		$output_hc = null;

		if (isset($config->$route_section->output))
		{
			$output_hc = $config->$route_section->output;
		}
		else if (isset($config->$route_section->$req_method))
		{
			$output_hc = $config->$route_section->$req_method->output;
		}
		else
		{
			IL::log()->error(self::FQN.' - route-section "'.$route_section.'" doesn\'t have an output nor '.$req_method.'.output configuration - error 404 will be send');

			return self::renderError(404);
		}

		return self::getOutput($output_hc, $route_section, $return_instance);
	}

	private static function constructorArgs()
	{
		return [$_GET];
	}

	private static function catchException(\Exception $e, $output_hc, $route_section, $target_only = false, $target_only_with_route = false)
	{
		$config = self::config();

		$new_route_section = false;
		$type = get_class($e);
	    $type_hcfqn = Utils::PHPFQN2HCFQN($type);

	    $scope = null;

	    if (isset($config->$route_section->catch))
	    {
	    	$scope = $config->$route_section->catch;
	    }

	    // maybe the php-class name was used (or something like "Exception")
	    if (isset($scope->$type) && is_string($scope->$type))
	    {
	    	$new_route_section = $scope->$type;
	    }
	    else if (!is_null($scope))
	    {
	        // INI Parser maps catch[hcfqn.to.an.Exception] into sub-objects splittet by dots
	        $type_parts = explode('.', $type_hcfqn);

	        foreach ($type_parts as $part)
	        {
	            if (isset($scope->$part))
	            {
	                if (is_object($scope->$part))
	                {
	                    $scope = $scope->$part;
	                }
	                else if (is_string($scope->$part))
	                {
	                    $new_route_section = $scope->$part;
	                }
	            }
	        }
	    }


	    if (!is_string($new_route_section))
	    {
			if (ini_get('display_errors') == 0)
			{
				// don't display errors -> don't throw up the exception to the exceptionHandler -> instead, show error-page 500 if defined and log the exception manually
				IL::log()->error($e);

				return self::renderError(500);
			}
			else
			{
				IL::log()->info(self::FQN . ' - hypercell ' . $output_hc . ' failed during execution of route-section ' . $route_section . ' and no catch was found for Exception '.$type_hcfqn.' - exception will be thrown up to stdOut since display_errors is enabled');
				throw $e; // let the exceptionHandler render and log the stacktrace for this exception
			}
	    }
	    else
	    {
	        IL::log()->info(self::FQN . ' - hypercell ' . $output_hc . ' failed during execution of route-section ' . $route_section . ' - redirecting to route-section ' . $new_route_section);

	        if ($target_only)
	        {
	        	return self::routeSectionTarget($new_route_section, $target_only_with_route);
	        }
	        else
	        {
	        	return self::routeBySection($new_route_section);
	        }
	    }
	}

	private static function getOutput($output_hc, $route_section, $return_instance = false)
	{
		$config = self::config();

		try
		{
			$class = Utils::HCFQN2PHPFQN($output_hc);

			if (is_subclass_of($class, Page::class))
			{
				$class::checkPermissions();
			}

			RI::implicitConstructor(true);

			$ri = new RI($output_hc, self::constructorArgs());

			if ($return_instance)
			{
				return $ri->getInstance();
			}

			return $ri->invoke('toString');
		}
		catch (\Exception $e)
		{
      		return self::catchException($e, $output_hc, $route_section);
		}
	}

	private static function resolveTarget($output_hc, $route_section, $get_chosen_route = false)
	{
		$config = self::config();

		try
		{
			$class = Utils::HCFQN2PHPFQN($output_hc);

			if (!is_subclass_of($class, Page::class))
			{
				throw new \Exception(self::FQN.' - target ' . $output_hc.' is no hcf.web.Page instance, target cannot be resolved.');
			}

			$class::checkPermissions();

			if ($get_chosen_route)
			{
				return [$class, $route_section]; 
			}

			return $class;
		}
		catch (\Exception $e)
		{
      		return self::catchException($e, $output_hc, $route_section, true, $get_chosen_route);
		}
	}

	private static function renderError($error_code)
	{
		// only override http-response-code if no error code is already defined
		if (!headers_sent() && http_response_code() <= 200)
		{
			header(Utils::getHTTPHeader($error_code));
		}

		$sent_error_code = http_response_code();
		$errs = isset(self::config()->error) ? self::config()->error : [];

		if (isset($errs[$sent_error_code]) && is_readable($errs[$sent_error_code]))
		{
			$location = $errs[$sent_error_code];

			return @file_get_contents($location);
		}
		else
		{
			return 'Error '.$sent_error_code;
		}
	}
}
?>

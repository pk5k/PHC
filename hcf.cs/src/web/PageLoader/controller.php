<?php
use \hcf\core\Utils;
use \hcf\web\Router;
use \hcf\web\Page;

trait Controller
{
	public static function load($route, $cache_map, $arguments = null)
	{
		$cache_map = json_decode($cache_map);
		$route = htmlspecialchars($route);
		list ($target, $chosen_route) = Router::routeSectionTarget($route, true);

		if (!is_subclass_of($target, Page::class))
		{
			throw new \Exception(self::FQN.' - '.$target::FQN.' is no hcf.web.Page instance.');
		}

		$fqn = $target::FQN;
		$out = new \stdClass();

		if ($chosen_route != $route)
		{
			$out->redirect = $chosen_route;
		}
		else if (isset($cache_map->{$fqn}))// no caching on redirects
		{
			$out->is_cached_as = $fqn;

			return json_encode($out);
		}

		$out = self::applyPreloads($out, $fqn);
		$out->which = $fqn;
		$out->view = $target::wrappedElementName(false);// disable autoload to render instance below and add it later (one request less per page and only hcf.web.PageLoader must be add to hcf.web.Bridge config)

		$instance = new $target($arguments);
		$out->rendered = $instance->toString();

		return json_encode($out);
	}

	private static function routerDefault()
	{
		return Router::config()->default;
	}

	private static function routerArg()
	{
		return Router::config()->arg;
	}

	private static function applyPreloads($out, $fqn)
	{
		$c = self::config();

		if (isset($c->{$fqn}))
		{
			$out->preload = $c->{$fqn};

			if (is_array($out->preload)) // shorthand if no context except global is required
			{
				$old = $out->preload;
				$out->preload = new \stdClass();
				$out->preload->global = $old;
			}

			if (isset($out->preload->{'//'}))
			{
				unset($out->preload->{'//'});// remove comment
			}

			if (!isset($out->preload->global))
			{
				$out->preload->global = [];
			}

			array_unshift($out->preload->global, $fqn);
		}
		else 
		{
			$out->preload = new \stdClass();
			$out->preload->global = [$fqn];
		}

		return $out;
	}
}
?>
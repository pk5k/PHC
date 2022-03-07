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
		$conf = self::config();

		if ($chosen_route != $route && isset($conf->redirect) && $conf->redirect)
		{
			$out->redirect = $chosen_route;
		}
		else if (isset($cache_map->{$fqn}))// no caching on redirects
		{
			$out->is_cached_as = $fqn;

			return json_encode($out);
		}

		$fastpath = isset($conf->fastpath) ? $conf->fastpath : true;

		$out = self::applyPreloads($out, $fqn);
		$out->which = $fqn;
		$out->title = $target::title();
		$out->view = $target::wrappedElementName(!$fastpath, true, $arguments);
			// set render-changes to true, disable autoload to render instance below and add it later (one request less per page and only hcf.web.PageLoader must be add to hcf.web.Bridge config)

		if ($fastpath)
		{
			$instance = new $target($arguments);
			$out->rendered = $instance->toString();
		}

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
		$default = isset($c->context) ? $c->context : 'global';

		if (isset($c->{$fqn}))
		{
			$out->preload = $c->{$fqn};

			if (is_array($out->preload)) // shorthand if no context except default is required
			{
				$old = $out->preload;
				$out->preload = new \stdClass();
				$out->preload->$default = $old;
			}

			if (isset($out->preload->{'//'}))
			{
				unset($out->preload->{'//'});// remove comment
			}

			if (!isset($out->preload->$default))
			{
				$out->preload->$default = [];
			}

			array_unshift($out->preload->$default, $fqn);
		}
		else 
		{
			$out->preload = new \stdClass();
			$out->preload->$default = [$fqn];// if nothing set only load the target page resources
		}

		return $out;
	}
}
?>
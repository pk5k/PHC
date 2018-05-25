<?php
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'JS';
	}

	protected function sourceIsAttachment()
	{
		return false;
	}

	protected function minifyJS($js_data)
	{
		if(self::config()->jshrink->minify)
		{
			$keep = (self::config()->jshrink->{'keep-doc-blocks'}) ? true : false;

			$flagged_comments = ['flaggedComments' => $keep];

			return \JShrink\Minifier::minify($js_data, $flagged_comments);
		}

		return $js_data;
	}

	public function buildClient()
	{
		$client_data = str_replace('"', '\\"', $this->minifyJS($this->rawInput()));
		$client_data = str_replace('$', '\\$', $client_data);//Escape the $ for e.g. jQuery

		$method = new Method('script', ['public', 'static']);
		$method->setBody($this->buildClientMethod($client_data));

		//$client_data = $this->processPlaceholders($client_data);

		return $method;
	}

	public function getStaticMethods()
	{
		$methods = [];

		$methods['script'] = $this->buildClient();

		return $methods;
	}

	public function defaultInput() { return '{}'; }

	public function getTraits()
	{
		return ['Client' => '\\hcf\\core\\dryver\\Client', 'ClientJs' => '\\hcf\\core\\dryver\\Client\\Js'];
	}
}
?>

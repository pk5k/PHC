<?php
use \ScssPhp\ScssPhp\Compiler as scssc;
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'SCSS';
	}

	public function sourceIsAttachment()
	{
		return false;
	}

	private function compile($scss)
	{
		$compiler = new scssc();
		$import_path = dirname($this->for_file);

		// add the assemblies directory (hypercell folder) as import path, so we can use imports
		$compiler->addImportPath($import_path);
		$compiler->setFormatter('ScssPhp\ScssPhp\Formatter\Compressed');

		return $compiler->compile($scss);
	}

	private function buildMethodBody()
	{
		$body = 'return \'';
		$body .= str_replace("'", "\'", $this->compile($this->rawInput()));
		$body .= '\';';

		return $body;
	}

	public function styleMethod()
	{
		$method = new Method('style', ['public', 'static'], ['as_array' => 'false']);
		$method->setBody($this->tplBuildStyle());

		return $method->toString();
	}

	public function getMethods()
	{
		return null;
	}

	public function getStaticMethods()
	{
		$methods = [];

		$methods['style'] = $this->styleMethod();

		return $methods;
	}

	public function buildTemplate($name, $data)
	{
		return '';
	}

	public function defaultInput() { return ''; }

	public function getTraits()
	{
		return ['View' => '\\hcf\\core\\dryver\\View', 'ViewCss' => '\\hcf\\core\\dryver\\View\\Css'];
	}
}
?>

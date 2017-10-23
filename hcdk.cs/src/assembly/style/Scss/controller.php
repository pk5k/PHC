<?php
use Leafo\ScssPhp\Compiler as scssc;
use \hcdk\raw\Method as Method;

trait Controller
{
	public function getType()
	{
		return 'SCSS';
	}

	public function getIsAttachment()
	{
		return false;
	}

	private function compile($scss)
	{
		$compiler = new scssc();
		$import_path = dirname($this->for_file);

		// add the channel-source's directory as import path, so we can use imports
		$compiler->addImportPath($import_path);
		$compiler->setFormatter('Leafo\ScssPhp\Formatter\Compressed');

		return $compiler->compile($scss);
	}

	private function buildMethodBody()
	{
		$body = 'return \'';
		$body .= str_replace("'", "\'", $this->compile($this->rawInput()));
		$body .= '\';';

		return $body;
	}

	public function buildStyle()
	{
		$method = new Method('style', ['public', 'static'], ['as_array' => 'false']);
		$method->setBody($this->tplBuildStyle());

		return $method->toString();
	}
}
?>

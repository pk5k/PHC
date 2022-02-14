<?php
use \hcdk\raw\Method as Method;
use \hcdk\data\xml\Parser as XMLParser;

trait Controller
{
	// Assembly inherits from template.xml - only override traits and type here
	public function getType()
	{
		return 'HTML';
	}

	public function getTraits()
	{
		return ['Template' => '\\hcf\\core\\dryver\\Template', 'TemplateHtml' => '\\hcf\\core\\dryver\\Template\\Html'];
	}
}
?>

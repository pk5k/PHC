<?php
use \hcdk\raw\Method as Method;
use \hcdk\data\xml\Parser as XMLParser;

trait Controller
{
	public function getType()
	{
		return 'XML';
	}

	public function buildTemplate($name, $data)
	{
		// The Fragment-implementations inside hcdk.xml will process the placeholder by themselfes, because we can't detect, if the placeholder
		// is added in- or outside of the output-variable (the $betweem_double_quotes flag for Placeholder::process)
		// in further implementations, the placeholders should be processed here, to keep the Fragments "placeholder-independet"
		// $ph_output  =
		$output = XMLParser::parse($data['content'], $this->for_file);
		$method = new Method($name, $data['mod']);
		$method->setBody($this->buildTemplateMethod($output));

		return $method->toString();
	}
}
?>

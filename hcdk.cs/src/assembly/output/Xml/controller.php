<?php
use \hcdk\raw\Method as Method;
use \hcdk\data\xml\Parser as XMLParser;

trait Controller
{
	public function getType()
	{
		return 'XML';
	}

	public function build__toString()
	{
		// The Fragment-implementations inside hcdk.xml will process the placeholder by themselfes, because we can't detect, if the placeholder
		// is added in- or outside of the output-variable (the $betweem_double_quotes flag for Placeholder::process)
		// in further implementations, the placeholders should be processed here, to keep the Fragments "placeholder-independet"
		// $ph_output  = $this->processPlaceholders($this->raw_input);
		$output = XMLParser::parse($this->rawInput(), $this->for_file);
		$method = new Method('__toString', ['public']);
		$method->setBody($this->prependControlSymbols($this->template__toString($output)));

		return $method->toString();
	}
}
?>

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
		$input = $data['content'];
		$opt_attrs = XMLParser::matchOptionalAttributes($input);
		$output = XMLParser::parse($input, $this->for_file.', template-section "'.$name.'"');
		$method = new Method($name, $data['mod']);
		$attrs = '';

		if (count($opt_attrs) > 0)
		{
			$attrs = "'".implode("','", $opt_attrs)."'";
		}

		$method->setBody($this->prependControlSymbols($this->buildTemplateMethod($output, $attrs)));

		return $method->toString();
	}

	public function getTraits()
	{
		return ['Template' => '\\hcf\\core\\dryver\\Template', 'TemplateXml' => '\\hcf\\core\\dryver\\Template\\Xml'];
	}
}
?>

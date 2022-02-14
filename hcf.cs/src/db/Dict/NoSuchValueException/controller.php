<?php
trait Controller
{
	public $for_value = null;
	
	function onConstruct($for_value)
	{
		$this->message = 'Key for value "'.$for_value.'" does not exist.';
		$this->for_value = $for_value;
	}
}
?>
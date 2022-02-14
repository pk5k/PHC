<?php
namespace hcf\core\dryver
{
	require_once __DIR__.'/Output.xml.php';

	trait Output
	{
		public function toString()
		{
			return $this->__toString();
		}

		public abstract function __toString();
	}
}
?>

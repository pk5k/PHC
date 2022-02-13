<?php
namespace hcf\core\dryver
{
	require_once __DIR__.'/View.xml.php';
	require_once __DIR__.'/View.html.php';

	trait View
	{
		public function toString()
		{
			return $this->__toString();
		}

		public abstract function __toString();
	}
}
?>

<?php
namespace hcf\core\dryver
{
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

<?php 
trait Model 
{
	// hcf.web.Controller can be any javascript-class/-object/-function that will be added to it's namespace in the document if load
	// hcf.web.Component is the generalisation of this
	public static function wrappedClientController()
	{
		return self::wrappedClientControllerOnly(static::FQN, static::script());
	}

}
?>
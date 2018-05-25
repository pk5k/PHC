<?php
namespace hcf\core\dryver
{
  use \hcf\core\Utils as Utils;

  // The internal assembly is for providing basic methods for all other assemblys which can be used inside the whole Hypercell at runtime.
  // properties and methods defined here will always begin with an underscore (_), if the method is meant for internal-use only. This is due
  // possible naming conflicts with other, non-internal assemblys
  trait Internal
  {
    private static $_attachment_cache = [];

    // To decide, if placeholder-processors like "method" or "property" have to access static or non-static values.
  	// These placeholder will be translated to executable fragments of php-script, which will use this methods on execution of the specific assembly-methods
		private static function _constant($name, $__CLASS__, $_this)
  	{
  		return constant($__CLASS__.'::'.$name);
  	}

		private static function _call($name, $__CLASS__, $_this)
  	{
  		$args = func_get_args();
  		array_shift($args);//remove $name
      array_shift($args);//remove $__CLASS__
      array_shift($args);//remove $_this

  		$method = new \ReflectionMethod(__CLASS__, $name);

      // TODO: remove
  		if (!$method->isPublic())
  		{
  			$method->setAccessible(true);
  		}

  		if (count($args) > 0)
  		{
  			return $method->invokeArgs($_this, $args);
  		}
  		else
  		{
  			return $method->invoke($_this);
  		}
  	}

		private static function _property($name, $__CLASS__, $_this)
  	{
      // access nested properties inside objects by typing {{property:my_prop_obj.key1.level2}}
      $prop_val = null;
      $obj_access = false;
      $split = null;

      if (strpos($name, '.') > 0)
      {
        $split = explode('.', $name);
        $name = array_shift($split);
        $obj_access = true;
      }

  		$prop = new \ReflectionProperty(__CLASS__, $name);

  		if (!$prop->isPublic())
  		{
  			$prop->setAccessible(true);
  		}

  		if ($prop->isStatic())
  		{
  			$prop_val = static::${$name};
  		}
      else
      {
        $prop_val = $_this->$name;
      }

      if ($obj_access)
      {
        foreach ($split as $value)
        {
          if (!isset($prop_val->$value))
          {
            throw new \RuntimeException('Property key '.$value.' does not exist inside '.$name);
          }

          $prop_val = $prop_val->$value;
        }
      }

      return $prop_val;
  	}

		private static function _arg($args, $arg_no, $__CLASS__, $_this)
		{
			if (!is_array($args))
			{
				throw new \Exception('Invalid argument-array passed');
			}
			else if (!isset($args[$arg_no]))
			{
				throw new \Exception('Argument '.$arg_no.' not found');
			}

			return $args[$arg_no];
		}

		private static function _attachment($__FILE__, $__COMPILER_HALT_OFFSET__, $assembly, $type)
		{
			$assembly = strtolower($assembly);
			$type = strtolower($type);
      $cache_target = $assembly.'.'.$type;

      if (isset(self::$_attachment_cache[$cache_target]))
      {
        return self::$_attachment_cache[$cache_target]; 
      }

			if (defined('HCF_ATT_OVERRIDE'))
			{
				$path = HCF_ATT_OVERRIDE.self::FQN.'@'.$assembly.'.'.$type;//explicit use our own FQN

				if (file_exists($path))
				{
          $data = @file_get_contents($path);
          self::$_attachment_cache[$cache_target] = $data;

					return $data;
				}
			}

			if (!is_numeric($__COMPILER_HALT_OFFSET__) || $__COMPILER_HALT_OFFSET__ == 0)
			{
				throw new \RuntimeException('Unable to read attachment "'.$assembly.'.'.$type.'" of hypercell '.self::FQN.' - __COMPILER_HALT_OFFSET__ is not defined, __halt_compiler(); was not called inside "'.$__FILE__.'"');
			}

			$fp = fopen($__FILE__, 'rb');
			fseek($fp, $__COMPILER_HALT_OFFSET__);

			$all_attachments = (string)stream_get_contents($fp);
			$assembly = strtoupper($assembly);
			$type = strtoupper($type);

			//matches T_attachmentFrame from hcdk.raw.Hypercell
			$bs = 'BEGIN['.$assembly;
			$bs .= (($type != '') ? ('.'.$type) : '').']';

			$es = 'END['.$assembly;
			$es .= (($type != '') ? ('.'.$type) : '').']';

			$begin = strpos($all_attachments, $bs) + strlen($bs);
			$end = strpos($all_attachments, $es) - 1;

			$attachment_data = substr($all_attachments, $begin, $end - $begin);

			if (!$attachment_data)
			{
				throw new \RuntimeException('Unable to read attachment "'.$assembly.'.'.$type.'" of hypercell '.self::FQN.' - unable to read from '.$bs.' to '.$es.' in "'.$__FILE__.'"');
			}

			if (!is_string($attachment_data))
			{
				throw new \RuntimeException('Unable to read attachment "'.$assembly.'.'.$type.'" of hypercell '.self::FQN.' - unable to read from '.$bs.' to '.$es.' in "'.$__FILE__.'"');
			}

      self::$_attachment_cache[$cache_target] = $attachment_data;

			return $attachment_data;
		}

    public static function hasAssembly($assembly_name = null)
    {
      if (!isset($assembly_name) || !is_string($assembly_name))
      {
        throw new \RuntimeException('Argument $assembly_name is invalid - cannot proceed');
      }

      $assembly_name = strtolower($assembly_name);
      $assemblys = static::allAssemblies();

      foreach ($assemblys as $assembly)
      {
        if ($assembly === $assembly_name)
        {
          return true;
        }
      }

      return false;
    }

    public static function allAssemblies()
    {
      $php_fqn = Utils::HCFQN2PHPFQN(static::FQN);

      $traits = class_uses($php_fqn);
      $assemblys = [];

      foreach ($traits as $trait)
      {
        $trait_split = explode('\\', $trait);
        $trait_short = array_pop($trait_split);

        $assemblys[$trait] = strtolower($trait_short);
      }

      return $assemblys;
    }
  }
}
?>

<?php
trait Controller 
{
	private static function mask($str, $mask, $undo = false)
	{
		$out = '';

		// double mask-string, until it's longer than $str
		while (strlen($mask) < strlen($str))
		{
			$mask .= $mask;
		}
		
		if ($undo)
		{
			$str = base64_decode($str);
		}

		$str_arr = str_split($str);
		$mask_arr = str_split($mask);

		foreach ($str_arr as $strpos => $char)
		{
			if (!$undo)
			{
				$out .= chr(ord($char) - ord($mask_arr[$strpos]));
			}
			else 
			{
				$out .= chr(ord($char) + ord($mask_arr[$strpos]));		
			}
		}

		if (!$undo)
		{
			$out = base64_encode($out);
		}

		return $out;
	}

   	public static function exists($cookie) 
    {
        return (isset($_COOKIE[$cookie]));
    }
   
    public static function isEmpty($cookie) 
    {
        return (empty($_COOKIE[$cookie]));
    }
   
    public static function get($cookie, $def_value='') 
    {
    	$options = self::options($cookie);
        $value = $def_value; 

        if (self::exists($cookie))
        {
        	$value = $_COOKIE[$cookie];

        	if (isset($options['mask']) && $options['mask'] != '')
        	{
        		$value = self::mask($value, $options['mask'], true);
        	}
		}

		return $value;
    }

    public static function options($cookie)
    {
    	if (!isset(self::config()->$cookie))
    	{
    		throw new \Exception(self::FQN.' - Cookie "'.$cookie.'" is not configured');
    	}

    	return self::config()->$cookie;
    }
   
    public static function set($cookie, $value)
    {
    	$options = self::options($cookie);
        $default_options = ['expiry'  => 31536000,//a year by default
                                'path'    => '/',
                                'domain'  => '',
                                'secure'  => (bool)false,
                                'httponly' => (bool)false,
                                'mask' => ''
                                ];
        $cookie_set = false;
       
        if (!headers_sent())
        {
            foreach ($default_options as $option_key=>$option_value) 
            {
                if (!array_key_exists($option_key, $options))
                {
                	$options[$option_key] = $default_options[$option_key];
                }
            }
           
            $options['domain'] = ((is_string($options['domain'])) ? $options['domain'] : '');
            $options['expiry'] = (int)((is_numeric($options['expiry']) ? ($options['expiry']+=time()) : strtotime($options['expiry'])));
           	$value = (($options['mask'] == '') ? $value : self::mask($value, $options['mask'], false));

            $cookie_set = @setcookie($cookie, $value, $options['expiry'], $options['path'], $options['domain'], $options['secure'], $options['httponly']);
            
            if ($cookie_set)
            {
            	$_COOKIE[$cookie] = $value;
            }
        }
       
        return $cookie_set;
    }
   
    public static function remove($cookie)
    {
    	$options = self::options($cookie);
        $default_options = ['path'        => '/',
                                'domain'      => '',
                                'secure'      => (bool)false,
                                'httponly'    => (bool)false,
                                'globalremove' => (bool)true
                               ];
        $return = false;
       
        if (!headers_sent())
        {
            foreach ($default_options as $option_key=>$option_value)
            {
                if (!array_key_exists($option_key, $options))
                {
                	$options[$option_key] = $default_options[$option_key];
                }
            }
           
            $options['domain'] = ((is_string($options['domain'])) ? $options['domain'] : '');
           
            if ($options['globalremove']) 
            {
            	unset($_COOKIE[$cookie]);
            }
           
            $return = @setcookie($cookie, '', (time()-3600), $options['path'], $options['domain'], $options['secure'], $options['httponly']);
        }
       
        return $return;
    }
}
?>

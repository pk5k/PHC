<?php
use \hcf\db\Connection as DatabaseConnection;
use \hcf\core\log\Internal as IL;
use \hcf\web\Cookie as Cookie;

trait Controller
{
	private static $raw_cache = null;// stores the whole result-set of the table - load at first use of hcf.db.Dict
	private static $dynamic_cache = [];// stores hcf.db.Dict instances that already were used due this execution
	private static $locale = null;

	private $key = null;
	private $value = null;

	public function onConstruct($key, $load_with_comments = false)
	{
		if ((bool)self::config()->connection->emulate === true)
		{
			IL::log()->warn(self::FQN.' - emulation mode is enabled');

			$this->key = $key;
			$this->value = $this->key;
			self::$raw_cache = [];
			return;
		}

		if (is_null(self::$raw_cache) || $load_with_comments)
		{
			// always reload if load_with_comments is true
			$this->loadDictToRawCache($load_with_comments);
		}

		if (self::EMPTY_KEY == $key)
		{
			return;
		}

		$this->key = $key;

		$this->loadValue();
		$this->writeDynamicCache();
	}

	private function writeDynamicCache()
	{
		if (!is_array(self::$dynamic_cache))
		{
			self::$dynamic_cache = [];
		}

		if (!isset(self::$dynamic_cache[self::$locale]))
		{
			self::$dynamic_cache[self::$locale] = [];
		}

		self::$dynamic_cache[self::$locale][$this->key] = $this;
	}

	private function loadValue()
	{
		$et = 'Cannot find Dictionary key "'.$this->key.'" for locale "'.self::$locale.'" - ';// base exeception

		if (!isset(self::$raw_cache[self::$locale]))
		{
			$e = new \RuntimeException($et.' locale does not exist');
			IL::log()->error($e);

			$this->value = self::NO_LOCALE_FALLBACK;// don't die, use the locale-fallback
		}
		else if (is_array(self::$raw_cache[self::$locale]) && !isset(self::$raw_cache[self::$locale][$this->key]))
		{
			$def_locale = self::config()->locale->default;
			$fb = self::$locale.'@'.$this->key;

			if (isset(self::$raw_cache[$def_locale]) && isset(self::$raw_cache[$def_locale][$this->key]))
			{
				$fb = self::$raw_cache[$def_locale][$this->key];
			}

			$e = new \RuntimeException($et.' key does not exist - using '.(is_array($fb) ? $fb[0] : $fb).' as fallback');
			// don't die here, use fallback and log a warning
			IL::log()->warn($e);
			$this->value = $fb;
		}
		else
		{
			$this->value = self::$raw_cache[self::$locale][$this->key];
		}

		if (is_array($this->value))
		{
			// raw_cache was loaded with comments
			$this->value = $this->value[0];
		}
	}

	public function apply()
	{
		if ((bool)self::config()->connection->emulate === true)
		{
			return $this->key;
		}

		$args = func_get_args();

		array_unshift($args, $this->value); // prepend value-string for sprintf
		$out = call_user_func_array('sprintf', $args);

		return $out;
	}

	private function loadDictToRawCache($with_comments = false)
	{
		self::$raw_cache = [];

		$stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($this->tplloadDict());
		$cols = self::config()->connection->table->col;

		$col_key = $cols->key;
		$col_value = $cols->value;
		$col_locale = $cols->locale;
		$col_comment = $cols->comment;

		if ($stmt->execute())
		{
			$results = $stmt->fetchAll(\PDO::FETCH_OBJ);

			foreach ($results as $result)
			{
				$key = $result->$col_key;
				$value = $result->$col_value;
				$locale = $result->$col_locale;
				$comment = $result->$col_comment;

				if (!isset(self::$raw_cache[$locale]))
				{
					self::$raw_cache[$locale] = [];
				}

				if (isset(self::$raw_cache[$locale][$key]))
				{
					IL::log()->warn(self::FQN.' - Key "'.$key.'" already exists for locale '.$locale.' and will be overridden');
				}

				if ($with_comments)
				{
					self::$raw_cache[$locale][$key] = [$value, $comment];
				}
				else
				{
					self::$raw_cache[$locale][$key] = $value;
				}
				//IL::log()->info(self::FQN.' - writing raw-cache '.$key.'@'.$locale.' = "'.$value.'"');
			}
		}
		else
		{
			$err = $stmt->errorInfo();
			$err_str = $err[0].' ('.$err[1].') '.$err[2];

		 	IL::log()->warn(self::FQN.' - unable to load dictionary due following error:');
		 	IL::log()->error($err_str);
		}
	}

	public static function locale($locale)
	{
		self::$locale = $locale;
	}

	private static function resolveLanguageCookie()
	{
		$resolved_lang = self::config()->locale->default;

		$name = self::config()->locale->cookie;
		$offset = null;

		if (is_object($name))
		{
			if (isset($name->offset))
			{
				$offset = $name->offset;
			}

			$name = $name->name;
		}

		if (Cookie::exists($name))
		{
			$data = Cookie::get($name);

			if (is_null($offset))
			{
				$resolved_lang = $data;
			}
			else 
			{
				// implies that cookies content is a JSON
				$data = json_decode($data);

				if (strpos($offset, '.') !== false)
				{
					$scope = $data;
					$split = explode('.', $offset);

					foreach ($split as $part)
					{
						if (isset($scope->$part))
						{
							$scope = $scope->$part;
						}
						else 
						{
							// setting does not exist
							return $resolved_lang;
						}
					}

					$resolved_lang = $scope;
				}
				else if (isset($data->$offset))
				{
					$resolved_lang = $data->$offset;
				}
			}
		}

		return $resolved_lang;
	}

	public static function get($key, $locale = null)
	{
		if (!isset(self::$locale))
		{
			if (!isset($locale))
			{
				self::$locale = self::resolveLanguageCookie();
			}
			else
			{
				self::$locale = $locale;
			}
		}

		if (isset(static::$dynamic_cache[self::$locale]) && isset(static::$dynamic_cache[self::$locale][$key]))
		{
			$dict = static::$dynamic_cache[self::$locale][$key];
			IL::log()->info('Load '.$dict->key.'@'.self::$locale.' from dynamic-cache');

			return $dict;
		}

		return new static($key);
	}

	public static function getRawCache($with_comments = false)
	{
		if (is_null(self::$raw_cache) || $with_comments)
		{
			$inst = new static(self::EMPTY_KEY, $with_comments);// loads the raw_cache
		}

		return self::$raw_cache;
	}

	// Methods for Dict administration
	public static function isValidDump($dump_data)
	{
		$do = is_string($dump_data) ? @json_decode($dump_data) : $dump_data;

		if (is_null($do))
		{
			// data is no valid json
			return false;
		}

		foreach ($do as $locale => $data)
		{
			if (!is_object($data))
			{
				// the value of a locale must be an object
				return false;
			}

			foreach ($data as $key => $value_or_object)
			{
				if (is_object($value_or_object))
				{
					if (!isset($value_or_object->value))
					{
						// missing value
						return false;
					}
				}
				else if (is_string($value_or_object))
				{
					// exported without comments, this is the value
					continue;
				}
				else
				{
					// this doesn't work
					return false;
				}
			}
		}

		return true;
	}

	private static function createDumpForLocale($which_locale, $with_comments)
	{
		$dd = self::getRawCache($with_comments);
		$o = new \stdClass();

		foreach ($dd[$which_locale] as $key => $data)
		{
			if ($with_comments)
			{
				$o->$key = new \stdClass();
				$o->$key->value = $data[0];
				$o->$key->comment = $data[1];
			}
			else
			{
				$o->$key = $data;
			}
		}

		return $o;
	}

	public static function createDump($for_locale = null, $with_comments = true)
	{
		$dump = new \stdClass();

		if (is_null($for_locale))
		{
			foreach (self::getRawCache($with_comments) as $locale => $data)
			{
				$dump->$locale = self::createDumpForLocale($locale, $with_comments);
			}
		}
		else
		{
			$dump->$for_locale = self::createDumpForLocale($for_locale, $with_comments);
		}

		$dump_str = @json_encode($dump, JSON_PRETTY_PRINT);

		if (is_null($dump_str))
		{
			throw new \Exception(self::FQN.' - unable to create dump for '.(is_null($for_locale) ? 'all locales' : 'locale "'.$for_locale.'"'));
		}

		return $dump_str;
	}

	public static function truncate($locale = null)
	{
		$ed = new static(self::EMPTY_KEY);
		$dbc = DatabaseConnection::to(self::config()->connection->name);
		$stmt = null;

		if (is_null($locale))
		{
			$stmt = $dbc->prepare($ed->tplTruncate());
		}
		else
		{
			$stmt = $dbc->prepare($ed->tplTruncateLocale($locale));
		}

		return $stmt->execute();
	}

	public static function add($locale, $key, $value, $comment)
	{
		$ed = new static(self::EMPTY_KEY);
		$stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($ed->tplCreateDictEntry($locale, $key, $value, $comment));

		return $stmt->execute();
	}

	public function update($new_value, $new_comment = '')
	{
		$stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($this->tplUpdateDictEntry($new_value, $new_comment));

		return $stmt->execute();
	}

	public function delete()
	{
		$stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($this->tplDeleteDictEntry());

		return $stmt->execute();
	}

}
?>

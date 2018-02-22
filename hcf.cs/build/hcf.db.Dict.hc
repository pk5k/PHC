<?php #HYPERCELL hcf.db.Dict - BUILD 18.02.22#63
namespace hcf\db;
class Dict {
    use \hcf\core\dryver\Config, \hcf\core\dryver\Constant, Dict\__EO__\Controller, \hcf\core\dryver\Output, \hcf\core\dryver\Template, \hcf\core\dryver\Internal;
    const FQN = 'hcf.db.Dict';
    const NAME = 'Dict';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'onConstruct')) {
            call_user_func_array([$this, 'onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    # BEGIN ASSEMBLY FRAME CONSTANT
    const EMPTY_KEY = '__EMPTY_KEY__';
    const NO_LOCALE_FALLBACK = '???MISSING LOCALE???';
    private static $_constant_list = ['EMPTY_KEY', 'NO_LOCALE_FALLBACK'];
    # END ASSEMBLY FRAME CONSTANT
    # BEGIN ASSEMBLY FRAME OUTPUT.TEXT
    public function __toString() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $output = "{$__CLASS__::_call('apply', $__CLASS__, $_this) }
";
        return $output;
    }
    # END ASSEMBLY FRAME OUTPUT.TEXT
    # BEGIN ASSEMBLY FRAME TEMPLATE.SQL
    public function tplLookupKey() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
SELECT key FROM {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) } WHERE VALUE = '{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }'

";
        return $sql;
    }
    public function tplLoadDict() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
SELECT * FROM {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) };


";
        return $sql;
    }
    public function tplCreateDictTable() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
CREATE TABLE {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) }
(
	 {$__CLASS__::_property('config.connection.table.col.key', $__CLASS__, $_this) } VARCHAR(255) NOT NULL PRIMARY KEY,
	 {$__CLASS__::_property('config.connection.table.col.locale', $__CLASS__, $_this) } VARCHAR(255),
	 {$__CLASS__::_property('config.connection.table.col.value', $__CLASS__, $_this) } TEXT,
	 {$__CLASS__::_property('config.connection.table.col.comment', $__CLASS__, $_this) } TEXT
);

";
        return $sql;
    }
    public function tplCreateDictEntry() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
INSERT INTO {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) } VALUES ('{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }', '{$__CLASS__::_arg(\func_get_args(), 1, $__CLASS__, $_this) }', '{$__CLASS__::_arg(\func_get_args(), 2, $__CLASS__, $_this) }', '{$__CLASS__::_arg(\func_get_args(), 3, $__CLASS__, $_this) }')

";
        return $sql;
    }
    public function tplUpdateDictEntry() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
UPDATE {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) } SET {$__CLASS__::_property('config.connection.table.col.value', $__CLASS__, $_this) } = '{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }', {$__CLASS__::_property('config.connection.table.col.comment', $__CLASS__, $_this) } = '{$__CLASS__::_arg(\func_get_args(), 1, $__CLASS__, $_this) }' WHERE {$__CLASS__::_property('config.connection.table.col.key', $__CLASS__, $_this) } = '{$__CLASS__::_property('key', $__CLASS__, $_this) }' AND {$__CLASS__::_property('config.connection.table.col.locale', $__CLASS__, $_this) } = '{$__CLASS__::_property('locale', $__CLASS__, $_this) }'

";
        return $sql;
    }
    public function tplDeleteDictEntry() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
DELETE FROM {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) } WHERE {$__CLASS__::_property('config.connection.table.col.key', $__CLASS__, $_this) } = '{$__CLASS__::_property('key', $__CLASS__, $_this) }' AND {$__CLASS__::_property('config.connection.table.col.locale', $__CLASS__, $_this) } = '{$__CLASS__::_property('locale', $__CLASS__, $_this) }'

";
        return $sql;
    }
    public function tplTruncate() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
TRUNCATE TABLE {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) }

";
        return $sql;
    }
    public function tplTruncateLocale() {
        $__CLASS__ = __CLASS__;
        $_this = (isset($this)) ? $this : null;
        $sql = "
DELETE FROM {$__CLASS__::_property('config.connection.table.name', $__CLASS__, $_this) } WHERE {$__CLASS__::_property('config.connection.table.col.locale', $__CLASS__, $_this) } = '{$__CLASS__::_arg(\func_get_args(), 0, $__CLASS__, $_this) }'
";
        return $sql;
    }
    # END ASSEMBLY FRAME TEMPLATE.SQL
    
}
namespace hcf\db\Dict\__EO__;
# BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
use \hcf\db\Connection as DatabaseConnection;
use \hcf\core\log\Internal as IL;
use \hcf\web\Cookie as Cookie;
use \hcf\db\Dict\NoSuchValueException;
trait Controller {
    private static $raw_cache = null; // stores the whole result-set of the table - load at first use of hcf.db.Dict
    private static $dynamic_cache = []; // stores hcf.db.Dict instances that already were used due this execution
    private static $locale = null;
    private $key = null;
    private $value = null;
    public function onConstruct($key, $load_with_comments = false) {
        if ((bool)self::config()->connection->emulate === true) {
            IL::log()->warn(self::FQN . ' - emulation mode is enabled');
            $this->key = $key;
            $this->value = $this->key;
            self::$raw_cache = [];
            return;
        }
        if (is_null(self::$raw_cache) || $load_with_comments) {
            // always reload if load_with_comments is true
            $this->loadDictToRawCache($load_with_comments);
        }
        if (self::EMPTY_KEY == $key) {
            return;
        }
        $this->key = $key;
        $this->loadValue();
        $this->writeDynamicCache();
    }
    private function writeDynamicCache() {
        if (!is_array(self::$dynamic_cache)) {
            self::$dynamic_cache = [];
        }
        if (!isset(self::$dynamic_cache[self::$locale])) {
            self::$dynamic_cache[self::$locale] = [];
        }
        self::$dynamic_cache[self::$locale][$this->key] = $this;
    }
    private function loadValue() {
        $et = 'Cannot find Dictionary key "' . $this->key . '" for locale "' . self::$locale . '" - '; // base exeception
        if (!isset(self::$raw_cache[self::$locale])) {
            $e = new \RuntimeException($et . ' locale does not exist');
            IL::log()->error($e);
            $this->value = self::NO_LOCALE_FALLBACK; // don't die, use the locale-fallback
            
        } else if (is_array(self::$raw_cache[self::$locale]) && !isset(self::$raw_cache[self::$locale][$this->key])) {
            $def_locale = self::config()->locale->default;
            $fb = self::$locale . '@' . $this->key;
            if (isset(self::$raw_cache[$def_locale]) && isset(self::$raw_cache[$def_locale][$this->key])) {
                $fb = self::$raw_cache[$def_locale][$this->key];
            }
            $e = new \RuntimeException($et . ' key does not exist - using ' . (is_array($fb) ? $fb[0] : $fb) . ' as fallback');
            // don't die here, use fallback and log a warning
            IL::log()->warn($e);
            $this->value = $fb;
        } else {
            $this->value = self::$raw_cache[self::$locale][$this->key];
        }
        if (is_array($this->value)) {
            // raw_cache was loaded with comments
            $this->value = $this->value[0];
        }
    }
    public function apply() {
        if ((bool)self::config()->connection->emulate === true) {
            return $this->key;
        }
        $args = func_get_args();
        array_unshift($args, $this->value); // prepend value-string for sprintf
        $out = call_user_func_array('sprintf', $args);
        return $out;
    }
    private function loadDictToRawCache($with_comments = false) {
        self::$raw_cache = [];
        $stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($this->tplloadDict());
        $cols = self::config()->connection->table->col;
        $col_key = $cols->key;
        $col_value = $cols->value;
        $col_locale = $cols->locale;
        $col_comment = $cols->comment;
        if ($stmt->execute()) {
            $results = $stmt->fetchAll(\PDO::FETCH_OBJ);
            foreach ($results as $result) {
                $key = $result->$col_key;
                $value = $result->$col_value;
                $locale = $result->$col_locale;
                $comment = $result->$col_comment;
                if (!isset(self::$raw_cache[$locale])) {
                    self::$raw_cache[$locale] = [];
                }
                if (isset(self::$raw_cache[$locale][$key])) {
                    IL::log()->warn(self::FQN . ' - Key "' . $key . '" already exists for locale ' . $locale . ' and will be overridden');
                }
                if ($with_comments) {
                    self::$raw_cache[$locale][$key] = [$value, $comment];
                } else {
                    self::$raw_cache[$locale][$key] = $value;
                }
                //IL::log()->info(self::FQN.' - writing raw-cache '.$key.'@'.$locale.' = "'.$value.'"');
                
            }
        } else {
            $err = $stmt->errorInfo();
            $err_str = $err[0] . ' (' . $err[1] . ') ' . $err[2];
            IL::log()->warn(self::FQN . ' - unable to load dictionary due following error:');
            IL::log()->error($err_str);
        }
    }
    public static function locale($locale) {
        self::$locale = $locale;
    }
    private static function resolveLanguageCookie() {
        $resolved_lang = self::config()->locale->default;
        $name = self::config()->locale->cookie;
        $offset = null;
        if (is_object($name)) {
            if (isset($name->offset)) {
                $offset = $name->offset;
            }
            $name = $name->name;
        }
        if (Cookie::exists($name)) {
            $data = Cookie::get($name);
            if (is_null($offset)) {
                $resolved_lang = $data;
            } else {
                // implies that cookies content is a JSON
                $data = json_decode($data);
                if (strpos($offset, '.') !== false) {
                    $scope = $data;
                    $split = explode('.', $offset);
                    foreach ($split as $part) {
                        if (isset($scope->$part)) {
                            $scope = $scope->$part;
                        } else {
                            // setting does not exist
                            return $resolved_lang;
                        }
                    }
                    $resolved_lang = $scope;
                } else if (isset($data->$offset)) {
                    $resolved_lang = $data->$offset;
                }
            }
        }
        return $resolved_lang;
    }
    public static function get($key, $locale = null) {
        if (!isset(self::$locale)) {
            if (!isset($locale)) {
                self::$locale = self::resolveLanguageCookie();
            } else {
                self::$locale = $locale;
            }
        }
        if (isset(static ::$dynamic_cache[self::$locale]) && isset(static ::$dynamic_cache[self::$locale][$key])) {
            $dict = static ::$dynamic_cache[self::$locale][$key];
            IL::log()->info('Load ' . $dict->key . '@' . self::$locale . ' from dynamic-cache');
            return $dict;
        }
        return new static ($key);
    }
    public static function getRawCache($with_comments = false) {
        if (is_null(self::$raw_cache) || $with_comments) {
            $inst = new static (self::EMPTY_KEY, $with_comments); // loads the raw_cache
            
        }
        return self::$raw_cache;
    }
    // Methods for Dict administration
    public static function isValidDump($dump_data) {
        $do = is_string($dump_data) ? @json_decode($dump_data) : $dump_data;
        if (is_null($do)) {
            // data is no valid json
            return false;
        }
        foreach ($do as $locale => $data) {
            if (!is_object($data)) {
                // the value of a locale must be an object
                return false;
            }
            foreach ($data as $key => $value_or_object) {
                if (is_object($value_or_object)) {
                    if (!isset($value_or_object->value)) {
                        // missing value
                        return false;
                    }
                } else if (is_string($value_or_object)) {
                    // exported without comments, this is the value
                    continue;
                } else {
                    // this doesn't work
                    return false;
                }
            }
        }
        return true;
    }
    private static function createDumpForLocale($which_locale, $with_comments) {
        $dd = self::getRawCache($with_comments);
        $o = new \stdClass();
        foreach ($dd[$which_locale] as $key => $data) {
            if ($with_comments) {
                $o->$key = new \stdClass();
                $o->$key->value = $data[0];
                $o->$key->comment = $data[1];
            } else {
                $o->$key = $data;
            }
        }
        return $o;
    }
    public static function createDump($for_locale = null, $with_comments = true) {
        $dump = new \stdClass();
        if (is_null($for_locale)) {
            foreach (self::getRawCache($with_comments) as $locale => $data) {
                $dump->$locale = self::createDumpForLocale($locale, $with_comments);
            }
        } else {
            $dump->$for_locale = self::createDumpForLocale($for_locale, $with_comments);
        }
        $dump_str = @json_encode($dump, JSON_PRETTY_PRINT);
        if (is_null($dump_str)) {
            throw new \Exception(self::FQN . ' - unable to create dump for ' . (is_null($for_locale) ? 'all locales' : 'locale "' . $for_locale . '"'));
        }
        return $dump_str;
    }
    public static function truncate($locale = null) {
        $ed = new static (self::EMPTY_KEY);
        $dbc = DatabaseConnection::to(self::config()->connection->name);
        $stmt = null;
        if (is_null($locale)) {
            $stmt = $dbc->prepare($ed->tplTruncate());
        } else {
            $stmt = $dbc->prepare($ed->tplTruncateLocale($locale));
        }
        return $stmt->execute();
    }
    public static function lookupKey($for_value) {
        $ed = new static (self::EMPTY_KEY);
        $stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($ed->tplLookupKey($for_value));
        if ($stmt->execute()) {
            $results = $stmt->fetchAll(\PDO::FETCH_OBJ);
            $cols = self::config()->connection->table->col;
            $col_key = $cols->key;
            if (!count($results)) {
                throw new NoSuchValueException($for_value);
            }
            foreach ($results as $result) {
                return $result->$col_key;
            }
        } else {
            $err = $stmt->errorInfo();
            $err_str = $err[0] . ' (' . $err[1] . ') ' . $err[2];
            IL::log()->warn(self::FQN . ' - unable to lookup key for value "' . $for_value . '" due following error:');
            IL::log()->error($err_str);
        }
    }
    public static function add($locale, $key, $value, $comment) {
        $ed = new static (self::EMPTY_KEY);
        $stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($ed->tplCreateDictEntry($locale, $key, $value, $comment));
        return $stmt->execute();
    }
    public function update($new_value, $new_comment = '') {
        $stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($this->tplUpdateDictEntry($new_value, $new_comment));
        return $stmt->execute();
    }
    public function delete() {
        $stmt = DatabaseConnection::to(self::config()->connection->name)->prepare($this->tplDeleteDictEntry());
        return $stmt->execute();
    }
}
# END EXECUTABLE FRAME OF CONTROLLER.PHP
__halt_compiler();
#__COMPILER_HALT_OFFSET__

BEGIN[CONFIG.INI]

[locale]
default = "de_DE"; default locale which will be used, if no other value was specified at runtime; if no value for the target-locale was found, the default locale will be used as fallback
cookie.name = "page-settings"; lookup for a cookie with this name, that contains the locale
cookie.offset = "lang"; inside the cookie above, this key points to the locale, implied that the cookie-content is a JSON -> page-settings = {"lang": "de_DE", "other-settings": {...}}

[connection]
emulate = false; emulate the connection below - good for "offline" development - the key will be used as value
name = "hcf.db.Connection"; a hcf.db.Connection
table.name = "hcf.db.Dict"; name of your table
table.col.key = "key"; name of the column, which holds the unique key of each entry
table.col.locale = "locale"; the locale, which defines the language
table.col.value = "value"; the actual text section in the correct language
table.col.comment = "comment"; additional comments for further developing can be stored here


END[CONFIG.INI]


?>



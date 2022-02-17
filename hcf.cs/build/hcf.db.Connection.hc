<?php #HYPERCELL hcf.db.Connection - BUILD 22.02.15#43
namespace hcf\db;
class Connection {
    use \hcf\core\dryver\Config, Connection\__EO__\Controller, \hcf\core\dryver\Internal;
    const FQN = 'hcf.db.Connection';
    const NAME = 'Connection';
    public function __construct() {
        if (!isset(self::$config)) {
            self::loadConfig();
        }
        if (method_exists($this, 'hcfdbConnection_onConstruct')) {
            call_user_func_array([$this, 'hcfdbConnection_onConstruct'], func_get_args());
        }
    }
    # BEGIN ASSEMBLY FRAME CONFIG.INI
    private static function loadConfig() {
        $content = self::_attachment(__FILE__, __COMPILER_HALT_OFFSET__, 'CONFIG', 'INI');
        $parser = new \IniParser();
        self::$config = $parser->process($content);
    }
    # END ASSEMBLY FRAME CONFIG.INI
    
    }
    namespace hcf\db\Connection\__EO__;
    # BEGIN EXECUTABLE FRAME OF CONTROLLER.PHP
    trait Controller {
        public static function to($connection_name) {
            // each config.ini section is one connection
            if (!is_string($connection_name)) {
                throw new \Exception('Given connection name is not a valid string');
            } else if (!isset(self::config()->$connection_name)) {
                throw new \Exception('Connection "' . $connection_name . '" does not exist');
            }
            $config = self::config()->$connection_name;
            $et = 'Cannot establish connection "' . $connection_name . '" - ';
            if (!isset($config->server)) {
                throw new \Exception($et . 'missing server address');
            }
            if (!isset($config->port)) {
                throw new \Exception($et . 'missing port');
            }
            if (!isset($config->type)) {
                throw new \Exception($et . 'missing database type');
            }
            if (!isset($config->database)) {
                throw new \Exception($et . 'missing database name');
            }
            if (!isset($config->username)) {
                throw new \Exception($et . 'missing username');
            }
            if (!isset($config->password)) {
                throw new \Exception($et . 'missing password');
            }
            if (!isset($config->charset)) {
                throw new \Exception($et . 'missing charset');
            }
            $pdo_options = [\PDO::ATTR_CASE => \PDO::CASE_NATURAL];
            if (isset($config->options) && is_array($config->options)) {
                $pdo_options = array_merge($pdo_options, $config->options);
            }
            return self::create($config->server, $config->port, $config->type, $config->database, $config->username, $config->password, $config->charset, $pdo_options);
        }
        public static function create($server, $port, $type, $database_name, $username, $password, $charset, $pdo_options) {
            $connection = null;
            //Not supported yet:
            $socket = false;
            $database_file = false;
            $commands = array();
            $is_port = isset($port);
            $dsn = null;
            $type = strtolower($type);
            switch ($type) {
                case 'mariadb':
                    $type = 'mysql';
                case 'mysql':
                    if ($socket) {
                        $dsn = $type . ':unix_socket=' . $socket . ';dbname=' . $database_name;
                    } else {
                        $dsn = $type . ':host=' . $server . ($is_port ? ';port=' . $port : '') . ';dbname=' . $database_name;
                    }
                    // Make MySQL using standard quoted identifier
                    $commands[] = 'SET SQL_MODE=ANSI_QUOTES';
                break;
                case 'pgsql':
                    $dsn = $type . ':host=' . $server . ($is_port ? ';port=' . $port : '') . ';dbname=' . $database_name;
                break;
                case 'sybase':
                    $dsn = 'dblib:host=' . $server . ($is_port ? ':' . $port : '') . ';dbname=' . $database_name;
                break;
                case 'oracle':
                    $dbname = $server ? '//' . $server . ($is_port ? ':' . $port : ':1521') . '/' . $database_name : $database_name;
                    $dsn = 'oci:dbname=' . $dbname . ($charset ? ';charset=' . $charset : '');
                break;
                case 'mssql':
                    $dsn = strstr(PHP_OS, 'WIN') ? 'sqlsrv:server=' . $server . ($is_port ? ',' . $port : '') . ';database=' . $database_name : 'dblib:host=' . $server . ($is_port ? ':' . $port : '') . ';dbname=' . $database_name;
                    // Keep MSSQL QUOTED_IDENTIFIER is ON for standard quoting
                    $commands[] = 'SET QUOTED_IDENTIFIER ON';
                break;
                case 'sqlite':
                    $dsn = $type . ':' . $database_file;
                    $username = null;
                    $password = null;
                break;
                default:
                    throw new \Exception('Unknown database type "' . $type . '" - cannot proceed');
            }
            try {
                $connection = new \PDO($dsn, $username, $password, $pdo_options);
                foreach ($commands as $value) {
                    $connection->exec($value);
                }
            }
            catch(\PDOException$e) {
                throw new \Exception($e->getMessage());
            }
            return $connection;
        }
    }
    # END EXECUTABLE FRAME OF CONTROLLER.PHP
    __halt_compiler();
    #__COMPILER_HALT_OFFSET__
BEGIN[CONFIG.INI]
; usage hcf.db.Connection::to('dummy-db'); returns a valid connection (PDO instance) to the refered db-section
[dummy-db]
server = "localhost"
port = 5432

database = "DummyDB"
type = "mysql"
charset = "utf-8"

username = "dbUser1"
password = "password1"

END[CONFIG.INI]

?>
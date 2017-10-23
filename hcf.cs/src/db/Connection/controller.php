<?php
trait Controller 
{
	public static function to($connection_name)
	{
		// each config.ini section is one connection
		if(!is_string($connection_name))
		{
			throw new \Exception('Given connection name is not a valid string');
		}
		else if(!isset(self::config()->$connection_name))
		{
			throw new \Exception('Connection "'.$connection_name.'" does not exist');
		}

		$config = self::config()->$connection_name;
		$et = 'Cannot establish connection "'.$connection_name.'" - ';

		if(!isset($config->server))
		{
			throw new \Exception($et.'missing server address');
		}

		if(!isset($config->port))
		{
			throw new \Exception($et.'missing port');
		}

		if(!isset($config->type))
		{
			throw new \Exception($et.'missing database type');
		}

		if(!isset($config->database))
		{
			throw new \Exception($et.'missing database name');
		}

		if(!isset($config->username))
		{
			throw new \Exception($et.'missing username');
		}

		if(!isset($config->password))
		{
			throw new \Exception($et.'missing password');
		}

		if(!isset($config->charset))
		{
			throw new \Exception($et.'missing charset');
		}

		$pdo_options = [\PDO::ATTR_CASE => \PDO::CASE_NATURAL];

		if(isset($config->options) && is_array($config->options))
		{
			$pdo_options = array_merge($pdo_options, $config->options);
		}

		return self::create($config->server, $config->port, $config->type, $config->database, $config->username, $config->password, $config->charset, $pdo_options);
	}

	public static function create($server, $port, $type, $database_name, $username, $password, $charset, $pdo_options)
	{
		$connection = null;

		//Not supported yet:
		$socket 		= false;
		$database_file	= false;
		$commands 	= array();
		$is_port 	= isset($port);

		$dsn = null;
		$type = strtolower($type);
		
		switch($type)
		{
			case 'mariadb':
				$type = 'mysql';

			case 'mysql':
				if ($socket)
				{
					$dsn = $type . ':unix_socket=' . $socket . ';dbname=' . $database_name;
				}
				else
				{
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
				$dsn = strstr(PHP_OS, 'WIN') ?
					'sqlsrv:server=' . $server . ($is_port ? ',' . $port : '') . ';database=' . $database_name :
					'dblib:host=' . $server . ($is_port ? ':' . $port : '') . ';dbname=' . $database_name;

				// Keep MSSQL QUOTED_IDENTIFIER is ON for standard quoting
				$commands[] = 'SET QUOTED_IDENTIFIER ON';
				break;

			case 'sqlite':
				$dsn = $type . ':' . $database_file;
				$username = null;
				$password = null;
				break;

			default:
				throw new \Exception('Unknown database type "'.$type.'" - cannot proceed');
		}

		try
		{
			$connection = new \PDO(
				$dsn, 
				$username,
				$password,
				$pdo_options
			);
		
			foreach ($commands as $value)
			{
				$connection->exec($value);
			}
		}
		catch (\PDOException $e) 
		{
			throw new \Exception($e->getMessage());
		}

		return $connection;
	}
	
}
?>
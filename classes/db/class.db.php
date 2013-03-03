<?php

/**
 *
 * MySQL Connection Class.
 * @author mheadd
 *
 */
class DB {

	private $connection;
	private $rowsAffected;
	private $statement_template = 'call %name%(%parameters%)';

	/*
	 * Class constructor.
	 */
	public function __construct($host, $user, $password, $dbname) {
		if(!$this->connection = new mysqli($host, $user, $password, $dbname)) {
			throw new DBException("Unable to connect to MySQL database.");
		}
	}

	/*
	 * Execute a SQL query.
	 */
	public function executeQuery($query) {
		$result = $this->connection->query($query);
		$this->rowsAffected = $this->connection->affected_rows;
			
		if(!$result) {
			throw new DBException("Unable to execute query: " . $query);
		}
		return $result;
	}

	/*
	 * Execute a stored procedure using the 'call' SQL syntax.
	 */
	public function executeStatement($name, Array $parameters=array()) {
		$params = "";
		$i = 0;
		foreach($parameters as $parameter) {
			$params .= self::checkType($parameter);
			if($i < count($parameters)-1) {
				$params .= ",";
			}
			$i++;
		}
		$statement = str_replace(array('%name%', '%parameters%'), array($name, $params), $this->statement_template);
		return self::executeQuery($statement);
	}

	/*
	 * Escape input.
	 */
	public function escapeInput($value) {
		return $this->connection->real_escape_string($value);
	}

	/*
	 * Get the number of rows affected bythe last SQL operation.
	 */
	public function getNumRowsAffected() {
		return $this->rowsAffected;
	}

	/*
	 * Class destructor.
	 */
	public function __destruct() {
		$this->connection->close();
	}
	
	/*
	 * Wrap strings in single quotes.
	 */
	private function checkType($var) {
		if(gettype($var) == "string") {
			return "'$var'";
		}
		return $var;
	}

}

// A simple wraper class for exceptions.
class DBException extends Exception {}

?>
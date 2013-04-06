<?php

// MySQL credentials and SQL queries.
define("DB_USER", getenv("MYSQL_USER"));
define("DB_PASS", getenv("MYSQL_PASS"));
define("DB_NAME", getenv("MYSQL_NAME"));
define("DB_HOST", getenv("MYSQL_HOST"));

// A label to use for logging errors (for greping syslog, yo).
define("LOG_LABEL", "SchoolData");

// Include required classes.
require 'classes/limonade/limonade.php';
require 'classes/db/class.db.php';

// Routes for HTTP requests.
dispatch('/', 'schoolsSummary');
dispatch('/:code/:data', 'schoolLookup');

// Run this sucker!
run();

/*
 * Return summary school info.
 */
function schoolsSummary() {
	try {

		// Get callback parameter (if used).
		@$callback = $_GET["callback"];

		// Render JSON response.
		return generateResponse('GetSchoolSummary', $callback);
	}
	catch (DBException $ex) {
		logError($ex->getMessage());
		header("HTTP/1.0 500 Internal Server Error");
	}
}

/*
 * Lookup school information.
 */
function schoolLookup() {
	try {
		
		// Extract parameters from URL.
		$code = (int) params('code');
		$data = params('data');

		// Get callback parameter (if used).
		@$callback = $_GET["callback"];

		// Render JSON response.
		$data = $data ? $data : 'school_information';
		return generateResponse('GetSchoolData', $callback, array($data, $code));
	}
	catch (DBException $ex) {
		logError($ex->getMessage());
		header("HTTP/1.0 500 Internal Server Error");
	}
}

/*
 * Generate the JSON response from the API.
 */
function generateResponse($name, $callback, Array $parameters=array()) {

	$response = json_encode(getData($name, $parameters));

	if($callback) {
		header('Content-type: application/javascript');
		return "$callback($response)";
	}
	else {
		header('Content-type: application/json');
		return $response;
	}

}

/*
 * Run SQL query to get school data.
 */
function getData($name, Array $parameters=array()) {
	$db = new DB(DB_HOST, DB_USER, DB_PASS, DB_NAME);
	$result = $db->executeStatement($name, $parameters);
	$json_array = array();
	while($row = mysqli_fetch_assoc($result)) {
		array_push($json_array, $row);	
	}
	return $json_array;
}

/*
 * Log an error.
 */
function logError($error) {
	openlog(LOG_LABEL, LOG_PID, LOG_LOCAL0);
	syslog(LOG_ERR, $error);
	closelog();
}

?>
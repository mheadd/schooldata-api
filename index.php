<?php

// MySQL credentials and SQL queries.
define("DB_USER", "");
define("DB_PASS", "");
define("DB_NAME", "schooldata");
define("DB_HOST", "");

// Include required classes.
require 'classes/limonade/limonade.php';
require 'classes/db/connect.php';

// Routes for HTTP requests.
dispatch('/', 'schoolsSummary');
dispatch('/:code/:data', 'schoolLookup');

// Return summary school info.
function schoolsSummary() {
	try {
		header('Content-type: application/json');
		return json_encode(getSchoolSummary());
	}
	catch (Exception $ex) {
		// TODO: Log exception message 
		header("HTTP/1.0 500 Internal Server Error");
	}
}

// Lookup school information.
function schoolLookup() {
	try {
		$code = (int) params('code');
		$data = params('data');
		header('Content-type: application/json');
		return json_encode(getSchoolData($code, $data));
	}
		catch (Exception $ex) {
		// TODO: Log exception message 
		header("HTTP/1.0 500 Internal Server Error");
	}
}

// Pass through function for summary information.
function getSchoolSummary() {
	return getData($db, "call GetSchoolSummary()");
}

// Pass through function for schol secific data.
function getSchoolData($code, $data=false) {
	$data = $data ? $data : 'school_information';
	return getData($db,"call GetSchoolData('$data', $code)");
}

// Run SQL query to get school data.
function getData(&$db, $procedure) {
	$db = new DBConnect(DB_HOST, DB_USER, DB_PASS);
	$db->selectDB(DB_NAME);
	$result = $db->runQuery($procedure);
	$json_array = array();
	while($row = mysql_fetch_assoc($result)) {
		array_push($json_array, $row);	
	}
	return $json_array;
}

// Run this sucker!
run();

?>
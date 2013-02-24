<?php

// MySQL credentials and SQL queries.
define("DB_USER", "");
define("DB_PASS", "");
define("DB_NAME", "schooldata");
define("DB_HOST", "");
define("DB_QUERY_TEMPLATE", "SELECT * FROM %tablename% WHERE school_code = '%code%';");
define("DB_SUMMARY_TEMPLATE", "select school_name_1, school_code, school_level_name, hpaddr, latitude, longitude from school_information;");

// Include required classes.
require 'classes/limonade/limonade.php';
require 'classes/db/connect.php';

// Routes.
dispatch('/', 'index');
dispatch('/:code/:data', 'lookup');

// Return suamry school info.
function index() {
	header('Content-type: application/json');
	return getSchoolSummary();
}

// Lookup school information.
function lookup() {

	$code = params('code');
	$data = params('data');
	header('Content-type: application/json');
	return getData($code, $data);
	
}

// Run SQL query to get school specific data.
function getData($code, $data=false) {

	$db = new DBConnect(DB_HOST, DB_USER, DB_PASS);
	$db->selectDB(DB_NAME);

	if($data) {
		$query = str_replace(array('%tablename%', '%code%'), array($data, $code), DB_QUERY_TEMPLATE);
	}
	else {
		$query = str_replace(array('%tablename%', '%code%'), array('school_information', $code), DB_QUERY_TEMPLATE);
	}

	$result = $db->runQuery($query);

	$json_array = array();
	while($row = mysql_fetch_assoc($result)) {
		array_push($json_array, $row);	
	}
	return json_encode($json_array);

}

// Run SQL query to get school sumamry infrormation.
function getSchoolSummary() {

	$db = new DBConnect(DB_HOST, DB_USER, DB_PASS);
	$db->selectDB(DB_NAME);

	$result = $db->runQuery(DB_SUMMARY_TEMPLATE);

	$json_array = array();
	while($row = mysql_fetch_assoc($result)) {		
		array_push($json_array, $row);	
	}
	return json_encode($json_array);

}

// Run this sucker!
run();

?>
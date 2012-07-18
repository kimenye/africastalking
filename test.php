<?php
	//  	$data = array('user' => 'abc');
	// echo http_build_query($data, '','&');
	$params = array(
			    'username' => "kimenyed",
			    'to'       => "+254705866564,+254706349037,+254727550098",
			    'message'  => "Hello world!");
	$data_ = http_build_query($params, '', '&');
	echo $data_;
	echo "\r\n";
?>

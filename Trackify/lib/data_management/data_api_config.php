<?php
$spotStats_admin = '';

$spotStats_admin_con = mysqli_connect('localhost:8889', 'root', 'root', 'SpotifyStats');

if (mysqli_errno($spotStats_admin_con)) {
	$spotStats_admin = 'Admin connection failure';
} else {
	$spotStats_admin = 'Admin connection success';
}

<?php

require_once('data_retrieval.php');
$query = isset($_POST['query']) ? $_POST['query'] : '';
$user = isset($_POST['user']) ? $_POST['user'] : '';
$cutOff = isset($_POST['cutOff']) ? $_POST['cutOff'] : '';
$readQueryAllRecords = '';
if ($query == 'tracks') {
	$readQueryAllRecords = "select * from tracks join 
    	(select trackId, count(trackId) as trackCount from listenData 
    	where userId = '$user' and dateListened >= '$cutOff'
    	group by trackId) as hold
    	on tracks.trackId = hold.trackId
	inner join artists on artists.artistId = tracks.artistId
		order by hold.trackCount desc;";
} else if ($query == 'artists') {
	$readQueryAllRecords = "select *, count(artists.artistId) as artistCount from artists join 
    		(select tracks.artistId from tracks inner join listenData on tracks.trackId = listenData.trackId
     		where listenData.userId = '$user' and listenData.dateListened >= '$cutOff'
    		) as hold
    		on artists.artistId = hold.artistId
		group by artists.artistId
		order by artistCount desc;";
} else if ($query == 'streak') {
	$readQueryAllRecords = "select dateListened from listenData where userId = '$user'
	order by dateListened desc;";
} else if ($query == 'songsListened') {
	$readQueryAllRecords = "select listenData.trackId, count(listenData.trackId) as count from listenData where userId = '$user' and listenData.dateListened >= '$cutOff' group by listenData.trackId;";
} else if ($query == 'listenHistory') {
	$readQueryAllRecords = "select * from listenData inner join (select trackId from tracks group by trackId) as hold 
		on hold.trackId = listenData.trackId inner join tracks on hold.trackId = tracks.trackId
		inner join artists on tracks.artistId = artists.artistId
		where listenData.userId = '$user'
		order by listenData.dateListened desc;";
} else {
	echo $query;
	return;
}

db_query('Read', $readQueryAllRecords);
//echo $readQueryAllRecords;
echo json_encode($this_status, JSON_PRETTY_PRINT | JSON_NUMERIC_CHECK);

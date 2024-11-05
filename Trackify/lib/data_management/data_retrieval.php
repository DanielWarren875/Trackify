<?php
require_once('data_api_config.php');

function db_query($queryType, $querySql)
{
	global $spotStats_admin_con;
	global $this_type;
	$this_type = $queryType;
	global $this_query;
	$this_query = $querySql;
	global $this_status;
	$this_status = '';

	global $last_id;

	switch ($this_type) {
		case 'Read':
			$get_query = mysqli_query($spotStats_admin_con, $this_query);
			$num_rows = mysqli_num_rows($get_query);

			if ($num_rows != 0) {
				while ($row = mysqli_fetch_assoc($get_query)) {
					$rows[] = $row;
				}

				$this_status = $rows;
			} else {
				$this_status = 'The records were not found!';
			}
			break;
	}
}

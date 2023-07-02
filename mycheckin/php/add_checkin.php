<?php
var_dump($_POST);

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$checkin_lat = $_POST['lat'];
$checkin_long = $_POST['long'];
$checkin_loc = $_POST['loc'];
$checkin_state = $_POST['state'];

$sqlinsert = "INSERT INTO `checkin_table`(`user_id`,`checkin_lat`, `checkin_long`, `checkin_loc`, `checkin_state`) VALUES ('$user_id','$checkin_lat','$checkin_long', '$checkin_loc', '$checkin_state')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	//$insertedCatchId = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	//$decoded_string = base64_decode($image);
	//$path = '../images/items/'.$filename.'.png';
	//file_put_contents($path, $decoded_string);

	// Process each image
	/*foreach ($base64Images as $base64Image) {
		// Decode the base64 image
		$decodedImage = base64_decode($base64Image);
		
		// Generate a unique filename for the image
		$filename = $user_id . '_' . $item_id . '_' . ($index);
		
		// Save the image to the server
		$path = '../assets/catches/' . $filename . 'png';

		file_put_contents($path, $decodedImage);
		
		// Insert image data into the database
		$sqlinsertImage = "INSERT INTO `tbl_catch_images`(`catch_id`, `image_path`) VALUES ('$insertedCatchId', '$filename')";
		$conn->query($sqlinsertImage);
	  }*/

    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
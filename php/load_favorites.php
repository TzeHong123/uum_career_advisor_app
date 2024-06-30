<?php
include_once("dbconnect.php");

$userid = $_POST['userid'];

// Debugging statement to check the user ID received
error_log("UserID received: " . $userid);

$sql = "SELECT * FROM tbl_posts WHERE post_id IN (SELECT post_id FROM tbl_post_favourites WHERE user_id = '$userid' AND added_to_fav = 1)";
$result = $conn->query($sql);

// Debugging statement to check the query execution
if ($result === false) {
    error_log("Query Error: " . $conn->error);
    $response = array('status' => 'failed', 'message' => 'Query Error: ' . $conn->error);
} else {
    if ($result->num_rows > 0) {
        $posts = array();
        while ($row = $result->fetch_assoc()) {
            $row['userHasLiked'] = $row['userHasLiked'] == 1 ? 1 : 0;
            $row['isFavorite'] = $row['isFavorite'] == 1 ? 1 : 0;
            $posts[] = $row;
        }
        $response = array('status' => 'success', 'data' => $posts);
    } else {
        $response = array('status' => 'failed', 'message' => 'No saved posts found');
    }
}

// Debugging statement to check the final response
error_log("Response: " . json_encode($response));

echo json_encode($response);
?>

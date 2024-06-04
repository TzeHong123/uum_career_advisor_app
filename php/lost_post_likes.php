<?php
if (!isset($_POST)) {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id']; // Assuming user_id is passed in POST request
$post_ids = isset($_POST['post_ids']) ? $_POST['post_ids'] : array(); // Assuming post_ids are passed as an array

if (empty($post_ids)) {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

// Convert post_ids array to a string for SQL IN clause
$post_ids_str = implode(',', array_map('intval', $post_ids));

// SQL to get likes count and user like status for each post
$sql = "SELECT post_id, 
               COUNT(*) AS likes, 
               SUM(IF(user_id = '$user_id', 1, 0)) AS userHasLiked 
        FROM tbl_post_likes 
        WHERE post_id IN ($post_ids_str) 
        GROUP BY post_id";

$result = $conn->query($sql);
$likesData = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $likesData[$row['post_id']] = array('likes' => $row['likes'], 'userHasLiked' => (bool)$row['userHasLiked']);
    }
}

sendJsonResponse(array('status' => 'success', 'data' => $likesData));

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

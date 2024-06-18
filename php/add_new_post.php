<?php
if (!isset($_POST['user_id']) || !isset($_POST['user_name']) || !isset($_POST['post_title']) || !isset($_POST['post_content'])) {
    $response = array('status' => 'failed', 'message' => 'Incomplete POST data');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$user_name = $_POST['user_name'];
$post_title = $_POST['post_title'];
$post_content = $_POST['post_content'];

$stmt = $conn->prepare("INSERT INTO `tbl_posts` (`user_id`, `user_name`, `post_title`, `post_content`) VALUES (?, ?, ?, ?)");
$stmt->bind_param("isss", $user_id, $user_name, $post_title, $post_content);

if ($stmt->execute()) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => $stmt->error);
    sendJsonResponse($response);
}

$stmt->close();
$conn->close();

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

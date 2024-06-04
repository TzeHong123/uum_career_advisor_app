<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'message' => 'No POST data found');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$user_name = $_POST['user_name'];
$question_title = $_POST['question_title'];
$question_content = $_POST['question_content'];

// You may need to escape the input data to prevent SQL injection
$question_title = $conn->real_escape_string($question_title);
$question_content = $conn->real_escape_string($question_content);

$sqlinsert = "INSERT INTO `tbl_questions` (`user_id`, `user_name`, `question_title`, `question_content`) VALUES ('$user_id', '$user_name', '$question_title', '$question_content')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Question added successfully');
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'Failed to add question');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

$conn->close();
?>

<?php
if (!isset($_POST)) {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

include_once("dbconnect.php");

// Get POST data
$question_id = $_POST['question_id'];
$question_title = $_POST['question_title'];
$question_content = $_POST['question_content'];

// SQL to update post
$sql = "UPDATE tbl_questions SET question_title = ?, question_content = ? WHERE question_id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("ssi", $question_title, $question_content, $question_id);
$result = $stmt->execute();

if ($result) {
    echo "success";
} else {
    echo "error";
}

$stmt->close();
$conn->close();
?>

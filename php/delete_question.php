<?php
if (!isset($_POST)) {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

include_once("dbconnect.php");

$question_id = $_POST['question_id'];

// SQL to delete a post
$sql = "DELETE FROM tbl_questions WHERE question_id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $question_id);
$result = $stmt->execute();

if ($result) {
    echo "success";
} else {
    echo "error";
}

$stmt->close();
$conn->close();
?>

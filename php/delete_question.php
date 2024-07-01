<?php
if (!isset($_POST['question_id'])) {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

include_once("dbconnect.php");

$question_id = $_POST['question_id'];

// Start transaction
$conn->begin_transaction();

// Delete associated comments
$sql_comments = "DELETE FROM tbl_comment WHERE question_id = ?";
$stmt_comments = $conn->prepare($sql_comments);
$stmt_comments->bind_param("i", $question_id);
$result_comments = $stmt_comments->execute();

// Delete the question
$sql_question = "DELETE FROM tbl_questions WHERE question_id = ?";
$stmt_question = $conn->prepare($sql_question);
$stmt_question->bind_param("i", $question_id);
$result_question = $stmt_question->execute();

if ($result_comments && $result_question) {
    $conn->commit();
    sendJsonResponse(array('status' => 'success', 'data' => null));
} else {
    $conn->rollback();
    sendJsonResponse(array('status' => 'error', 'data' => null));
}

$stmt_comments->close();
$stmt_question->close();
$conn->close();

function sendJsonResponse($response) {
    header('Content-Type: application/json');
    echo json_encode($response);
}
?>

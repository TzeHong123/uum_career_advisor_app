<?php
include_once("dbconnect.php");

header('Content-Type: application/json');

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

if (isset($_GET['question_id'])) {
    $question_id = $_GET['question_id'];

    // Join tbl_comment and tbl_users to get the username along with comments
    $query = "SELECT tbl_comment.*, tbl_users.user_name AS username FROM tbl_comment 
              JOIN tbl_users ON tbl_comment.user_id = tbl_users.user_id 
              WHERE tbl_comment.question_id = ?";
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("i", $question_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $comments = array();
        while ($row = $result->fetch_assoc()) {
            $row['comment_id'] = (string)$row['comment_id'];
            $comments[] = $row;
        }

        echo json_encode(['status' => 'success', 'data' => $comments]);
        $stmt->close();
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error preparing statement: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'failed', 'message' => 'Question ID not provided']);
}

$conn->close();
?>

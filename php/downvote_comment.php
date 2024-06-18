<?php
include_once("dbconnect.php");

header('Content-Type: application/json');

if (isset($_POST['comment_id'])) {
    $comment_id = $_POST['comment_id'];
    $user_id = $_POST['user_id'];

    // Increment the downvotes column in tbl_comment
    $stmt = $conn->prepare("UPDATE tbl_comment SET downvotes = downvotes + 1 WHERE comment_id = ?");
    $stmt->bind_param("i", $comment_id);
    $stmt->execute();
    $stmt->close();

    // Add an entry to tbl_votes for the downvote
    $stmt = $conn->prepare("INSERT INTO tbl_votes (comment_id, user_id, downvote) VALUES (?, ?, 1)");
    $stmt->bind_param("ii", $comment_id, $_POST['user_id']);
    $stmt->execute();
    $stmt->close();

    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'failed', 'message' => 'Comment ID not provided']);
}

$conn->close();
?>

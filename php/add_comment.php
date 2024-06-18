<?php
include_once("dbconnect.php");

// Helper function to send JSON responses
function sendJsonResponse($status, $message) {
    echo json_encode(array('status' => $status, 'message' => $message));
    exit; // Make sure to stop script execution after sending response
}

header('Content-Type: application/json'); // Indicate JSON response

// Check if necessary POST data is available
if (isset($_POST['user_id'], $_POST['question_id'], $_POST['user_profile_pic'], $_POST['comment_text'])) {
    $user_id = $_POST['user_id'];
    $question_id = $_POST['question_id'];
    $user_profile_pic = $_POST['user_profile_pic'];
    $comment_text = $_POST['comment_text'];
    $upvotes = isset($_POST['upvotes']) ? $_POST['upvotes'] : 0;
    $downvotes = isset($_POST['downvotes']) ? $_POST['downvotes'] : 0;
    
    $query = "INSERT INTO tbl_comment (user_id, question_id, user_profile_pic, comment_text, upvotes, downvotes, created_at, updated_at)
              VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";

    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("iissii", $user_id, $question_id, $user_profile_pic, $comment_text, $upvotes, $downvotes);
        if ($stmt->execute()) {
            sendJsonResponse('success', 'Comment added successfully!');
        } else {
            sendJsonResponse('error', 'Error executing query: ' . $stmt->error);
        }
        $stmt->close();
    } else {
        sendJsonResponse('error', 'Error preparing statement: ' . $conn->error);
    }
} else {
    sendJsonResponse('failed', 'Required data not provided.');
}

$conn->close();
?>

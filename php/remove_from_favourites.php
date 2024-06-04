<?php
if (!isset($_POST['user_id']) || !isset($_POST['post_id'])) {
    sendJsonResponse("failed", "Invalid request");
    exit();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$post_id = $_POST['post_id'];

// Check if the post is in the user's favourites
$checkQuery = "SELECT * FROM tbl_post_favourites WHERE user_id = ? AND post_id = ?";
$stmt = $conn->prepare($checkQuery);
$stmt->bind_param("ii", $user_id, $post_id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows == 0) {
    sendJsonResponse("failed", "Post not found in favourites");
    $stmt->close();
    exit();
}

// Remove from favourites
$deleteQuery = "DELETE FROM tbl_post_favourites WHERE user_id = ? AND post_id = ?";
$deleteStmt = $conn->prepare($deleteQuery);
$deleteStmt->bind_param("ii", $user_id, $post_id);
if ($deleteStmt->execute()) {
    sendJsonResponse("success", "Removed from favourites");
} else {
    sendJsonResponse("failed", "Failed to remove from favourites");
}

$deleteStmt->close();

function sendJsonResponse($status, $message) {
    echo json_encode(array('status' => $status, 'message' => $message));
}
?>

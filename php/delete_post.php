<?php
if (!isset($_POST['post_id'])) {
    sendJsonResponse(array('status' => 'failed', 'message' => 'Post ID not provided', 'data' => null));
    exit();
}

include_once("dbconnect.php");

$post_id = $_POST['post_id'];

// Start transaction
$conn->begin_transaction();

try {
    // Delete associated advice contents
    $sql_advice_contents = "DELETE FROM tbl_advice_content WHERE post_id = ?";
    $stmt_advice_contents = $conn->prepare($sql_advice_contents);
    $stmt_advice_contents->bind_param("i", $post_id);
    if (!$stmt_advice_contents->execute()) {
        throw new Exception("Failed to delete advice contents: " . $stmt_advice_contents->error);
    }

    // Delete associated likes
    $sql_post_likes = "DELETE FROM tbl_post_likes WHERE post_id = ?";
    $stmt_post_likes = $conn->prepare($sql_post_likes);
    $stmt_post_likes->bind_param("i", $post_id);
    if (!$stmt_post_likes->execute()) {
        throw new Exception("Failed to delete post likes: " . $stmt_post_likes->error);
    }

    // Delete associated favorites
    $sql_post_favourites = "DELETE FROM tbl_post_favourites WHERE post_id = ?";
    $stmt_post_favourites = $conn->prepare($sql_post_favourites);
    $stmt_post_favourites->bind_param("i", $post_id);
    if (!$stmt_post_favourites->execute()) {
        throw new Exception("Failed to delete post favourites: " . $stmt_post_favourites->error);
    }

    // Delete the post
    $sql_post = "DELETE FROM tbl_posts WHERE post_id = ?";
    $stmt_post = $conn->prepare($sql_post);
    $stmt_post->bind_param("i", $post_id);
    if (!$stmt_post->execute()) {
        throw new Exception("Failed to delete post: " . $stmt_post->error);
    }

    // Commit transaction
    $conn->commit();
    sendJsonResponse(array('status' => 'success', 'message' => 'Post deleted successfully', 'data' => null));
} catch (Exception $e) {
    // Rollback transaction on error
    $conn->rollback();
    sendJsonResponse(array('status' => 'error', 'message' => $e->getMessage(), 'data' => null));
} finally {
    // Close statements
    $stmt_advice_contents->close();
    $stmt_post_likes->close();
    $stmt_post_favourites->close();
    $stmt_post->close();
    // Close connection
    $conn->close();
}

function sendJsonResponse($response) {
    header('Content-Type: application/json');
    echo json_encode($response);
}
?>

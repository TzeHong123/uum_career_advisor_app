<?php
// Include the database connection script
include 'dbconnect.php';

// Check if the request is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve post_id and user_id from the POST request and ensure they are integers
    $post_id = (int)$_POST['post_id'];
    $user_id = (int)$_POST['user_id'];
    $user_has_liked = isset($_POST['user_has_liked']) && $_POST['user_has_liked'] == '1' ? 1 : 0;

    // Check if a like record already exists using prepared statements
    $checkSql = $conn->prepare("SELECT user_has_liked FROM tbl_post_likes WHERE post_id = ? AND user_id = ?");
    $checkSql->bind_param("ii", $post_id, $user_id);
    $checkSql->execute();
    $result = $checkSql->get_result();

    if ($result->num_rows > 0) {
        // Record exists, so update it
        $row = $result->fetch_assoc();
        if ($row['user_has_liked'] == $user_has_liked) {
            // If the current status is the same as the new status, do nothing
            echo json_encode(['status' => 'no_change', 'message' => 'No change in like status.']);
        } else {
            // Update the existing record
            $updateSql = $conn->prepare("UPDATE tbl_post_likes SET user_has_liked = ? WHERE post_id = ? AND user_id = ?");
            $updateSql->bind_param("iii", $user_has_liked, $post_id, $user_id);
            if ($updateSql->execute()) {
                // Update the post_likes count in tbl_posts
                if ($user_has_liked) {
                    $updatePostLikesSql = "UPDATE tbl_posts SET post_likes = post_likes + 1 WHERE post_id = ?";
                } else {
                    $updatePostLikesSql = "UPDATE tbl_posts SET post_likes = post_likes - 1 WHERE post_id = ?";
                }
                $updateLikesStmt = $conn->prepare($updatePostLikesSql);
                $updateLikesStmt->bind_param("i", $post_id);
                $updateLikesStmt->execute();

                echo json_encode(['status' => 'success', 'message' => 'Like status updated successfully.']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Error updating like status: ' . $conn->error]);
            }
        }
    } else {
        // No record exists, so insert a new one
        $insertSql = $conn->prepare("INSERT INTO tbl_post_likes (post_id, user_id, user_has_liked) VALUES (?, ?, ?)");
        $insertSql->bind_param("iii", $post_id, $user_id, $user_has_liked);
        if ($insertSql->execute()) {
            // Update the post_likes count in tbl_posts
            if ($user_has_liked) {
                $updatePostLikesSql = "UPDATE tbl_posts SET post_likes = post_likes + 1 WHERE post_id = ?";
                $updateLikesStmt = $conn->prepare($updatePostLikesSql);
                $updateLikesStmt->bind_param("i", $post_id);
                $updateLikesStmt->execute();
            }
            echo json_encode(['status' => 'success', 'message' => 'Like added successfully.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error adding like: ' . $conn->error]);
        }
    }
} else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

// Close connection
$conn->close();
?>

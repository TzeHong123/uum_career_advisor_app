<?php
// Include the database connection script
include 'dbconnect.php';

// Check if the request is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve post_id and user_id from the POST request and ensure they are integers
    $post_id = isset($_POST['post_id']) ? (int)$_POST['post_id'] : 0;
    $user_id = isset($_POST['user_id']) ? (int)$_POST['user_id'] : 0;
    $is_favourite = isset($_POST['is_favourite']) && $_POST['is_favourite'] == '1' ? 1 : 0;

    if ($post_id && $user_id) {
        // Check if a favourite record already exists using prepared statements
        $checkSql = $conn->prepare("SELECT added_to_fav FROM tbl_post_favourites WHERE post_id = ? AND user_id = ?");
        $checkSql->bind_param("ii", $post_id, $user_id);
        $checkSql->execute();
        $result = $checkSql->get_result();

        if ($result->num_rows > 0) {
            // Record exists, so update it
            $row = $result->fetch_assoc();
            if ($row['added_to_fav'] == $is_favourite) {
                // If the current status is the same as the new status, do nothing
                echo json_encode(['status' => 'no_change', 'message' => 'No change in favourite status.']);
            } else {
                // Update the existing record
                $updateSql = $conn->prepare("UPDATE tbl_post_favourites SET added_to_fav = ? WHERE post_id = ? AND user_id = ?");
                $updateSql->bind_param("iii", $is_favourite, $post_id, $user_id);
                if ($updateSql->execute()) {
                    echo json_encode(['status' => 'success', 'message' => 'Favourite status updated successfully.']);
                } else {
                    echo json_encode(['status' => 'error', 'message' => 'Error updating favourite status: ' . $conn->error]);
                }
            }
        } else {
            // No record exists, so insert a new one
            $insertSql = $conn->prepare("INSERT INTO tbl_post_favourites (post_id, user_id, added_to_fav) VALUES (?, ?, ?)");
            $insertSql->bind_param("iii", $post_id, $user_id, $is_favourite);
            if ($insertSql->execute()) {
                echo json_encode(['status' => 'success', 'message' => 'Post added to favourites successfully.']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Error adding post to favourites: ' . $conn->error]);
            }
        }
    } else {
        // Invalid post_id or user_id
        echo json_encode(['status' => 'error', 'message' => 'Invalid post_id or user_id.']);
    }
} else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

// Close connection
$conn->close();
?>

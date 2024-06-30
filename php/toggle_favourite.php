<?php
// Include the database connection script
include 'dbconnect.php';

// Check if the request is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve post_id and user_id from the POST request and ensure they are integers
    $post_id = (int)$_POST['post_id'];
    $user_id = (int)$_POST['user_id'];
    $is_favorite = isset($_POST['is_favorite']) && $_POST['is_favorite'] == '1' ? 1 : 0;

    // Check if a favorite record already exists using prepared statements
    $checkSql = $conn->prepare("SELECT added_to_fav FROM tbl_post_favourites WHERE post_id = ? AND user_id = ?");
    $checkSql->bind_param("ii", $post_id, $user_id);
    $checkSql->execute();
    $result = $checkSql->get_result();

    if ($result->num_rows > 0) {
        // Record exists, so update it
        $row = $result->fetch_assoc();
        if ($row['added_to_fav'] == $is_favorite) {
            // If the current status is the same as the new status, do nothing
            echo json_encode(['status' => 'no_change', 'message' => 'No change in favorite status.']);
        } else {
            // Update the existing record
            $updateSql = $conn->prepare("UPDATE tbl_post_favourites SET added_to_fav = ? WHERE post_id = ? AND user_id = ?");
            $updateSql->bind_param("iii", $is_favorite, $post_id, $user_id);
            if ($updateSql->execute()) {
                echo json_encode(['status' => 'success', 'message' => 'Favorite status updated successfully.']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Error updating favorite status: ' . $conn->error]);
            }
        }
    } else {
        // No record exists, so insert a new one
        $insertSql = $conn->prepare("INSERT INTO tbl_post_favourites (post_id, user_id, added_to_fav) VALUES (?, ?, ?)");
        $insertSql->bind_param("iii", $post_id, $user_id, $is_favorite);
        if ($insertSql->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Favorite added successfully.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error adding favorite: ' . $conn->error]);
        }
    }
} else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

// Close connection
$conn->close();
?>

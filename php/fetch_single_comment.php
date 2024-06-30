<?php
include_once("dbconnect.php");

$comment_id = $_GET['comment_id'];

// Join tbl_comment and tbl_users to get the username along with comments
$sql = "SELECT c.*, u.user_name AS username 
        FROM tbl_comment c 
        JOIN tbl_users u ON c.user_id = u.user_id 
        WHERE c.comment_id = '$comment_id'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response = array('status' => 'success', 'data' => $row);
} else {
    $response = array('status' => 'failed', 'message' => 'Comment not found');
}

echo json_encode($response);
?>

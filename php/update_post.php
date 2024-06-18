<?php
if (!isset($_POST)) {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

include_once("dbconnect.php");

// Get POST data
$post_id = $_POST['post_id'];
$post_title = $_POST['post_title'];
$post_content = $_POST['post_content'];

// SQL to update post
$sql = "UPDATE tbl_posts SET post_title = ?, post_content = ? WHERE post_id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("ssi", $post_title, $post_content, $post_id);
$result = $stmt->execute();

if ($result) {
    echo "success";
} else {
    echo "error";
}

$stmt->close();
$conn->close();
?>

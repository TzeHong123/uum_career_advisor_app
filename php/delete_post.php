<?php
if (!isset($_POST)) {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

include_once("dbconnect.php");

$post_id = $_POST['post_id'];

// SQL to delete a post
$sql = "DELETE FROM tbl_posts WHERE post_id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $post_id);
$result = $stmt->execute();

if ($result) {
    echo "success";
} else {
    echo "error";
}

$stmt->close();
$conn->close();
?>

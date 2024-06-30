<?php
include_once("dbconnect.php");

$comment_id = $_POST['comment_id'];
$user_id = $_POST['user_id'];

// Check if user already upvoted the comment
$checkVoteSql = "SELECT * FROM tbl_comment_votes WHERE comment_id = '$comment_id' AND user_id = '$user_id'";
$checkVoteResult = $conn->query($checkVoteSql);

if ($checkVoteResult->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'User already upvoted');
} else {
    // Update upvotes count in tbl_comment
    $sql = "UPDATE tbl_comment SET upvotes = upvotes + 1 WHERE comment_id = '$comment_id'";
    if ($conn->query($sql) === TRUE) {
        // Insert into tbl_comment_votes to prevent multiple upvotes by the same user
        $insertVoteSql = "INSERT INTO tbl_comment_votes (comment_id, user_id, vote_type) VALUES ('$comment_id', '$user_id', 'upvote')";
        if ($conn->query($insertVoteSql) === TRUE) {
            $response = array('status' => 'success', 'message' => 'Upvoted successfully');
        } else {
            $response = array('status' => 'failed', 'message' => 'Failed to record vote');
        }
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to update upvotes');
    }
}

echo json_encode($response);
?>

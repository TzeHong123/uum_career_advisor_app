<?php
include_once("dbconnect.php");

header('Content-Type: application/json');

if (isset($_POST['comment_id']) && isset($_POST['user_id']) && isset($_POST['vote_type'])) {
    $comment_id = $_POST['comment_id'];
    $user_id = $_POST['user_id'];
    $vote_type = $_POST['vote_type'];

    // Check if the user has already voted
    $checkVoteQuery = "SELECT * FROM tbl_votes WHERE comment_id = ? AND user_id = ?";
    $stmt = $conn->prepare($checkVoteQuery);
    $stmt->bind_param("ii", $comment_id, $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $existingVote = $result->fetch_assoc();

    if ($existingVote) {
        // If the same vote type, remove the vote (toggle functionality)
        if ($existingVote['vote_type'] == $vote_type) {
            $deleteVoteQuery = "DELETE FROM tbl_votes WHERE id = ?";
            $stmt = $conn->prepare($deleteVoteQuery);
            $stmt->bind_param("i", $existingVote['id']);
            $stmt->execute();
        } else {
            // If different vote type, update the vote
            $updateVoteQuery = "UPDATE tbl_votes SET vote_type = ? WHERE id = ?";
            $stmt = $conn->prepare($updateVoteQuery);
            $stmt->bind_param("si", $vote_type, $existingVote['id']);
            $stmt->execute();
        }
    } else {
        // Add a new vote
        $insertVoteQuery = "INSERT INTO tbl_votes (comment_id, user_id, vote_type) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($insertVoteQuery);
        $stmt->bind_param("iis", $comment_id, $user_id, $vote_type);
        $stmt->execute();
    }

    // Recalculate upvotes and downvotes
    $upvoteCountQuery = "SELECT COUNT(*) as upvotes FROM tbl_votes WHERE comment_id = ? AND vote_type = 'upvote'";
    $stmt = $conn->prepare($upvoteCountQuery);
    $stmt->bind_param("i", $comment_id);
    $stmt->execute();
    $upvoteResult = $stmt->get_result();
    $upvotes = $upvoteResult->fetch_assoc()['upvotes'];

    $downvoteCountQuery = "SELECT COUNT(*) as downvotes FROM tbl_votes WHERE comment_id = ? AND vote_type = 'downvote'";
    $stmt = $conn->prepare($downvoteCountQuery);
    $stmt->bind_param("i", $comment_id);
    $stmt->execute();
    $downvoteResult = $stmt->get_result();
    $downvotes = $downvoteResult->fetch_assoc()['downvotes'];

    $updateCommentQuery = "UPDATE tbl_comment SET upvotes = ?, downvotes = ? WHERE id = ?";
    $stmt = $conn->prepare($updateCommentQuery);
    $stmt->bind_param("iii", $upvotes, $downvotes, $comment_id);
    $stmt->execute();

    echo json_encode(['status' => 'success', 'message' => 'Vote recorded successfully']);
} else {
    echo json_encode(['status' => 'failed', 'message' => 'Missing parameters']);
}

$conn->close();
?>

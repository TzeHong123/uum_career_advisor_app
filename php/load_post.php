<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 6; // Set the number of posts per page
if (isset($_POST['pageno'])) {
    $pageno = (int)$_POST['pageno'];
} else {
    $pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

// Modify or add any additional conditions based on your use case
if (isset($_POST['search'])) {
    $search = $_POST['search'];
    $sqlloadposts = "SELECT * FROM tbl_posts WHERE post_title LIKE '%$search%' 
                     OR post_content LIKE '%$search%'";
} else {
    $sqlloadposts = "SELECT * FROM tbl_posts";
}

// Get total number of posts (for pagination)
$result = $conn->query($sqlloadposts);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);

// Query for the current page
$sqlloadposts = $sqlloadposts . " ORDER BY post_id ASC LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadposts);

if ($result->num_rows > 0) {
    $posts["posts"] = array();
    while ($row = $result->fetch_assoc()) {
        $postlist = array();
        $postlist['post_id'] = $row['post_id'];
        $postlist['user_id'] = $row['user_id'];
        $postlist['user_name'] = $row['user_name'];
        $postlist['post_title'] = $row['post_title'];
        $postlist['post_content'] = $row['post_content'];
        array_push($posts["posts"], $postlist);
    }
    $response = array('status' => 'success', 'data' => $posts, 'numofpage' => "$number_of_page", 'numberofresult' => "$number_of_result");
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

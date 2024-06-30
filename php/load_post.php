<?php
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    exit();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$results_per_page = 6;
$pageno = isset($_POST['pageno']) ? (int)$_POST['pageno'] : 1;
$page_first_result = ($pageno - 1) * $results_per_page;
$search = isset($_POST['search']) ? $conn->real_escape_string($_POST['search']) : "";

// Construct SQL query based on whether search term is provided
$sqlBase = "FROM tbl_posts p ";
$sqlWhere = $search !== "" ? "WHERE p.post_title LIKE '%$search%' OR p.post_content LIKE '%$search%'" : "";
$sqlLimit = "ORDER BY p.post_id ASC LIMIT $page_first_result, $results_per_page";

// Count total posts for pagination
$sqlCount = "SELECT COUNT(*) AS total " . $sqlBase . $sqlWhere;
$resultCount = $conn->query($sqlCount);
$row = $resultCount->fetch_assoc();
$number_of_result = $row['total'];
$number_of_page = ceil($number_of_result / $results_per_page);

// Fetch posts, likes, and favorite status data
$sqlLoadPosts = "SELECT p.*, 
                        (SELECT COUNT(*) FROM tbl_post_likes WHERE post_id = p.post_id) AS likes, 
                        (SELECT user_has_liked FROM tbl_post_likes WHERE post_id = p.post_id AND user_id = '$user_id') AS userHasLiked,
                        (SELECT added_to_fav FROM tbl_post_favourites WHERE post_id = p.post_id AND user_id = '$user_id') AS isFavorite
                 " . $sqlBase . $sqlWhere . $sqlLimit;

$result = $conn->query($sqlLoadPosts);

if ($result->num_rows > 0) {
    $posts = array();
    while ($row = $result->fetch_assoc()) {
        // Cast userHasLiked and isFavorite to boolean
        $row['userHasLiked'] = $row['userHasLiked'] == 1 ? 1 : 0;
        $row['isFavorite'] = $row['isFavorite'] == 1 ? 1 : 0;
        $posts[] = $row;
    }
    sendJsonResponse(array('status' => 'success', 'data' => array("posts" => $posts), 'numofpage' => $number_of_page, 'numberofresult' => $number_of_result));
} else {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

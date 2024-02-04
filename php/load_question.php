<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 6; // Set the number of questions per page
if (isset($_POST['pageno'])) {
    $pageno = (int)$_POST['pageno'];
} else {
    $pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

// Modify or add any additional conditions based on your use case
if (isset($_POST['search'])) {
    $search = $_POST['search'];
    $sqlloadquestions = "SELECT * FROM tbl_questions WHERE question_title LIKE '%$search%' 
                         OR question_content LIKE '%$search%'";
} else {
    $sqlloadquestions = "SELECT * FROM tbl_questions";
}

// Get total number of questions (for pagination)
$result = $conn->query($sqlloadquestions);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);

// Query for the current page
$sqlloadquestions = $sqlloadquestions . " ORDER BY question_id ASC LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadquestions);

if ($result->num_rows > 0) {
    $questions["questions"] = array();
    while ($row = $result->fetch_assoc()) {
        $questionlist = array();
        $questionlist['question_id'] = $row['question_id'];
        $questionlist['user_id'] = $row['user_id'];
        $questionlist['user_name'] = $row['user_name']; // Adjust this line based on your database schema
        $questionlist['question_title'] = $row['question_title'];
        $questionlist['question_content'] = $row['question_content'];
        array_push($questions["questions"], $questionlist);
    }
    $response = array('status' => 'success', 'data' => $questions, 'numofpage' => "$number_of_page", 'numberofresult' => "$number_of_result");
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

<?php
if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    sendJsonResponse(['status' => 'failed', 'message' => 'Invalid request method.']);
    exit();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'] ?? null;
$load_type = $_POST['load_type'] ?? 'all';
$results_per_page = 6;
$pageno = isset($_POST['pageno']) ? (int)$_POST['pageno'] : 1;
$page_first_result = ($pageno - 1) * $results_per_page;
$search = isset($_POST['search']) ? '%' . $conn->real_escape_string($_POST['search']) . '%' : "%";

// Base SQL
$sqlBase = "FROM tbl_questions q";
$sqlWhere = " WHERE 1";

if ($load_type === 'user_specific' && $user_id) {
    $sqlWhere .= " AND q.user_id = ?";
}

if (!empty($_POST['search'])) {
    $sqlWhere .= " AND (q.question_title LIKE ? OR q.question_content LIKE ?)";
}

$sqlLimit = " ORDER BY q.question_id DESC LIMIT ?, ?";

// Prepare statement for count
$stmtCount = $conn->prepare("SELECT COUNT(*) AS total $sqlBase $sqlWhere");
if ($load_type === 'user_specific' && $user_id) {
    $stmtCount->bind_param("s", $user_id);
}
if (!empty($_POST['search'])) {
    $stmtCount->bind_param("ss", $search, $search);
}
$stmtCount->execute();
$resultCount = $stmtCount->get_result();
$row = $resultCount->fetch_assoc();
$number_of_result = $row['total'];
$number_of_page = ceil($number_of_result / $results_per_page);

// Prepare statement for questions fetch
$stmtQuestions = $conn->prepare("SELECT q.question_id, q.user_id, q.question_title, q.question_content $sqlBase $sqlWhere $sqlLimit");
if ($load_type === 'user_specific' && $user_id) {
    $stmtQuestions->bind_param("s", $user_id);
}
if (!empty($_POST['search'])) {
    $stmtQuestions->bind_param("ss", $search, $search);
}
$stmtQuestions->bind_param("ii", $page_first_result, $results_per_page);
$stmtQuestions->execute();
$result = $stmtQuestions->get_result();

if ($result->num_rows > 0) {
    $questions = array();
    while ($row = $result->fetch_assoc()) {
        $questions[] = $row;
    }
    sendJsonResponse(['status' => 'success', 'data' => ['questions' => $questions, 'numofpage' => $number_of_page, 'numberofresult' => $number_of_result]]);
} else {
    sendJsonResponse(['status' => 'failed', 'message' => 'No questions found.']);
}

function sendJsonResponse($data) {
    header('Content-Type: application/json');
    echo json_encode($data);
}
?>

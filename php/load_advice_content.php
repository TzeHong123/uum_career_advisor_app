<?php
include_once("dbconnect.php");

$post_id = $_GET['post_id'] ?? ''; // Get post_id from query parameter

if (empty($post_id)) {
    $response = ['status' => 'failed', 'message' => 'No post ID provided'];
    sendJsonResponse($response);
    exit;
}

// Prepare the SQL query to fetch advice content along with job_title and company_name
$stmt = $conn->prepare("SELECT advice_content, user_name, job_title, company_name FROM tbl_advice_content WHERE post_id = ?");
$stmt->bind_param("i", $post_id);
$stmt->execute();
$result = $stmt->get_result();

$advices = [];
while ($row = $result->fetch_assoc()) {
    $advices[] = $row;
}

if (count($advices) > 0) {
    $response = ['status' => 'success', 'data' => $advices];
} else {
    $response = ['status' => 'success', 'data' => []]; // Return an empty array if no advices found
}

sendJsonResponse($response);

$stmt->close();
$conn->close();

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

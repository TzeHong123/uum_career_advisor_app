<?php
include_once("dbconnect.php");

// Check if all required POST variables are set
if (!isset($_POST['user_id']) || !isset($_POST['user_name']) || !isset($_POST['post_id']) || !isset($_POST['advice_title']) || !isset($_POST['advice_content'])) {
    $response = ['status' => 'failed', 'message' => 'Incomplete POST data'];
    sendJsonResponse($response);
    exit;
}

// Assign POST variables
$user_id = $_POST['user_id'];
$user_name = $_POST['user_name'];
$job_title = $_POST['job_title']; // Add this line
$company_name = $_POST['company_name']; // Add this line
$post_id = $_POST['post_id'];
$advice_title = $_POST['advice_title'];
$advice_content = $_POST['advice_content'];

// Prepare SQL statement using placeholders
$stmt = $conn->prepare("INSERT INTO tbl_advice_content (post_id, user_id, user_name, job_title, company_name, advice_title, advice_content) VALUES (?, ?, ?, ?, ?, ?, ?)");
if (!$stmt) {
    $response = ['status' => 'failed', 'message' => 'Failed to prepare statement'];
    sendJsonResponse($response);
    exit;
}

// Bind parameters
$stmt->bind_param("iisssss", $post_id, $user_id, $user_name, $job_title, $company_name, $advice_title, $advice_content);

// Execute the statement and respond accordingly
if ($stmt->execute()) {
    $response = ['status' => 'success', 'message' => 'Advice added successfully'];
} else {
    $response = ['status' => 'failed', 'message' => $stmt->error];
}

sendJsonResponse($response);

$stmt->close();
$conn->close();

// Function to send a JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

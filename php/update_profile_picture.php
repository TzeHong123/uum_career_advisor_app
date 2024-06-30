<?php
// update_profile_picture.php

// Include database connection file
include_once("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Receive data from Flutter app
    $userid = $_POST['userid'];
    $base64Image = $_POST['image'];

    // Decode base64 image data
    $decodedImage = base64_decode($base64Image);

    // Ensure directory exists and is writable (adjust path as per your server setup)
    $uploadDir = 'assets/profile/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true); // Create directory if it doesn't exist
    }

    // Generate a unique filename for the uploaded image
    $filename = 'profile_' . uniqid() . '.jpg'; // Adjust file extension as per image type

    // Path to save the uploaded image
    $filepath = $uploadDir . $filename;

    // Save the image file
    $success = file_put_contents($filepath, $decodedImage);

    if ($success !== false) {
        // Image uploaded successfully, now update database
        // Update user's profile picture in database using $conn from dbconnect.php
        $updateQuery = "UPDATE tbl_users SET profile_picture = '$filename' WHERE user_id = '$userid'";

        if ($conn->query($updateQuery) === TRUE) {
            // Database update successful
            $response = [
                'status' => 'success',
                'message' => 'Profile picture uploaded and database updated successfully',
                'profile_picture' => $filename // Return filename to Flutter app
            ];
        } else {
            // Database update failed
            $response = [
                'status' => 'error',
                'message' => 'Failed to update profile picture in database'
            ];
        }

    } else {
        // Failed to upload image
        $response = [
            'status' => 'error',
            'message' => 'Failed to upload profile picture'
        ];
    }

    // Send JSON response back to Flutter app
    header('Content-Type: application/json');
    echo json_encode($response);

    // Close database connection
    $conn->close();

} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(['error' => 'Method Not Allowed']);
}
?>

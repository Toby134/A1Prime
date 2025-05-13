<?php
$enteredPassword = "202100177Aj!";

// Get this value from your database by running:
// SELECT Pword FROM user_id WHERE Uname = 'AdreyJohn';
$storedHash = '$2y$10$kQ9pb/WdSpqjl3MEKR'; // Replace this with actual hash

if (password_verify($enteredPassword, $storedHash)) {
    echo "✅ Password matches!";
} else {
    echo "❌ Incorrect password!";
}
?>

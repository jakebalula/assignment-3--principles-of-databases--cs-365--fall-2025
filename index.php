<?php
require_once "includes/config.php";
require_once "includes/helpers.php";

$search_result = null;
$message = '';

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action'])) {
        switch ($_POST['action']) {
            case 'search':
                if (!empty($_POST['search_term'])) {
                    ob_start();
                    $result = search($_POST['search_term']);
                    if ($result === 0) {
                        $message = "No results found for: " . htmlspecialchars($_POST['search_term']);
                    } else {
                        $search_result = ob_get_clean();
                    }
                }
                break;

            case 'insert':
                if (!empty($_POST['site_name']) && !empty($_POST['url']) &&
                    !empty($_POST['email']) && !empty($_POST['username']) &&
                    !empty($_POST['password'])) {

                    insert(
                        $_POST['site_name'],
                        $_POST['url'],
                        $_POST['email'],
                        $_POST['username'],
                        $_POST['password'],
                        $_POST['comment'] ?? ''
                    );
                    $message = "Entry added successfully!";
                } else {
                    $message = "All fields except comment are required for insert.";
                }
                break;

            case 'update':
                if (!empty($_POST['site_name'])) {
                    updateSite(
                        $_POST['site_name'],
                        $_POST['new_url'] ?? null,
                        $_POST['new_comment'] ?? null
                    );

                    updateCredentials(
                        $_POST['site_name'],
                        $_POST['new_email'] ?? null,
                        $_POST['new_username'] ?? null,
                        $_POST['new_password'] ?? null
                    );

                    $message = "Entry updated successfully!";
                } else {
                    $message = "Site name is required for update.";
                }
                break;

            case 'delete':
                if (!empty($_POST['site_name_delete'])) {
                    delete($_POST['site_name_delete']);
                    $message = "Entry deleted successfully!";
                } else {
                    $message = "Site name is required for delete.";
                }
                break;

            case 'clear':
                $search_result = null;
                $message = '';
                break;
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Manager</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Password Manager</h1>

        <?php if ($message): ?>
            <div class="message">
                <?php echo htmlspecialchars($message); ?>
            </div>
        <?php endif; ?>

        <!-- Search Section -->
        <section class="form-section">
            <h2>Search Passwords</h2>
            <form method="post" action="">
                <input type="hidden" name="action" value="search">
                <div class="form-group">
                    <label for="search_term">Search Term:</label>
                    <input type="text" id="search_term" name="search_term" required>
                </div>
                <button type="submit">Search</button>
            </form>
        </section>

        <!-- Results Section -->
        <?php if ($search_result): ?>
            <section class="results-section">
                <h2>Search Results</h2>
                <form method="post" action="" style="display: inline;">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="clear-btn">Clear Results</button>
                </form>
                <?php echo $search_result; ?>
            </section>
        <?php endif; ?>

        <!-- Insert Section -->
        <section class="form-section">
            <h2>Add New Entry</h2>
            <form method="post" action="">
                <input type="hidden" name="action" value="insert">
                <div class="form-group">
                    <label for="site_name">Site/App Name:</label>
                    <input type="text" id="site_name" name="site_name" required>
                </div>
                <div class="form-group">
                    <label for="url">URL:</label>
                    <input type="url" id="url" name="url" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="comment">Comment:</label>
                    <textarea id="comment" name="comment" rows="3"></textarea>
                </div>
                <button type="submit">Add Entry</button>
            </form>
        </section>

        <!-- Update Section -->
        <section class="form-section">
            <h2>Update Entry</h2>
            <form method="post" action="">
                <input type="hidden" name="action" value="update">
                <div class="form-group">
                    <label for="site_name_update">Site Name (to match):</label>
                    <input type="text" id="site_name_update" name="site_name" required>
                </div>
                <div class="form-group">
                    <label for="new_url">New URL:</label>
                    <input type="url" id="new_url" name="new_url">
                </div>
                <div class="form-group">
                    <label for="new_email">New Email:</label>
                    <input type="email" id="new_email" name="new_email">
                </div>
                <div class="form-group">
                    <label for="new_username">New Username:</label>
                    <input type="text" id="new_username" name="new_username">
                </div>
                <div class="form-group">
                    <label for="new_password">New Password:</label>
                    <input type="password" id="new_password" name="new_password">
                </div>
                <div class="form-group">
                    <label for="new_comment">New Comment:</label>
                    <textarea id="new_comment" name="new_comment" rows="3"></textarea>
                </div>
                <button type="submit">Update Entry</button>
            </form>
        </section>

        <!-- Delete Section -->
        <section class="form-section">
            <h2>Delete Entry</h2>
            <form method="post" action="" onsubmit="return confirm('Are you sure you want to delete this entry?');">
                <input type="hidden" name="action" value="delete">
                <div class="form-group">
                    <label for="site_name_delete">Site Name:</label>
                    <input type="text" id="site_name_delete" name="site_name_delete" required>
                </div>
                <button type="submit" class="delete-btn">Delete Entry</button>
            </form>
        </section>
    </div>
</body>
</html>

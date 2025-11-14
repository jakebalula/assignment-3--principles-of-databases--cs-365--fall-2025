<?php
$db_host = 'localhost';
$db_name = 'student_passwords';
$db_user = 'passwords_user';
$db_pass = '';

$AES_KEY_PHRASE = 'secret password';

function get_pdo_connection(): PDO {
    global $db_host, $db_name, $db_user, $db_pass;

    static $pdo = null;

    if ($pdo === null) {
        $dsn = "mysql:host={$db_host};dbname={$db_name};charset=utf8mb4";
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        $pdo = new PDO($dsn, $db_user, $db_pass, $options);
    }
    return $pdo;
}
?>

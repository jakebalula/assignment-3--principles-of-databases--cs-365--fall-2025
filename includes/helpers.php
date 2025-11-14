<?php

require_once __DIR__ . '/../includes/config.php';

//Search across multiple fields of the database, returns an array of rows.
function seach_all(string $term): array {
    $pdo = get_pdo_connection();
    global $AES_KEY_PHRASE;

    $sql = "Select c.credenital_id,
                   s.site_name,
                   u.first_name,
                   u.last_name,
                   s.site_name,
                   s.url,
                   s.comment,
                   c.email,
                   c.username,
                   CAST(
                        AES_DECRYPT(
                            c.encrypted_password,
                            UNHEX(SHA2(:key_phrase, 512))
                        ) AS CHAR
                    ) AS password_plain,
              c.created_at
            From credentials c
            INNER JOIN users u ON c.user_id = u.user_id
            INNER JOIN sites s ON c.site_id = s.site_id
            WHERE
                u.first_name LIKE :term OR
                u.last_name LIKE :term OR
                s.site_name LIKE :term OR
                s.url LIKE :term OR
                s.comment LIKE :term OR
                c.email LIKE :term OR
                c.username LIKE :term
            ORDER BY c.created_at DESC";

    $stmt = $pdo->prepare($sql);
    $like = '%' . $term . '%';
    $stmt->execute([':term' => $like, ':key_phrase' => $AES_KEY_PHRASE]);
    return $stmt->fetchAll();
}

//Insert a new site into the database

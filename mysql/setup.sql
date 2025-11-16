DROP DATABASE IF EXISTS student_passwords;
DROP USER IF EXISTS 'passwords_user'@'localhost';

CREATE DATABASE student_passwords DEFAULT CHARACTER SET utf8mb4;

CREATE USER 'passwords_user'@'localhost' IDENTIFIED BY '';

GRANT ALL PRIVILEGES ON student_passwords.* TO 'passwords_user'@'localhost';
FLUSH PRIVILEGES;

USE student_passwords;

SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('secret password', 512));

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL
);

CREATE TABLE sites (
  site_id INT AUTO_INCREMENT PRIMARY KEY,
  site_name VARCHAR(100) NOT NULL,
  url VARCHAR(255) NOT NULL,
  user_id INT NOT NULL,
  comment VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE credentials (
  credential_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  site_id INT NOT NULL,
  email VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL,
  encrypted_password VARBINARY(512) NOT NULL,
  iv VARBINARY(16) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (site_id) REFERENCES sites(site_id) ON DELETE CASCADE
);

INSERT INTO users(first_name, last_name)
VALUES ('Jake', 'Balula');

INSERT INTO sites (site_name, url, user_id, comment) VALUES
 ('Gmail',     'https://mail.google.com', 1, 'Personal email'),
 ('YouTube',   'https://www.youtube.com', 1, 'Youtube Account'),
 ('Amazon',    'https://www.amazon.com', 1, 'Amazon account'),
 ('GitHub',    'https://github.com',      1, 'Coding projects'),
 ('LinkedIn',  'https://www.linkedin.com',1, 'Linkedin Profile'),
 ('Instagram', 'https://instagram.com',   1, 'Instagram Account'),
 ('Netflix',   'https://www.netflix.com', 1, 'Family Netflix Account'),
 ('Spotify',   'https://www.spotify.com', 1, 'Music account'),
 ('Reddit',    'https://www.reddit.com',  1, 'Reddit Account'),
 ('Steam',     'https://store.steampowered.com', 1, 'Gaming account');

SET @iv1 = RANDOM_BYTES(16);
SET @iv2 = RANDOM_BYTES(16);
SET @iv3 = RANDOM_BYTES(16);
SET @iv4 = RANDOM_BYTES(16);
SET @iv5 = RANDOM_BYTES(16);
SET @iv6 = RANDOM_BYTES(16);
SET @iv7 = RANDOM_BYTES(16);
SET @iv8 = RANDOM_BYTES(16);
SET @iv9 = RANDOM_BYTES(16);
SET @iv10 = RANDOM_BYTES(16);

INSERT INTO credentials (user_id, site_id, email, username, encrypted_password, iv) VALUES
 (1, 1, 'jakebalula@gmail.com', 'jakebalula',
     AES_ENCRYPT('password123', @key_str, @iv1), @iv1),
 (1, 2, 'jakebalula@gmail.com', 'balulajake',
     AES_ENCRYPT('MyYoutubePassword!', @key_str, @iv2), @iv2),
 (1, 3, 'AmazonEmail@example.com', 'AmazonUser',
     AES_ENCRYPT('MyAmazonPassword', @key_str, @iv3), @iv3),
 (1, 4, 'balula@hartford.edu', 'jbalula',
     AES_ENCRYPT('MyGitPassword$', @key_str, @iv4), @iv4),
 (1, 5, 'balulajake@gmail.com', 'Jacob Balula',
     AES_ENCRYPT('MyLinkedInPassword123', @key_str, @iv5), @iv5),
 (1, 6, 'instaemail@example.com', 'jake_balula',
     AES_ENCRYPT('MyInstaPass123!', @key_str, @iv6), @iv6),
 (1, 7, 'familyNetflix@email.com', 'FamNetflix',
     AES_ENCRYPT('MyFamilysNetflixpass!', @key_str, @iv7), @iv7),
 (1, 8, 'musicEmail@spotify.com', 'MusicListener123',
     AES_ENCRYPT('DontHackMySpotify', @key_str, @iv8), @iv8),
 (1, 9, 'redditemail@reddit.com', 'RedditUser123',
     AES_ENCRYPT('RedditPass123', @key_str, @iv9), @iv9),
 (1,10, 'gamingemail@steam.com', 'strx05',
     AES_ENCRYPT('PasswordToPlaySomeGames', @key_str, @iv10), @iv10);

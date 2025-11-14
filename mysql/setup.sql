DROP DATABASE IF EXISTS passwords;
DROP USER IF EXISTS 'passwords_user'@'localhost';

CREATE DATABASE student_passwords DEFAULT CHARACTER SET utf8mb4;

CREATE USER 'passwords_user'@'localhost';

GRANT ALL PRIVILEGES ON student_passwords.* TO 'passwords_user'@'localhost';
FLUSH PRIVILEGES

USE student_passwords;

SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('secret password', 512));
SET @init_vector = RANDOM_BYTES(16);

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
  CONSTRAINT fk_sites_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
);

CREATE TABLE credentials (
  credential_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  site_id INT NOT NULL,
  email VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL,
  encrypted_password VARBINARY(512) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_credentials_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_credentials_site
    FOREIGN KEY (site_id) REFERENCES sites(site_id)
    ON DELETE CASCADE
);

INSERT INTO users(first_name, last_name) VALUES
('Jake', 'Balula');

INSERT INTO sites(site_name, url, user_id, comment, init_vector)
VALUES
  ('Gmail', 'https://mail.google.com', 1, 'Personal email', @init_vector),
  ('YouTube', 'https://www.youtube.com', 1, 'Youtube Account', @init_vector),
  ('Amazon', 'https://www.amazon.com', 1, 'Amazon account', @init_vector),
  ('GitHub', 'https://github.com', 1, 'Coding projects', @init_vector),
  ('LinkedIn', 'https://www.linkedin.com', 1, 'Linkedin Profile', @init_vector),
  ('Instagram', 'https://instagram.com', 1, 'Instagram Account', @init_vector),
  ('Netflix', 'https://www.netflix.com', 1, 'Family Netflix Account', @init_vector),
  ('Spotify', 'https://www.spotify.com', 1, 'Music account', @init_vector),
  ('Reddit', 'https://www.reddit.com', 1, 'Reddit Account', @init_vector),
  ('Steam', 'https://store.steampowered.com', 1, 'Gaming account', @init_vector);

INSERT INTO credentials(user_id, site_id, email, username, encrypted_password)
VALUES
  (1, 1, 'jakebalula@gmail.com',      'jakebalula',
    AES_ENCRYPT('password123', UNHEX(SHA2('secret password', 512)))),
  (1, 2, 'jakebalula@gmail.com',      'balulajake',
    AES_ENCRYPT('MyYoutubePassword!', UNHEX(SHA2('secret password', 512)))),
  (1, 3, 'AmazonEmail@example.com',   'AmazonUser',
    AES_ENCRYPT('MyAmazonPassword',   UNHEX(SHA2('secret password', 512)))),
  (1, 4, 'balula@hartford.edu',       'jbalula',
    AES_ENCRYPT('MyGitPassword$',     UNHEX(SHA2('secret password', 512)))),
  (1, 5, 'balulajake@gmail.com',      'Jacob Balula',
    AES_ENCRYPT('MyLinkedInPassword123', UNHEX(SHA2('secret password', 512)))),
  (1, 6, 'instaemail@example.com',    'jake_balula',
    AES_ENCRYPT('MyInstaPass123!',    UNHEX(SHA2('secret password', 512)))),
  (1, 7, 'familyNetflix@email.com',   'FamNetflix',
    AES_ENCRYPT('MyFamilysNetflixpass!', UNHEX(SHA2('secret password', 512)))),
  (1, 8, 'musicEmail@spotify.com',    'MusicListener123',
    AES_ENCRYPT('DontHackMySpotify',  UNHEX(SHA2('secret password', 512)))),
  (1, 9, 'redditemail@reddit.com',    'RedditUser123',
    AES_ENCRYPT('RedditPass123',      UNHEX(SHA2('secret password', 512)))),
  (1,10, 'gamingemail@steam.com',     'strx05',
    AES_ENCRYPT('PasswordToPlaySomeGames', UNHEX(SHA2('secret password', 512))));

module.exports = {
  up: `
    CREATE TABLE todos (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      user_id INT UNSIGNED NOT NULL,
      title VARCHAR(150) NOT NULL,
      description TEXT NULL,
      type ENUM('task', 'note') NOT NULL DEFAULT 'task',
      start_at DATETIME NULL,
      end_at DATETIME NULL,
      reminder TINYINT(1) NOT NULL DEFAULT 0,
      is_done TINYINT(1) NOT NULL DEFAULT 0,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      KEY idx_todos_user (user_id),
      CONSTRAINT fk_todos_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `,
  down: 'DROP TABLE IF EXISTS todos',
};

require('dotenv').config();
const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

const dir = path.join(__dirname, 'migrations');
const files = fs.readdirSync(dir).filter((f) => f.endsWith('.js')).sort();

async function main() {
  const command = process.argv[2] || 'up';
  const dbName = process.env.DB_NAME || 'todo';

  const root = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
  });
  await root.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\` CHARACTER SET utf8mb4`);
  await root.end();

  const db = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: dbName,
  });

  await db.query(`
    CREATE TABLE IF NOT EXISTS migrations (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL UNIQUE,
      run_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
  `);

  const [rows] = await db.query('SELECT name FROM migrations ORDER BY id');
  const done = rows.map((r) => r.name);

  const rollbackOne = async (name) => {
    const migration = require(path.join(dir, name));
    await db.query(migration.down);
    await db.query('DELETE FROM migrations WHERE name = ?', [name]);
    console.log(`↩  rollback: ${name}`);
  };

  if (command === 'up' || command === 'fresh') {
    if (command === 'fresh') {
      for (const name of [...done].reverse()) await rollbackOne(name);
      done.length = 0;
    }
    const pending = files.filter((f) => !done.includes(f));
    if (!pending.length) console.log('Tidak ada migration baru.');
    for (const name of pending) {
      const migration = require(path.join(dir, name));
      await db.query(migration.up);
      await db.query('INSERT INTO migrations (name) VALUES (?)', [name]);
      console.log(`✔  migrated: ${name}`);
    }
  } else if (command === 'down') {
    if (!done.length) console.log('Tidak ada migration untuk di-rollback.');
    else await rollbackOne(done[done.length - 1]);
  } else {
    console.log('Perintah tidak dikenal. Gunakan: up | down | fresh');
  }

  await db.end();
}

main().catch((err) => {
  console.error('Migration gagal:', err.message);
  process.exit(1);
});

require('dotenv').config();
const bcrypt = require('bcryptjs');
const pool = require('../config/db');

const pad = (n) => String(n).padStart(2, '0');
function dateOffset(days) {
  const d = new Date();
  d.setDate(d.getDate() + days);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

async function main() {
  const email = 'email@gmail.com';
  const [exists] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
  if (exists.length) {
    console.log('Seed sudah pernah dijalankan (user demo sudah ada).');
    return pool.end();
  }

  const hash = await bcrypt.hash('password123', 10);
  const [user] = await pool.query(
    'INSERT INTO users (name, email, password, phone, address) VALUES (?, ?, ?, ?, ?)',
    ['email', email, hash, '+7 904 599 XXX 11', 'St. Petersburg, Vos...']
  );
  const uid = user.insertId;
  const today = dateOffset(0);
  const nextDay = dateOffset(1);

  const todos = [
    [uid, 'Design Wireframe', null, 'task', `${today} 08:00:00`, `${today} 09:00:00`, 1],
    [uid, 'Meet with client', null, 'task', `${today} 10:00:00`, `${today} 11:00:00`, 1],
    [uid, "April's content selection", "In april's content selection...", 'note', null, null, 0],
    [uid, 'Brainstorming session - ideas', null, 'task', `${nextDay} 08:00:00`, `${nextDay} 17:00:00`, 1],
  ];
  for (const t of todos) {
    await pool.query(
      'INSERT INTO todos (user_id, title, description, type, start_at, end_at, reminder) VALUES (?,?,?,?,?,?,?)',
      t
    );
  }

  await pool.query('INSERT INTO notifications (user_id, title, message) VALUES (?, ?, ?)', [
    uid,
    'Aktifitas Login baru',
    'Akun kamu baru saja login dari perangkat baru.',
  ]);

  console.log('Seed berhasil. Login demo: email@gmail.com / password123');
  await pool.end();
}

main().catch((err) => {
  console.error('Seed gagal:', err.message);
  process.exit(1);
});

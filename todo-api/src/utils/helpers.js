const pool = require('../config/db');

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

const pad = (n) => String(n).padStart(2, '0');

function todayString() {
  const d = new Date();
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function dateLabel(dateStr) {
  if (dateStr === todayString()) return 'Today';
  const [, m, d] = dateStr.split('-');
  return `${Number(d)} ${MONTHS[Number(m) - 1]}`;
}

function parseDateTime(value) {
  if (value === undefined || value === null || value === '') return null;
  const s = String(value).trim().replace('T', ' ');
  const m = s.match(/^(\d{4}-\d{2}-\d{2}) (\d{2}):(\d{2})(?::(\d{2}))?$/);
  if (!m) return undefined;
  return `${m[1]} ${m[2]}:${m[3]}:${m[4] || '00'}`;
}

async function createNotification(userId, title, message) {
  await pool.query('INSERT INTO notifications (user_id, title, message) VALUES (?, ?, ?)', [userId, title, message]);
}

module.exports = { todayString, dateLabel, parseDateTime, createNotification };

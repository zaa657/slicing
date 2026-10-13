const pool = require('../config/db');

const format = (n) => ({
  id: n.id,
  title: n.title,
  message: n.message,
  is_read: !!n.is_read,
  created_at: n.created_at,
});

// GET /api/notifications
exports.list = async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC, id DESC', [
      req.user.id,
    ]);
    const unread = rows.filter((r) => !r.is_read).length;
    res.json({ unread_count: unread, data: rows.map(format) });
  } catch (err) {
    next(err);
  }
};

// PATCH /api/notifications/:id/read
exports.markRead = async (req, res, next) => {
  try {
    const [result] = await pool.query('UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?', [
      req.params.id,
      req.user.id,
    ]);
    if (!result.affectedRows) return res.status(404).json({ message: 'Notifikasi tidak ditemukan' });
    res.json({ message: 'Notifikasi ditandai sudah dibaca' });
  } catch (err) {
    next(err);
  }
};

// PATCH /api/notifications/read-all
exports.markAllRead = async (req, res, next) => {
  try {
    await pool.query('UPDATE notifications SET is_read = 1 WHERE user_id = ?', [req.user.id]);
    res.json({ message: 'Semua notifikasi ditandai sudah dibaca' });
  } catch (err) {
    next(err);
  }
};

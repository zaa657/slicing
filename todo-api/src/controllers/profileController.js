const pool = require('../config/db');

const format = (u) => ({
  id: u.id,
  name: u.name,
  email: u.email,
  phone: u.phone,
  address: u.address,
  avatar: u.avatar,
});

// GET /api/profile
exports.get = async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM users WHERE id = ?', [req.user.id]);
    if (!rows.length) return res.status(404).json({ message: 'User tidak ditemukan' });
    res.json({ data: format(rows[0]) });
  } catch (err) {
    next(err);
  }
};

// PUT /api/profile
exports.update = async (req, res, next) => {
  try {
    const values = {};
    for (const key of ['name', 'phone', 'address', 'avatar']) {
      if (req.body[key] !== undefined) values[key] = req.body[key] || null;
    }
    if (values.name === null) return res.status(422).json({ message: 'Name tidak boleh kosong' });
    if (!Object.keys(values).length) return res.status(422).json({ message: 'Tidak ada data yang diubah' });

    await pool.query('UPDATE users SET ? WHERE id = ?', [values, req.user.id]);
    const [rows] = await pool.query('SELECT * FROM users WHERE id = ?', [req.user.id]);
    res.json({ message: 'Profil berhasil diubah', data: format(rows[0]) });
  } catch (err) {
    next(err);
  }
};

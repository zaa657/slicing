const pool = require('../config/db');
const { dateLabel, parseDateTime } = require('../utils/helpers');

const TYPES = ['task', 'note'];

const format = (t) => ({
  id: t.id,
  title: t.title,
  description: t.description,
  type: t.type,
  start_at: t.start_at,
  end_at: t.end_at,
  reminder: !!t.reminder,
  is_done: !!t.is_done,
  created_at: t.created_at,
});

function validate(body, { partial }) {
  const values = {};

  if (!partial || body.title !== undefined) {
    if (!body.title || !String(body.title).trim()) return { error: 'Title wajib diisi' };
    values.title = String(body.title).trim();
  }
  
  if (body.description !== undefined) values.description = body.description || null;

  if (body.type !== undefined) {
    if (!TYPES.includes(body.type)) return { error: `type harus salah satu dari: ${TYPES.join(', ')}` };
    values.type = body.type;
  }

  for (const key of ['start_at', 'end_at']) {
    if (body[key] !== undefined) {
      const parsed = parseDateTime(body[key]);
      if (parsed === undefined) return { error: `${key} harus berformat "YYYY-MM-DD HH:mm:ss"` };
      values[key] = parsed;
    }
  }
  if (values.start_at && values.end_at && values.end_at < values.start_at) {
    return { error: 'end_at tidak boleh lebih awal dari start_at' };
  }
  if (body.reminder !== undefined) values.reminder = body.reminder ? 1 : 0;
  if (body.is_done !== undefined) values.is_done = body.is_done ? 1 : 0;

  return { values };
}

// GET /api/todos?search=kata&type=task|note&is_done=0|1
exports.list = async (req, res, next) => {
  try {
    const where = ['user_id = ?'];
    const params = [req.user.id];

    if (req.query.search) {
      where.push('(title LIKE ? OR description LIKE ?)');
      params.push(`%${req.query.search}%`, `%${req.query.search}%`);
    }
    if (req.query.type && TYPES.includes(req.query.type)) {
      where.push('type = ?');
      params.push(req.query.type);
    }
    if (req.query.is_done !== undefined && ['0', '1'].includes(req.query.is_done)) {
      where.push('is_done = ?');
      params.push(Number(req.query.is_done));
    }

    const [rows] = await pool.query(
      `SELECT * FROM todos WHERE ${where.join(' AND ')} ORDER BY COALESCE(start_at, created_at) ASC, id ASC`,
      params
    );
    res.json({ data: rows.map(format) });
  } catch (err) {
    next(err);
  }
};

// GET /api/todos/grouped?search=kata
exports.grouped = async (req, res, next) => {
  try {
    const where = ['user_id = ?'];
    const params = [req.user.id];
    if (req.query.search) {
      where.push('(title LIKE ? OR description LIKE ?)');
      params.push(`%${req.query.search}%`, `%${req.query.search}%`);
    }

    const [rows] = await pool.query(
      `SELECT *, DATE(COALESCE(start_at, created_at)) AS group_date
       FROM todos WHERE ${where.join(' AND ')}
       ORDER BY COALESCE(start_at, created_at) ASC, id ASC`,
      params
    );

    const groups = new Map();
    for (const row of rows) {
      if (!groups.has(row.group_date)) groups.set(row.group_date, []);
      groups.get(row.group_date).push(format(row));
    }

    const data = [...groups.entries()].map(([date, items]) => ({
      date,
      label: dateLabel(date),
      count: items.length,
      items,
    }));
    res.json({ data });
  } catch (err) {
    next(err);
  }
};

// GET /api/todos/:id
exports.detail = async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM todos WHERE id = ? AND user_id = ?', [req.params.id, req.user.id]);
    if (!rows.length) return res.status(404).json({ message: 'Todo tidak ditemukan' });
    res.json({ data: format(rows[0]) });
  } catch (err) {
    next(err);
  }
};

// POST /api/todos
exports.create = async (req, res, next) => {
  try {
    const { error, values } = validate(req.body, { partial: false });
    if (error) return res.status(422).json({ message: error });

    const [result] = await pool.query('INSERT INTO todos SET ?', [{ ...values, user_id: req.user.id }]);
    const [rows] = await pool.query('SELECT * FROM todos WHERE id = ?', [result.insertId]);
    res.status(201).json({ message: 'Todo berhasil dibuat', data: format(rows[0]) });
  } catch (err) {
    next(err);
  }
};

// PUT /api/todos/:id
exports.update = async (req, res, next) => {
  try {
    const { error, values } = validate(req.body, { partial: true });
    if (error) return res.status(422).json({ message: error });
    if (!Object.keys(values).length) return res.status(422).json({ message: 'Tidak ada data yang diubah' });

    const [result] = await pool.query('UPDATE todos SET ? WHERE id = ? AND user_id = ?', [
      values,
      req.params.id,
      req.user.id,
    ]);
    if (!result.affectedRows) return res.status(404).json({ message: 'Todo tidak ditemukan' });

    const [rows] = await pool.query('SELECT * FROM todos WHERE id = ?', [req.params.id]);
    res.json({ message: 'Todo berhasil diubah', data: format(rows[0]) });
  } catch (err) {
    next(err);
  }
};

// PATCH /api/todos/:id/done
exports.toggleDone = async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM todos WHERE id = ? AND user_id = ?', [req.params.id, req.user.id]);
    if (!rows.length) return res.status(404).json({ message: 'Todo tidak ditemukan' });

    const next_value = req.body.is_done !== undefined ? (req.body.is_done ? 1 : 0) : rows[0].is_done ? 0 : 1;
    await pool.query('UPDATE todos SET is_done = ? WHERE id = ?', [next_value, req.params.id]);
    res.json({ message: 'Status todo diperbarui', data: format({ ...rows[0], is_done: next_value }) });
  } catch (err) {
    next(err);
  }
};

// DELETE /api/todos/:id
exports.remove = async (req, res, next) => {
  try {
    const [result] = await pool.query('DELETE FROM todos WHERE id = ? AND user_id = ?', [req.params.id, req.user.id]);
    if (!result.affectedRows) return res.status(404).json({ message: 'Todo tidak ditemukan' });
    res.json({ message: 'Todo berhasil dihapus' });
  } catch (err) {
    next(err);
  }
};

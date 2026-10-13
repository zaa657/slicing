const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');
const { createNotification } = require('../utils/helpers');

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function signToken(user) {
  return jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '1d',
  });
}

function publicUser(u) {
  return { id: u.id, name: u.name, email: u.email };
}

// POST /api/auth/register
exports.register = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const name = req.body.name;

    if (!email || !EMAIL_REGEX.test(email)) {
      return res.status(422).json({ message: 'Email tidak valid' });
    }
    if (!password || password.length < 8) {
      return res.status(422).json({ message: 'Password minimal 8 karakter' });
    }

    const [exists] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
    if (exists.length) {
      return res.status(409).json({ message: 'Email sudah terdaftar' });
    }

    const hash = await bcrypt.hash(password, 10);
    const displayName = (name && name.trim()) || email.split('@')[0];
    const [result] = await pool.query('INSERT INTO users (name, email, password) VALUES (?, ?, ?)', [
      displayName,
      email,
      hash,
    ]);

    const user = { id: result.insertId, name: displayName, email };
    await createNotification(user.id, 'Selamat datang di todo', 'Akun kamu berhasil dibuat.');

    res.status(201).json({
      message: 'Registrasi berhasil',
      data: { token: signToken(user), user: publicUser(user) },
    });
  } catch (err) {
    next(err);
  }
};

// POST /api/auth/login
exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(422).json({ message: 'Email dan password wajib diisi' });
    }

    const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    const user = rows[0];
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: 'Email atau password salah' });
    }

    await createNotification(user.id, 'Aktifitas Login baru', 'Akun kamu baru saja login.');

    res.json({
      message: 'Login berhasil',
      data: { token: signToken(user), user: publicUser(user) },
    });
  } catch (err) {
    next(err);
  }
};

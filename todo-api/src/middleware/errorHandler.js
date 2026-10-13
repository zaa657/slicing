function notFound(req, res) {
  res.status(404).json({ message: `Route ${req.method} ${req.originalUrl} tidak ditemukan` });
}

function errorHandler(err, req, res, next) {
  if (err.type === 'entity.parse.failed') {
    return res.status(400).json({ message: 'Body JSON tidak valid' });
  }
  console.error(err);
  res.status(500).json({ message: 'Terjadi kesalahan pada server' });
}

module.exports = { notFound, errorHandler };

require('dotenv').config();
const app = require('./app');

if (!process.env.JWT_SECRET) {
  console.error('JWT_SECRET belum di-set. Salin .env.example menjadi .env lalu isi nilainya.');
  process.exit(1);
}

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server berjalan di http://localhost:${port}`));

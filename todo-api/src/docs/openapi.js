const bearer = [{ bearerAuth: [] }];

const ref = (name) => ({ $ref: `#/components/schemas/${name}` });
const json = (schema) => ({ 'application/json': { schema } });
const error = (description) => ({ description, content: json(ref('Error')) });

const responses401 = { 401: error('Token tidak ada / tidak valid / kedaluwarsa') };
const idParam = { name: 'id', in: 'path', required: true, schema: { type: 'integer', example: 1 } };

const todoExample = {
  title: 'Design Wireframe',
  description: 'Opsional',
  type: 'task',
  start_at: '2026-10-11 08:00:00',
  end_at: '2026-10-11 09:00:00',
  reminder: true,
};

module.exports = {
  openapi: '3.0.3',
  info: {
    title: 'todo API',
    version: '1.0.0',
    description:
      'API latihan **Login JWT + Todo List** untuk slicing design Flutter.\n\n' +
      '### Cara Menggunakan API ini\n' +
      '1. Buka **Auth → POST /auth/login**, klik *Try it out*, lalu *Execute* (akun demo: `email@gmail.com` / `password123`).\n' +
      '2. Salin `token` dari response.\n' +
      '3. Klik tombol **Authorize** 🔓 di kanan atas, tempel token (tanpa kata "Bearer"), lalu *Authorize*.\n' +
      '4. Sekarang semua endpoint bergembok 🔒 bisa dicoba.',
  },
  servers: [{ url: '/api', description: 'Server saat ini' }],
  tags: [
    { name: 'Auth', description: 'API Auth: daftar & login' },
    { name: 'Todo', description: 'API Todo: CRUD todo list' },
    { name: 'Notifikasi', description: 'API Inbox: CRUD Inbox' },
    { name: 'Profil', description: 'API Profil' },
  ],
  components: {
    securitySchemes: {
      bearerAuth: { type: 'http', scheme: 'bearer', bearerFormat: 'JWT' },
    },
    schemas: {
      Error: {
        type: 'object',
        properties: { message: { type: 'string', example: 'Error' } },
      },
      AuthUser: {
        type: 'object',
        properties: {
          id: { type: 'integer', example: 1 },
          name: { type: 'string', example: 'Ralph' },
          email: { type: 'string', example: 'ralph@example.com' },
        },
      },
      AuthResponse: {
        type: 'object',
        properties: {
          message: { type: 'string', example: 'Login berhasil' },
          data: {
            type: 'object',
            properties: {
              token: { type: 'string', example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' },
              user: ref('AuthUser'),
            },
          },
        },
      },
      Todo: {
        type: 'object',
        properties: {
          id: { type: 'integer', example: 1 },
          title: { type: 'string', example: 'Design Wireframe' },
          description: { type: 'string', nullable: true, example: null },
          type: { type: 'string', enum: ['task', 'note'], example: 'task' },
          start_at: { type: 'string', nullable: true, example: '2026-10-11 08:00:00' },
          end_at: { type: 'string', nullable: true, example: '2026-10-11 09:00:00' },
          reminder: { type: 'boolean', example: true },
          is_done: { type: 'boolean', example: false },
          created_at: { type: 'string', example: '2026-10-11 14:40:00' },
        },
      },
      TodoInput: {
        type: 'object',
        required: ['title'],
        properties: {
          title: { type: 'string', example: todoExample.title },
          description: { type: 'string', example: todoExample.description },
          type: { type: 'string', enum: ['task', 'note'], default: 'task' },
          start_at: { type: 'string', description: 'Format YYYY-MM-DD HH:mm:ss', example: todoExample.start_at },
          end_at: { type: 'string', description: 'Format YYYY-MM-DD HH:mm:ss', example: todoExample.end_at },
          reminder: { type: 'boolean', example: true },
        },
      },
      TodoGroup: {
        type: 'object',
        properties: {
          date: { type: 'string', example: '2026-10-11' },
          label: { type: 'string', description: '"Today" atau tanggal singkat seperti "30 Apr"', example: 'Today' },
          count: { type: 'integer', example: 3 },
          items: { type: 'array', items: ref('Todo') },
        },
      },
      Notification: {
        type: 'object',
        properties: {
          id: { type: 'integer', example: 1 },
          title: { type: 'string', example: 'Aktifitas Login baru' },
          message: { type: 'string', example: 'Akun kamu baru saja login.' },
          is_read: { type: 'boolean', example: false },
          created_at: { type: 'string', example: '2026-10-11 14:40:00' },
        },
      },
      Profile: {
        type: 'object',
        properties: {
          id: { type: 'integer', example: 1 },
          name: { type: 'string', example: 'Ralph' },
          email: { type: 'string', example: 'ralph@example.com' },
          phone: { type: 'string', nullable: true, example: '+7 904 599 XXX 11' },
          address: { type: 'string', nullable: true, example: 'St. Petersburg, Vos...' },
          avatar: { type: 'string', nullable: true, example: 'https://contoh.com/foto.jpg' },
        },
      },
    },
  },
  paths: {
    // Auth
    '/auth/register': {
      post: {
        tags: ['Auth'],
        summary: 'Daftar akun baru',
        description: 'Password minimal 8 karakter. Jika `name` kosong, dipakai bagian depan email.',
        requestBody: {
          required: true,
          content: json({
            type: 'object',
            required: ['email', 'password'],
            properties: {
              email: { type: 'string', example: 'email' },
              password: { type: 'string', example: 'password' },
              name: { type: 'string', example: 'nama (opsional)' },
            },
          }),
        },
        responses: {
          201: { description: 'Registrasi berhasil', content: json(ref('AuthResponse')) },
          409: error('Email sudah terdaftar'),
          422: error('Email tidak valid / password kurang dari 8 karakter'),
        },
      },
    },
    '/auth/login': {
      post: {
        tags: ['Auth'],
        summary: 'Login dan dapatkan token JWT',
        description: 'Setiap login membuat notifikasi "Aktifitas Login baru".',
        requestBody: {
          required: true,
          content: json({
            type: 'object',
            required: ['email', 'password'],
            properties: {
              email: { type: 'string', example: 'email@gmail.com' },
              password: { type: 'string', example: 'password123' },
            },
          }),
        },
        responses: {
          200: { description: 'Login berhasil', content: json(ref('AuthResponse')) },
          401: error('Email atau password salah'),
          422: error('Email / password kosong'),
        },
      },
    },

    // Todo
    '/todos': {
      get: {
        tags: ['Todo'],
        summary: 'List semua todo',
        security: bearer,
        parameters: [
          { name: 'search', in: 'query', description: 'judul / deskripsi', schema: { type: 'string' } },
          { name: 'type', in: 'query', description: 'Type',  schema: { type: 'string', enum: ['task', 'note'] } },
          { name: 'is_done', in: 'query', description: 'Status', schema: { type: 'string', enum: ['0', '1'] } },
        ],
        responses: {
          200: {
            description: 'Berhasil',
            content: json({ type: 'object', properties: { data: { type: 'array', items: ref('Todo') } } }),
          },
          ...responses401,
        },
      },
      post: {
        tags: ['Todo'],
        summary: 'Tambah todo',
        security: bearer,
        requestBody: { required: true, content: json(ref('TodoInput')) },
        responses: {
          201: {
            description: 'Todo dibuat',
            content: json({
              type: 'object',
              properties: { message: { type: 'string', example: 'Todo berhasil dibuat' }, data: ref('Todo') },
            }),
          },
          422: error('Validasi gagal (title kosong, color/type salah, format tanggal salah)'),
          ...responses401,
        },
      },
    },
    '/todos/grouped': {
      get: {
        tags: ['Todo'],
        summary: 'Todo dikelompokkan per tanggal (halaman Home)',
        description: 'Tampilkan `label` dan `count` sebagai judul grup, misalnya **Today (3)**.',
        security: bearer,
        parameters: [{ name: 'search', in: 'query', description: 'Cari di judul / deskripsi', schema: { type: 'string' } }],
        responses: {
          200: {
            description: 'Berhasil',
            content: json({ type: 'object', properties: { data: { type: 'array', items: ref('TodoGroup') } } }),
          },
          ...responses401,
        },
      },
    },
    '/todos/{id}': {
      get: {
        tags: ['Todo'],
        summary: 'Detail satu todo',
        security: bearer,
        parameters: [idParam],
        responses: {
          200: { description: 'Berhasil', content: json({ type: 'object', properties: { data: ref('Todo') } }) },
          404: error('Todo tidak ditemukan'),
          ...responses401,
        },
      },
      put: {
        tags: ['Todo'],
        summary: 'Ubah todo',
        description: 'Boleh kirim sebagian field saja.',
        security: bearer,
        parameters: [idParam],
        requestBody: {
          required: true,
          content: json({
            allOf: [ref('TodoInput')],
            example: { title: 'Design Wireframe v2', color: 'blue' },
          }),
        },
        responses: {
          200: {
            description: 'Todo diubah',
            content: json({
              type: 'object',
              properties: { message: { type: 'string', example: 'Todo berhasil diubah' }, data: ref('Todo') },
            }),
          },
          404: error('Todo tidak ditemukan'),
          422: error('Validasi gagal'),
          ...responses401,
        },
      },
      delete: {
        tags: ['Todo'],
        summary: 'Hapus todo',
        security: bearer,
        parameters: [idParam],
        responses: {
          200: {
            description: 'Todo dihapus',
            content: json({ type: 'object', properties: { message: { type: 'string', example: 'Todo berhasil dihapus' } } }),
          },
          404: error('Todo tidak ditemukan'),
          ...responses401,
        },
      },
    },
    '/todos/{id}/done': {
      patch: {
        tags: ['Todo'],
        summary: 'Tandai selesai / belum selesai',
        description: 'Kirim `{ "is_done": true }`. Tanpa body, status akan di-toggle.',
        security: bearer,
        parameters: [idParam],
        requestBody: {
          required: false,
          content: json({ type: 'object', properties: { is_done: { type: 'boolean', example: true } } }),
        },
        responses: {
          200: {
            description: 'Status diperbarui',
            content: json({
              type: 'object',
              properties: { message: { type: 'string', example: 'Status todo diperbarui' }, data: ref('Todo') },
            }),
          },
          404: error('Todo tidak ditemukan'),
          ...responses401,
        },
      },
    },

    // Notifikasi
    '/notifications': {
      get: {
        tags: ['Notifikasi'],
        summary: 'Daftar notifikasi',
        description: '`unread_count` dipakai untuk titik merah di ikon lonceng.',
        security: bearer,
        responses: {
          200: {
            description: 'Berhasil',
            content: json({
              type: 'object',
              properties: {
                unread_count: { type: 'integer', example: 1 },
                data: { type: 'array', items: ref('Notification') },
              },
            }),
          },
          ...responses401,
        },
      },
    },
    '/notifications/read-all': {
      patch: {
        tags: ['Notifikasi'],
        summary: 'Tandai semua notifikasi sudah dibaca',
        security: bearer,
        responses: {
          200: {
            description: 'Berhasil',
            content: json({
              type: 'object',
              properties: { message: { type: 'string', example: 'Semua notifikasi ditandai sudah dibaca' } },
            }),
          },
          ...responses401,
        },
      },
    },
    '/notifications/{id}/read': {
      patch: {
        tags: ['Notifikasi'],
        summary: 'Tandai satu notifikasi sudah dibaca',
        security: bearer,
        parameters: [idParam],
        responses: {
          200: {
            description: 'Berhasil',
            content: json({
              type: 'object',
              properties: { message: { type: 'string', example: 'Notifikasi ditandai sudah dibaca' } },
            }),
          },
          404: error('Notifikasi tidak ditemukan'),
          ...responses401,
        },
      },
    },

    // Profil
    '/profile': {
      get: {
        tags: ['Profil'],
        summary: 'Lihat profil',
        security: bearer,
        responses: {
          200: { description: 'Berhasil', content: json({ type: 'object', properties: { data: ref('Profile') } }) },
          ...responses401,
        },
      },
      put: {
        tags: ['Profil'],
        summary: 'Ubah profil',
        description: 'Kirim field yang ingin diubah saja. Email tidak bisa diubah. `avatar` berupa URL gambar.',
        security: bearer,
        requestBody: {
          required: true,
          content: json({
            type: 'object',
            properties: {
              name: { type: 'string', example: 'Alex Gilles' },
              phone: { type: 'string', example: '+62 812 3456 7890' },
              address: { type: 'string', example: 'Depok, Jawa Barat' },
              avatar: { type: 'string', example: 'https://contoh.com/foto.jpg' },
            },
          }),
        },
        responses: {
          200: {
            description: 'Profil diubah',
            content: json({
              type: 'object',
              properties: { message: { type: 'string', example: 'Profil berhasil diubah' }, data: ref('Profile') },
            }),
          },
          422: error('Name kosong / tidak ada data yang diubah'),
          ...responses401,
        },
      },
    },
  },
};

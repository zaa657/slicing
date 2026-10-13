const router = require('express').Router();
const auth = require('../middleware/auth');
const authController = require('../controllers/authController');
const todoController = require('../controllers/todoController');
const notificationController = require('../controllers/notificationController');
const profileController = require('../controllers/profileController');

// Public
router.post('/auth/register', authController.register);
router.post('/auth/login', authController.login);

// Protected (Authorization: Bearer <token>)
router.use(auth);

// Todo (Home & Inbox)
router.get('/todos', todoController.list);
router.get('/todos/grouped', todoController.grouped);
router.get('/todos/:id', todoController.detail);
router.post('/todos', todoController.create);
router.put('/todos/:id', todoController.update);
router.patch('/todos/:id/done', todoController.toggleDone);
router.delete('/todos/:id', todoController.remove);

// Notifikasi (Inbox)
router.get('/notifications', notificationController.list);
router.patch('/notifications/read-all', notificationController.markAllRead);
router.patch('/notifications/:id/read', notificationController.markRead);

// Profil
router.get('/profile', profileController.get);
router.put('/profile', profileController.update);

module.exports = router;

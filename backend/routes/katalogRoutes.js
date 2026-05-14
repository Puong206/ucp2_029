const express = require('express');
const router = express.Router();

const katalogController = require('../controllers/katalogController');
const { verifyToken } = require('../middlewares/authMiddleware');
const upload = require('../middlewares/upload');

// Public routes (Read only)
router.get('/', katalogController.getAllKatalog);
router.get('/:id', katalogController.getKatalogById);

// Protected routes (Create, Update, Delete)
// Protected routes (Create, Update, Delete)
router.post('/', verifyToken, upload.single('image'), katalogController.createKatalog);
router.put('/:id', verifyToken, upload.single('image'), katalogController.updateKatalog);
router.delete('/:id', verifyToken, katalogController.deleteKatalog);

module.exports = router;
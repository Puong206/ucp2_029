const express = require('express');
const router = express.Router();

const kategoriController = require('../controllers/kategoriController');
const { verifyToken } = require('../middlewares/authMiddleware');

// Public routes (Read only)
router.get('/', kategoriController.getAllKategori);
router.get('/:id', kategoriController.getKategoriById);

// Protected routes (Create, Update, Delete)
router.post('/', verifyToken, kategoriController.createKategori);
router.put('/:id', verifyToken, kategoriController.updateKategori);
router.delete('/:id', verifyToken, kategoriController.deleteKategori);

module.exports = router;
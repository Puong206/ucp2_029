const express = require('express');
const router = express.Router();

const katalogController = require('../controllers/katalogController');
const { verifyToken } = require('../middlewares/authMiddleware');

// Public routes (Read only)
router.get('/', katalogController.getAllKatalog);
router.get('/:id', katalogController.getKatalogById);

// Protected routes (Create, Update, Delete)
router.post('/', verifyToken, katalogController.createKatalog);
router.put('/:id', verifyToken, katalogController.updateKatalog);
router.delete('/:id', verifyToken, katalogController.deleteKatalog);

module.exports = router;
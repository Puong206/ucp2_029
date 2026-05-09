const express = require('express');
const router = express.router();

const katalogController = require('../controllers/katalogController');

router.get('/', katalogController.getAllKatalog);
router.post('/', katalogController.createKatalog);
router.get('/:id', katalogController.getKatalogById);
router.put('/:id', katalogController.updateKatalog);
router.delete('/:id', katalogController.deleteKatalog);

module.exports = router;
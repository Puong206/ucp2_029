const db = require('../config/db');

exports.getAllKategori = (req, res) => {
    try {
        const [rows] = db.query('SELECT * FROM kategori');

        res.status(200).json({
            status: 'success',
            message: 'Data kategori berhasil diambil',
            data: rows
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};
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

exports.getKategoriById = async (req, res) => {
    try {
        const { id } = req.params;
        const [rows] = await db.query('SELECT * FROM kategori WHERE id = ?', [id]);

        if (rows.length === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'Kategori tidak ditemukan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Data kategori berhasil diambil',
            data: rows[0]
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};
const db = require('../config/db');

exports.getAllKatalog = async (req, res) => {
    try {
        const query = `
            SELECT katalog.*, kategori.nama AS nama_kategori
            FROM katalog
            LEFT JOIN kategori ON katalog.kategori_id = kategori.id
            ORDER BY katalog.created_at DESC
        `;
        const [rows] = await db.query(query);

        res.status(200).json({
            status: 'success',
            message: 'Data katalog berhasil diambil',
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
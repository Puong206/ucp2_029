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

exports.getKatalogById = async (req, res) => {
    try {
        const { id } = req.params;
        const query = `
            SELECT katalog.*, kategori.nama AS nama_kategori
            FROM katalog
            LEFT JOIN kategori ON katalog.kategori_id = kategori.id
            WHERE katalog.id = ?
        `;
        const [rows] = await db.query(query, [id]);

        if (rows.length === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'Data katalog tidak ditemukan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Data katalog berhasil diambil',
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

exports.createKatalog = async (req, res) => {
    try {
        const { kategori_id, brand, model, year, harga_per_hari, image_url, status } = req.body;

        
    } catch (error) {

    }
}
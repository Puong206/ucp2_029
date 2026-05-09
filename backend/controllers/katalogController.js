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

        if (!kategori_id || !brand || !model || !year || !harga_per_hari) {
            return res.status(400).json({
                status: 'error',
                message: 'Kategori, brand, model, year, dan harga_per_hari wajib diisi'
            });
        }

        const currentStatus = status || 'Tersedia';

        const [result] = await db.query(
            'INSERT INTO katalog (kategori_id, brand, model, year, harga_per_hari, image_url, status) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [kategori_id, brand, model, year || null, harga_per_hari, image_url || null, currentStatus]
        );

        res.status(201).json({
            status: 'success',
            message: 'Data katalog berhasil ditambahkan',
            data: { 
                id: result.insertId,
                kategori_id,
                brand,
                model,
                year,
                harga_per_hari,
                image_url,
                status: currentStatus
            }
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};
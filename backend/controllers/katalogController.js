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
        const { kategori_id, brand, model, year, transmisi, kapasitas, image_url, status } = req.body;

        if (!kategori_id || !brand || !model || !year || !transmisi || !kapasitas) {
            return res.status(400).json({
                status: 'error',
                message: 'Kategori, brand, model, year, transmisi, dan kapasitas wajib diisi'
            });
        }

        const validStatus = ['tersedia', 'tidak tersedia', 'perbaikan'];
        const currentStatus = validStatus.includes(status) ? status : 'tersedia';

        const [result] = await db.query(
            'INSERT INTO katalog (kategori_id, brand, model, year, transmisi, kapasitas, image_url, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [kategori_id, brand, model, year, transmisi, kapasitas, image_url || null, currentStatus]
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
                transmisi,
                kapasitas,
                image_url: image_url || null,
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

exports.updateKatalog = async (req, res) => {
    try {
        const { id } = req.params;
        const { kategori_id, brand, model, year, transmisi, kapasitas, image_url, status } = req.body;

        if (!kategori_id || !brand || !model || !year || !transmisi || !kapasitas) {
            return res.status(400).json({
                status: 'error',
                message: 'kategori_id, brand, model, year, transmisi, dan kapasitas wajib diisi!'
            });
        }

        const validStatus = ['tersedia', 'tidak tersedia', 'perbaikan'];
        const currentStatus = validStatus.includes(status) ? status : 'tersedia';

        const [result] = await db.query(
            'UPDATE katalog SET kategori_id=?, brand=?, model=?, year=?, transmisi=?, kapasitas=?, image_url=?, status=? WHERE id=?',
            [kategori_id, brand, model, year, transmisi, kapasitas, image_url || null, currentStatus, id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'Data katalog tidak ditemukan atau tidak ada perubahan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Data katalog berhasil diperbarui'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ status: 'error', message: 'Terjadi kesalahan pada server' });
    }
};

exports.deleteKatalog = async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.query('DELETE FROM katalog WHERE id = ?', [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'Data katalog tidak ditemukan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Data katalog berhasil dihapus'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ status: 'error', message: 'Terjadi kesalahan pada server' });
    }
};
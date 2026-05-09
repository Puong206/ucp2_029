const db = require('../config/db');

exports.getAllKategori = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM kategori');

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

exports.createKategori = async (req, res) => {
    try {
        const { nama, deskripsi } = req.body;

        if (!nama) {
            return res.status(400).json({
                status: 'error',
                message: 'Nama kategori wajib diisi'
            });
        }

        const [result] = await db.query(
            'INSERT INTO kategori (nama, deskripsi) VALUES (?, ?)',
            [nama, deskripsi || null]
        );

        res.status(201).json({
            status: 'success',
            message: 'Kategori berhasil dibuat',
            data: {
                id: result.insertId,
                nama,
                deskripsi
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

exports.updateKategori = async (req, res) => {
    try {
        const { id } = req.params;
        const { nama, deskripsi } = req.body;

        if (!nama) {
            return res.status(400).json({
                status: 'error',
                message: 'Nama kategori wajib diisi'
            });
        }

        const [result] = await db.query(
            'UPDATE kategori SET nama = ?, deskripsi = ? WHERE id = ?',
            [nama, deskripsi || null, id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'Kategori tidak ditemukan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Kategori berhasil diperbarui'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};

exports.deleteKategori = async (req, res) => {
    try {
        const { id } = req.params;
        const [result] = await db.query('DELETE FROM kategori WHERE id = ?', [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'Kategori tidak ditemukan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Kategori berhasil dihapus'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};
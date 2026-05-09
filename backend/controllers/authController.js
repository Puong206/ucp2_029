const db = require('../config/db');

exports.getAllUsers = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT id, username, email FROM users');
        res.status(200).json({
            status: 'success',
            message: 'Data pengguna berhasil diambil',
            data: rows
        });
    } catch (error) {
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};

exports.getUserById = async (req, res) => {
    try {
        const { id } = req.params;
        const [rows] = await db.query('SELECT id, username, email FROM users WHERE id = ?', [id]);

        if (rows.length === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'Pengguna tidak ditemukan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Data pengguna berhasil diambil',
            data: rows[0]
        });
    } catch (error) {
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};
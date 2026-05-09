const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'jwt_secret';

exports.register = async (req, res) => {
    try {
        const { nama, email, password, role } = req.body;

        if (!nama || !email || !password) {
            return res.status(400).json({
                status: 'error',
                message: 'Nama, email, dan password wajib diisi'
            });
        }

        const [existingUser] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        if (existingUser.length > 0) {
            return res.status(400).json({
                status: 'error',
                message: 'Email sudah terdaftar'
            });
        }

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        const userRole = role || 'user';
        
    } catch (error) {
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};
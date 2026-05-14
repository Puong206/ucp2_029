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

        const [result] = await db.query(
            'INSERT INTO users (nama, email, password, role) VALUES (?, ?, ?, ?)',
            [nama, email, hashedPassword, userRole]
        );

        res.status(201).json({
            status: 'success',
            message: 'Register berhasil',
            data: {
                id: result.insertId,
                nama,
                email,
                role: userRole
            }
        });

    } catch (error) {
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                status: 'error',
                message: 'Email dan password wajib diisi'
            });
        }

        console.log('Login attempt:', email);
        const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        console.log('Database query result:', users);
        
        if (users.length === 0) {
            return res.status(401).json({
                status: 'error',
                message: 'Email atau password salah'
            });
        }

        const user = users[0];
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({
                status: 'error',
                message: 'Email atau password salah'
            });
        }

        const payload = {
            id: user.id,
            nama: user.nama,
            role: user.role
        };

        const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1d' });

        res.status(200).json({
            status: 'success',
            message: 'Login berhasil',
            token: token,
            data: {
                id: user.id,
                nama: user.nama,
                email: user.email,
                role: user.role
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};

exports.logout = async (req, res) => {
    try {
        // In a stateless JWT approach, logout is handled on client side
        // by removing the token. Here we just send a success response.
        res.status(200).json({
            status: 'success',
            message: 'Logout berhasil. Silakan hapus token dari client.'
        });
    } catch (error) {
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};

exports.getMe = async (req, res) => {
    try {
        const userId = req.user.id;

        const [users] = await db.query('SELECT id, nama, email, role, created_at FROM users WHERE id = ?', [userId]);

        if (users.length === 0) {
            return res.status(404).json({
                status: 'error',
                message: 'User tidak ditemukan'
            });
        }

        res.status(200).json({
            status: 'success',
            message: 'Data user berhasil diambil',
            data: users[0]
        });

    } catch (error) {
        res.status(500).json({
            status: 'error',
            message: 'Terjadi kesalahan pada server'
        });
    }
};
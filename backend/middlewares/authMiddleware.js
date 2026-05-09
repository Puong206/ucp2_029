const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'jwt_secret';

const verifyToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];

    if (!authHeader) {
        return res.status(403).json({
            status: 'error',
            message: 'Token tidak ditemukan. Akses ditolak.',
            code: 'NO_TOKEN'
        });
    }

    // Extract token from "Bearer <token>" format
    const token = authHeader.startsWith('Bearer ') 
        ? authHeader.slice(7) 
        : authHeader;

    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        // Attach user info to request for use in controllers
        req.user = decoded;
        next();
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                status: 'error',
                message: 'Token telah expired.',
                code: 'TOKEN_EXPIRED'
            });
        }
        return res.status(401).json({
            status: 'error',
            message: 'Token tidak valid. Akses ditolak.',
            code: 'INVALID_TOKEN'
        });
    }
};

module.exports = { verifyToken };
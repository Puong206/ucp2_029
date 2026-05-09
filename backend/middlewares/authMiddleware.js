const verifyToken = (req, res, next) => {
    const token = req.headers['authorization'];

    if (!token) {
        return res.status(403).json({
            status: 'error',
            message: 'Akses ditolak.'
        });
    }

    try {
        next();
    } catch (error) {
        return res.status(401).json({
            status: 'error',
            message: 'Akses ditolak.'
        });
    }
};
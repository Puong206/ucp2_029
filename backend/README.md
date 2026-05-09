# DriveEase Backend API Documentation

Backend API untuk sistem manajemen armada "DriveEase" menggunakan Node.js, Express, dan MySQL dengan autentikasi JWT.

## 📋 Requirements

- Node.js v14+
- MySQL 5.7+
- npm atau yarn

## 🚀 Setup

1. **Clone repository dan install dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **Setup environment variables**
   ```bash
   cp .env.example .env
   # Edit .env dengan konfigurasi database Anda
   ```

3. **Setup database**
   Buat database MySQL dan import schema:
   ```sql
   CREATE DATABASE driveease_db;
   USE driveease_db;
   
   -- Users table
   CREATE TABLE users (
       id INT AUTO_INCREMENT PRIMARY KEY,
       nama VARCHAR(255) NOT NULL,
       email VARCHAR(255) UNIQUE NOT NULL,
       password VARCHAR(255) NOT NULL,
       role ENUM('admin', 'user') DEFAULT 'user',
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
   );
   
   -- Kategori table
   CREATE TABLE kategori (
       id INT AUTO_INCREMENT PRIMARY KEY,
       nama VARCHAR(255) NOT NULL,
       deskripsi TEXT,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
   );
   
   -- Katalog table
   CREATE TABLE katalog (
       id INT AUTO_INCREMENT PRIMARY KEY,
       kategori_id INT NOT NULL,
       brand VARCHAR(255) NOT NULL,
       model VARCHAR(255) NOT NULL,
       year INT,
       harga_per_hari DECIMAL(10, 2) NOT NULL,
       image_url VARCHAR(255),
       status ENUM('Tersedia', 'Tidak Tersedia', 'Maintenance') DEFAULT 'Tersedia',
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       FOREIGN KEY (kategori_id) REFERENCES kategori(id) ON DELETE CASCADE
   );
   ```

4. **Jalankan server**
   ```bash
   npm run dev    # Development mode dengan auto-reload (nodemon)
   npm start      # Production mode
   ```

Server akan berjalan di `http://localhost:3000`

---

## 🔐 Authentication & Authorization (2-Layer Security)

### Authentication (Verify User Identity)
- Dilakukan di **Login endpoint** menggunakan email dan password
- Password di-hash dengan bcryptjs (10 salt rounds)
- Setelah login berhasil, server mengeluarkan JWT token

### Authorization (Verify User Permissions)
- JWT token harus disertakan di header: `Authorization: Bearer <token>`
- Middleware `verifyToken` memverifikasi token validity dan ekstrak user info
- CRUD operations pada katalog dan kategori hanya dapat diakses user terautentikasi
- Token berlaku selama 24 jam, setelah itu user harus login ulang

---

## 📡 API Endpoints

### Base URL
```
http://localhost:3000/api
```

### 1. Authentication Routes (`/auth`)

#### Register User
```
POST /auth/register
Content-Type: application/json

{
  "nama": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "user"  // optional: "admin" or "user" (default: "user")
}

Response Success (201):
{
  "status": "success",
  "message": "Register berhasil",
  "data": {
    "id": 1,
    "nama": "John Doe",
    "email": "john@example.com",
    "role": "user"
  }
}
```

#### Login User
```
POST /auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}

Response Success (200):
{
  "status": "success",
  "message": "Login berhasil",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "data": {
    "id": 1,
    "nama": "John Doe",
    "email": "john@example.com",
    "role": "user"
  }
}
```

#### Get Current User (Protected)
```
GET /auth/me
Authorization: Bearer <token>

Response Success (200):
{
  "status": "success",
  "message": "Data user berhasil diambil",
  "data": {
    "id": 1,
    "nama": "John Doe",
    "email": "john@example.com",
    "role": "user",
    "created_at": "2024-01-15T10:30:00.000Z"
  }
}
```

#### Logout (Protected)
```
POST /auth/logout
Authorization: Bearer <token>

Response Success (200):
{
  "status": "success",
  "message": "Logout berhasil. Silakan hapus token dari client."
}
```

---

### 2. Katalog Routes (`/katalog`)

#### Get All Katalog (Public)
```
GET /katalog

Response Success (200):
{
  "status": "success",
  "message": "Data katalog berhasil diambil",
  "data": [
    {
      "id": 1,
      "kategori_id": 1,
      "brand": "Toyota",
      "model": "Avanza",
      "year": 2023,
      "harga_per_hari": 350000,
      "image_url": "https://...",
      "status": "Tersedia",
      "nama_kategori": "MPV",
      "created_at": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

#### Get Katalog by ID (Public)
```
GET /katalog/:id

Response Success (200):
{
  "status": "success",
  "message": "Data katalog berhasil diambil",
  "data": {
    "id": 1,
    "kategori_id": 1,
    "brand": "Toyota",
    "model": "Avanza",
    "year": 2023,
    "harga_per_hari": 350000,
    "image_url": "https://...",
    "status": "Tersedia",
    "nama_kategori": "MPV"
  }
}
```

#### Create Katalog (Protected - Requires Auth)
```
POST /katalog
Authorization: Bearer <token>
Content-Type: application/json

{
  "kategori_id": 1,
  "brand": "Toyota",
  "model": "Avanza",
  "year": 2023,
  "harga_per_hari": 350000,
  "image_url": "https://...",
  "status": "Tersedia"
}

Response Success (201):
{
  "status": "success",
  "message": "Data katalog berhasil ditambahkan",
  "data": {
    "id": 1,
    "kategori_id": 1,
    "brand": "Toyota",
    "model": "Avanza",
    "year": 2023,
    "harga_per_hari": 350000,
    "image_url": "https://...",
    "status": "Tersedia"
  }
}
```

#### Update Katalog (Protected - Requires Auth)
```
PUT /katalog/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "kategori_id": 1,
  "brand": "Toyota",
  "model": "Avanza",
  "year": 2023,
  "harga_per_hari": 400000,
  "image_url": "https://...",
  "status": "Maintenance"
}

Response Success (200):
{
  "status": "success",
  "message": "Data katalog berhasil diperbarui"
}
```

#### Delete Katalog (Protected - Requires Auth)
```
DELETE /katalog/:id
Authorization: Bearer <token>

Response Success (200):
{
  "status": "success",
  "message": "Data katalog berhasil dihapus"
}
```

---

### 3. Kategori Routes (`/kategori`)

#### Get All Kategori (Public)
```
GET /kategori

Response Success (200):
{
  "status": "success",
  "message": "Data kategori berhasil diambil",
  "data": [
    {
      "id": 1,
      "nama": "MPV",
      "deskripsi": "Multi Purpose Vehicle"
    }
  ]
}
```

#### Get Kategori by ID (Public)
```
GET /kategori/:id

Response Success (200):
{
  "status": "success",
  "message": "Data kategori berhasil diambil",
  "data": {
    "id": 1,
    "nama": "MPV",
    "deskripsi": "Multi Purpose Vehicle"
  }
}
```

#### Create Kategori (Protected - Requires Auth)
```
POST /kategori
Authorization: Bearer <token>
Content-Type: application/json

{
  "nama": "MPV",
  "deskripsi": "Multi Purpose Vehicle"
}

Response Success (201):
{
  "status": "success",
  "message": "Kategori berhasil dibuat",
  "data": {
    "id": 1,
    "nama": "MPV",
    "deskripsi": "Multi Purpose Vehicle"
  }
}
```

#### Update Kategori (Protected - Requires Auth)
```
PUT /kategori/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "nama": "MPV",
  "deskripsi": "Multi Purpose Vehicle Updated"
}

Response Success (200):
{
  "status": "success",
  "message": "Kategori berhasil diperbarui"
}
```

#### Delete Kategori (Protected - Requires Auth)
```
DELETE /kategori/:id
Authorization: Bearer <token>

Response Success (200):
{
  "status": "success",
  "message": "Kategori berhasil dihapus"
}
```

---

## ⚠️ Error Responses

### Common Error Codes

**400 - Bad Request**
```json
{
  "status": "error",
  "message": "Email dan password wajib diisi"
}
```

**401 - Unauthorized (Auth Failed)**
```json
{
  "status": "error",
  "message": "Email atau password salah",
  "code": "INVALID_CREDENTIALS"
}
```

**403 - Forbidden (No Token)**
```json
{
  "status": "error",
  "message": "Token tidak ditemukan. Akses ditolak.",
  "code": "NO_TOKEN"
}
```

**401 - Unauthorized (Invalid Token)**
```json
{
  "status": "error",
  "message": "Token tidak valid. Akses ditolak.",
  "code": "INVALID_TOKEN"
}
```

**401 - Unauthorized (Token Expired)**
```json
{
  "status": "error",
  "message": "Token telah expired.",
  "code": "TOKEN_EXPIRED"
}
```

**404 - Not Found**
```json
{
  "status": "error",
  "message": "Data katalog tidak ditemukan"
}
```

**500 - Server Error**
```json
{
  "status": "error",
  "message": "Terjadi kesalahan pada server"
}
```

---

## 🧪 Testing dengan Postman/cURL

### 1. Register
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nama": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

### 2. Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### 3. Get Katalog (Public)
```bash
curl -X GET http://localhost:3000/api/katalog
```

### 4. Create Katalog (Protected)
```bash
curl -X POST http://localhost:3000/api/katalog \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "kategori_id": 1,
    "brand": "Toyota",
    "model": "Avanza",
    "year": 2023,
    "harga_per_hari": 350000
  }'
```

---

## 🔒 Security Best Practices

1. **JWT Secret**: Ganti `JWT_SECRET` di `.env` dengan string yang kuat di production
2. **Password Hashing**: Semua password di-hash dengan bcryptjs sebelum disimpan
3. **Token Expiration**: JWT token berlaku 24 jam untuk mencegah misuse
4. **CORS**: Configured dengan secure headers
5. **Input Validation**: Semua input divalidasi sebelum diproses
6. **Error Handling**: Server tidak expose detail error internal ke client
7. **HTTPS**: Gunakan HTTPS di production untuk secure token transmission

---

## 📝 Project Structure

```
backend/
├── config/
│   └── db.js              # Database connection pool
├── controllers/
│   ├── authController.js  # Auth logic (login, register, logout, getMe)
│   ├── katalogController.js # CRUD katalog
│   └── kategoriController.js # CRUD kategori
├── middlewares/
│   └── authMiddleware.js  # JWT verification middleware
├── routes/
│   ├── authRoutes.js      # Auth endpoints
│   ├── katalogRoutes.js   # Katalog endpoints
│   └── kategoriRoutes.js  # Kategori endpoints
├── .env.example           # Environment variables template
├── index.js               # Server entry point
├── package.json           # Dependencies
└── README.md              # Documentation
```

---

## 🐛 Troubleshooting

**Connection to database failed**
- Pastikan MySQL server berjalan
- Cek database name dan credentials di `.env`

**JWT token invalid**
- Pastikan JWT_SECRET di `.env` sama di server
- Token harus dikirim dengan format: `Authorization: Bearer <token>`

**Cannot POST /api/katalog**
- Pastikan route sudah registered di index.js
- Cek middleware order di routes

---

Dikembangkan untuk DriveEase - Fleet Management System 🚗

# Aturan Generate Commit Message

Selalu gunakan **Bahasa Indonesia** untuk semua pesan commit yang di-generate.

## Format

```
<type>: <deskripsi singkat dalam bahasa Indonesia>
```

### Tipe yang Digunakan
- `feat:` — fitur baru atau penambahan komponen/file baru
- `refactor:` — perubahan struktur kode tanpa menambah fitur
- `fix:` — perbaikan bug
- `chore:` — perubahan konfigurasi atau dependency
- `docs:` — perubahan dokumentasi
- `style:` — perubahan tampilan yang tidak mengubah logika
- `test:` — penambahan atau perubahan test

## Aturan Deskripsi

- Awali dengan **kata kerja aktif bahasa Indonesia**:
  - `tambahkan` (penambahan file/fitur baru)
  - `perbarui` (modifikasi/pembaruan)
  - `perbaiki` (bug fix atau pembetulan)
  - `hapus` (penghapusan)
  - `ubah` (perubahan)
  - `buat` (pembuatan baru)
  - `menambah` / `membuat` (alternatif)
- Semua huruf kecil setelah tipe
- Tidak perlu titik di akhir kalimat
- Sebutkan nama file, kelas, widget, atau metode yang diubah

## Contoh Pesan Commit yang Benar

```
feat: tambahkan halaman homepage baru
feat: tambahkan widget CarCard untuk menampilkan informasi mobil
feat: menambah komponen indikator kekuatan password
feat: menambah komponen button untuk auth
feat: membuat komponen textfield auth
refactor: perbaiki implementasi KategoriBloc dengan menambahkan repository dan event handler
refactor: ubah kelas KategoriState menjadi abstract dan perbaiki implementasi kelas turunannya
refactor: tambahkan modifier const pada konstruktor kelas KategoriLoaded dan KategoriError
refactor: perbarui import untuk menggunakan flutter_bloc
fix: perbaiki pesan kesalahan pada metode getAllKatalog
```

## Catatan

- Jika banyak file berubah dalam satu area fitur, rangkum dalam satu pesan
- Hindari pesan generik seperti "update file" atau "perbaikan kecil"
- **JANGAN gunakan bahasa Inggris** dalam pesan commit

import 'package:equatable/equatable.dart';

class KatalogModel extends Equatable {
  final int id;
  final int? kategoriId;
  final String brand;
  final String model;
  final int? year;
  final double hargaPerHari;
  final String? imageUrl;
  final String status;
  final DateTime? createdAt;
  final String? namaKategori;

  /// Constructor utama untuk membuat instance KatalogModel
  const KatalogModel({
    required this.id,
    this.kategoriId,
    required this.brand,
    required this.model,
    this.year,
    required this.hargaPerHari,
    this.imageUrl,
    required this.status,
    this.createdAt,
    this.namaKategori,
  });

  /// Mengkonversi data JSON dari API menjadi object KatalogModel
  /// Menangani type conversion dan nilai null dengan aman
  factory KatalogModel.fromJson(Map<String, dynamic> json) {
    return KatalogModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      kategoriId: json['kategori_id'] is int
          ? json['kategori_id']
          : (json['kategori_id'] != null
              ? int.tryParse(json['kategori_id'].toString())
              : null),
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] is int
          ? json['year']
          : (json['year'] != null ? int.tryParse(json['year'].toString()) : null),
      hargaPerHari: json['harga_per_hari'] is num
          ? (json['harga_per_hari'] as num).toDouble()
          : double.parse(json['harga_per_hari'].toString()),
      imageUrl: json['image_url'] as String?,
      status: json['status'] ?? 'available',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      namaKategori: json['nama_kategori'] as String?,
    );
  }

  /// Mengkonversi KatalogModel ke Map JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori_id': kategoriId,
      'brand': brand,
      'model': model,
      'year': year,
      'harga_per_hari': hargaPerHari,
      'image_url': imageUrl,
      'status': status,
    };
  }

  /// Membuat copy dari KatalogModel dengan beberapa field yang diupdate
  /// Mempertahankan field lain jika tidak diubah (immutable pattern)
  KatalogModel copyWith({
    int? id,
    int? kategoriId,
    String? brand,
    String? model,
    int? year,
    double? hargaPerHari,
    String? imageUrl,
    String? status,
    DateTime? createdAt,
    String? namaKategori,
  }) {
    return KatalogModel(
      id: id ?? this.id,
      kategoriId: kategoriId ?? this.kategoriId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      hargaPerHari: hargaPerHari ?? this.hargaPerHari,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      namaKategori: namaKategori ?? this.namaKategori,
    );
  }

  /// Mendefinisikan field yang digunakan untuk perbandingan equality
  /// Diperlukan karena extends Equatable
  @override
  List<Object?> get props => [
        id,
        kategoriId,
        brand,
        model,
        year,
        hargaPerHari,
        imageUrl,
        status,
        createdAt,
        namaKategori
      ];
}
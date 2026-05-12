import 'package:equatable/equatable.dart';

class KatalogModel extends Equatable {
  final int id;
  final int? kategoriId;
  final String brand;
  final String model;
  final int year;
  final String transmisi;
  final int kapasitas;
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
    required this.year,
    required this.transmisi,
    required this.kapasitas,
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
          : int.parse(json['year'].toString()),
      transmisi: json['transmisi'] ?? '',
      kapasitas: json['kapasitas'] is int
          ? json['kapasitas']
          : int.parse(json['kapasitas'].toString()),
      imageUrl: json['image_url'] as String?,
      status: json['status'] ?? 'tersedia',
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
      'transmisi': transmisi,
      'kapasitas': kapasitas,
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
    String? transmisi,
    int? kapasitas,
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
      transmisi: transmisi ?? this.transmisi,
      kapasitas: kapasitas ?? this.kapasitas,
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
        transmisi,
        kapasitas,
        imageUrl,
        status,
        createdAt,
        namaKategori,
      ];
}
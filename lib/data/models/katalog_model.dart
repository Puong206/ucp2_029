class KatalogModel {
  final int id;
  final int kategoriId;
  final String brand;
  final String model;
  final int year;
  final int harga_per_hari;
  final String imageUrl;
  final String status;
  final DateTime? createdAt;

  KatalogModel({
    required this.id,
    required this.kategoriId,
    required this.brand,
    required this.model,
    required this.year,
    required this.harga_per_hari,
    required this.imageUrl,
    required this.status,
    this.createdAt,
  });

  factory KatalogModel.fromJson(Map<String, dynamic> json) {
    return KatalogModel(
      id: json['id'] as int,
      kategoriId: json['kategori_id'] as int,
      brand: json['brand'] as String? ?? 'Tanpa Brand',
      model: json['model'] as String? ?? 'Tanpa Model',
      year: json['year'] as int? ?? 0,
      harga_per_hari: json['harga_per_hari'] as int? ?? 0,
      imageUrl: json['image_url'] as String? ?? 'Gambar tidak tersedia',
      status: json['status'] as String? ?? 'Tidak ada status',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
class KatalogModel {
  final int id;
  final int kategoriId;
  final String brand;
  final String model;
  final int year;
  final String harga_per_hari;
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
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      kategoriId: json['kategori_id'] is int ? json['kategori_id'] : int.parse(json['kategori_id'].toString()),
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] is int ? json['year'] : int.parse(json['year'].toString()),
      harga_per_hari: json['harga_per_hari'] ?? '',
      imageUrl: json['image_url'] ?? '',
      status: json['status'] ?? 'available',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
    );
  }
}
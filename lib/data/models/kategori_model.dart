import 'package:equatable/equatable.dart';

class KategoriModel extends Equatable {
  final int id;
  final String nama;
  final String? deskripsi;
  final DateTime? createdAt;

  const KategoriModel({
    required this.id,
    required this.nama,
    this.deskripsi,
    this.createdAt,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
    };
  }

  KategoriModel copyWith({
    int? id,
    String? nama,
    String? deskripsi,
    DateTime? createdAt,
  }) {
    return KategoriModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, nama, deskripsi, createdAt];
}
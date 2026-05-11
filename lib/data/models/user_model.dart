import 'package:equatable/equatable.dart';

class Usermodel extends Equatable {
  final int id;
  final String nama;
  final String email;
  final String? password;
  final String role;
  final DateTime? createdAt;

  const Usermodel({
    required this.id,
    required this.nama,
    required this.email,
    this.password,
    this.role = 'user',
    this.createdAt,
  });

  // Factory method untuk convert dari JSON response (dari backend API)
  factory Usermodel.fromJson(Map<String, dynamic> json) {
    return Usermodel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      role: json['role'] ?? 'user',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
    );
  }

  // Method untuk convert ke JSON (untuk mengirim ke backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Copy with method untuk membuat instance baru dengan beberapa field yang diubah
  Usermodel copyWith({
    int? id,
    String? nama,
    String? email,
    String? password,
    String? role,
    DateTime? createdAt,
  }) {
    return Usermodel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, nama, email, password, role, createdAt];
}
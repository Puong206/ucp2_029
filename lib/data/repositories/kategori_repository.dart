import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ucp2/data/models/kategori_model.dart';
import 'package:ucp2/data/providers/storage_provider.dart';

class KategoriRepository {
  final String baseUrl = 'http://10.0.2.2:3000/api';
  final StorageProvider storage = StorageProvider();

  Future<List<KategoriModel>> getAllKategori() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/kategori'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KategoriModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat kategori: ${response.statusCode}');
    }
  }

  Future<void> createKategori(Map<String, dynamic> data) async {
    final token = await storage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/kategori'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal membuat kategori: ${response.statusCode}';
    }
  }

  Future<void> updateKategori(int id, Map<String, dynamic> data) async {
    final token = await storage.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/kategori/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal memperbarui kategori: ${response.statusCode}';
    }
  }

  Future<void> deleteKategori(int id) async {
    final token = await storage.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/kategori/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menghapus kategori: ${response.statusCode}';
    }
  }
}
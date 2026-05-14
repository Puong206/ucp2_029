import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucp2/data/models/katalog_model.dart';
import '../providers/storage_provider.dart';

class KatalogRepository {
  final String _baseUrl = "http://10.0.2.2:3000/api";
  final StorageProvider storage = StorageProvider();

  Future<List<KatalogModel>> getAllKatalog() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/katalog'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KatalogModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat katalog: ${response.statusCode}');
    }
  }

  Future<void> createKatalog(Map<String, dynamic> data) async {
    final token = await storage.getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/katalog'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal membuat katalog: ${response.statusCode}';
    }
  }

  Future<void> updateKatalog(int id, Map<String, dynamic> data) async {
    final token = await storage.getToken();

    final response = await http.put(
      Uri.parse('$_baseUrl/katalog/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal mengupdate katalog: ${response.statusCode}';
    }
  }

  Future<void> deleteKatalog(int id) async {
    final token = await storage.getToken();

    final response = await http.delete(
      Uri.parse('$_baseUrl/katalog/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menghapus katalog: ${response.statusCode}';
    }
  }
}
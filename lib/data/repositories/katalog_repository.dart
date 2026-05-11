import 'dart:convert';

import 'package:http/http.dart' as http;

import '../providers/storage_provider.dart';

class KatalogRepository {
  final String _baseUrl = "http://localhost:3000/api";
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
      throw Exception('Gagal memuat katalog: ${response.statusCode} - ${response.body}');
    }
  }
}
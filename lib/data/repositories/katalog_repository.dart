import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import '../providers/storage_provider.dart';

class KatalogRepository {
  final String _baseUrl = "http://10.0.2.2:3000/api";
  final String _baseServerUrl = "http://10.0.2.2:3000";
  final StorageProvider storage = StorageProvider();

  /// Resolve image URL — jika relative path (dari upload), prepend server URL
  String resolveImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    return '$_baseServerUrl$imageUrl';
  }

  Future<List<KatalogModel>> getAllKatalog() async {
    final token = await storage.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/katalog'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Request timeout - Backend tidak merespons');
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KatalogModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat katalog: ${response.statusCode}');
    }
  }

  /// Create katalog — gunakan multipart jika ada gambar, JSON jika tidak
  Future<void> createKatalog(Map<String, dynamic> data,
      {String? imagePath}) async {
    final token = await storage.getToken();

    if (imagePath != null) {
      await _multipartRequest(
        method: 'POST',
        url: '$_baseUrl/katalog',
        token: token!,
        fields: data,
        imagePath: imagePath,
        expectedCodes: [200, 201],
        errorMessage: 'Gagal membuat katalog',
      );
    } else {
      final response = await http.post(
        Uri.parse('$_baseUrl/katalog'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Backend tidak merespons');
        },
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw body['message'] ?? 'Gagal membuat katalog: ${response.statusCode}';
      }
    }
  }

  /// Update katalog — gunakan multipart jika ada gambar baru, JSON jika tidak
  Future<void> updateKatalog(int id, Map<String, dynamic> data,
      {String? imagePath}) async {
    final token = await storage.getToken();

    if (imagePath != null) {
      await _multipartRequest(
        method: 'PUT',
        url: '$_baseUrl/katalog/$id',
        token: token!,
        fields: data,
        imagePath: imagePath,
        expectedCodes: [200],
        errorMessage: 'Gagal mengupdate katalog',
      );
    } else {
      final response = await http.put(
        Uri.parse('$_baseUrl/katalog/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Backend tidak merespons');
        },
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw body['message'] ??
            'Gagal mengupdate katalog: ${response.statusCode}';
      }
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
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Request timeout - Backend tidak merespons');
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal menghapus katalog: ${response.statusCode}';
    }
  }

  /// Helper internal — kirim multipart request (POST atau PUT)
  Future<void> _multipartRequest({
    required String method,
    required String url,
    required String token,
    required Map<String, dynamic> fields,
    required String imagePath,
    required List<int> expectedCodes,
    required String errorMessage,
  }) async {
    final uri = Uri.parse(url);
    final request = http.MultipartRequest(method, uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // Tambahkan semua field teks
    fields.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    // Tambahkan file gambar
    final mimeType = lookupMimeType(imagePath) ?? 'image/jpeg';
    final mimeParts = mimeType.split('/');
    final multipartFile = await http.MultipartFile.fromPath(
      'image', // nama field yang diharapkan backend (multer)
      imagePath,
      contentType: http.MediaType(mimeParts[0], mimeParts[1]),
    );
    request.files.add(multipartFile);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (!expectedCodes.contains(response.statusCode)) {
      try {
        final body = jsonDecode(response.body);
        throw body['message'] ?? '$errorMessage: ${response.statusCode}';
      } catch (_) {
        throw '$errorMessage: ${response.statusCode}';
      }
    }
  }
}
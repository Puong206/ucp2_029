import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:ucp2/data/models/user_model.dart';
import 'package:ucp2/data/providers/storage_provider.dart';

class AuthRepository {
  final String baseUrl = "http://";
  final StorageProvider _storage = StorageProvider();

  Future<void> persistToken(String token) async {
    await _storage.saveToken(token);
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<void> deleteToken() async {
    await _storage.deleteToken();
  }

  Future<Usermodel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      developer.log('Login Response: ${response.body}', name: 'API');

      if (response.statusCode == 200) {
        await persistToken(data['token']);
        return Usermodel.fromJson(data['user']);
      } else {
        throw data['message'] ?? 'Gagal Login!';
      }

    } catch (e) {
      developer.log('Login Error: $e', name: 'API');
      rethrow;
    }
  }

  Future<void> register(
    String nama,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal Register!';
    }
  }
}
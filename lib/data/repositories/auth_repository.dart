import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:ucp2/data/models/user_model.dart';
import 'package:ucp2/data/providers/storage_provider.dart';
  
class AuthRepository {
  // Match dengan backend di http://10.0.2.2:3000/api (10.0.2.2 untuk Android emulator)
  final String baseUrl = "http://10.12.201.116:3000/api";
  final StorageProvider _storage = StorageProvider();

  // ============ Token Management ============

  /// Simpan JWT token ke local storage
  Future<void> persistToken(String token) async {
    await _storage.saveToken(token);
  }

  /// Ambil JWT token dari local storage
  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  /// Hapus JWT token dari local storage
  Future<void> deleteToken() async {
    await _storage.deleteToken();
  }

  /// Generate Authorization header dengan Bearer token
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ============ Authentication Endpoints ============

  /// Login dengan email dan password
  /// Return: Usermodel jika berhasil
  /// Throw: String message jika error
  Future<Usermodel> login(String email, String password) async {
    try {
      developer.log('Login attempt: $email', name: 'AUTH');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Backend tidak merespons');
        },
      );

      developer.log('Login Response: ${response.statusCode} - ${response.body}',
          name: 'AUTH');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse response sesuai backend format:
        // { status: 'success', message: '...', token: '...', data: { user } }
        final token = data['token'] as String?;
        if (token == null) {
          throw 'Token tidak ditemukan di response';
        }

        // Simpan token
        await persistToken(token);

        // Parse user dari data field
        return Usermodel.fromJson(data['data']);
      } else {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Email atau password salah';
      }
    } catch (e) {
      developer.log('Login Error: $e', name: 'AUTH', error: e);
      rethrow;
    }
  }

  /// Register user baru
  /// Return: void
  /// Throw: String message jika error
  Future<void> register(
    String nama,
    String email,
    String password,
  ) async {
    try {
      developer.log('Register attempt: $email', name: 'AUTH');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
        }),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Backend tidak merespons');
        },
      );

      developer.log(
          'Register Response: ${response.statusCode} - ${response.body}',
          name: 'AUTH');

      if (response.statusCode != 201 && response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal Register!';
      }
    } catch (e) {
      developer.log('Register Error: $e', name: 'AUTH', error: e);
      rethrow;
    }
  }

  /// Get current logged in user info
  /// Requires: Valid JWT token
  /// Return: Usermodel
  /// Throw: String message jika error
  Future<Usermodel> getMe() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: headers,
      );

      developer.log('GetMe Response: ${response.statusCode} - ${response.body}',
          name: 'AUTH');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Usermodel.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        await deleteToken();
        throw 'Token tidak valid. Silakan login kembali.';
      } else {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal mengambil data user';
      }
    } catch (e) {
      developer.log('GetMe Error: $e', name: 'AUTH', error: e);
      rethrow;
    }
  }

  /// Logout user
  /// Requires: Valid JWT token
  /// Return: void
  /// Throw: String message jika error
  Future<void> logout() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: headers,
      );

      developer.log('Logout Response: ${response.statusCode}', name: 'AUTH');

      // Hapus token dari storage regardless of response
      await deleteToken();

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal Logout!';
      }
    } catch (e) {
      developer.log('Logout Error: $e', name: 'AUTH', error: e);
      // Tetap hapus token meski ada error
      await deleteToken();
      rethrow;
    }
  }

  /// Check if user is authenticated (token exists)
  /// Return: bool
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Error dari API. Pesan aslinya (mis. "Email atau password salah") ikut
// dibawa supaya bisa ditampilkan apa adanya di form.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/api';
  static const String _tokenKey = 'token';

  // Klien HTTP untuk semua permintaan. Bisa diganti di test supaya alur
  // layar (mis. login) tidak perlu menembak server sungguhan.
  static http.Client client = http.Client();

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return body;
    }
    final message = body is Map
        ? body['message']
        : null;
    throw ApiException(
      message?.toString() ?? 'Terjadi kesalahan',
      statusCode: response.statusCode,
    );
  }

  static Future<dynamic> get(String endpoint) async {
    final response = await client.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await client.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await client.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> delete(String endpoint) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }
}
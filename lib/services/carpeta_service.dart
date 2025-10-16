import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/carpeta.dart';

class CarpetaService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    // Si usas cookies/session en vez de token, ajusta esto.
  }

  Future<List<Carpeta>> getCarpetas() async {
    final url = Uri.parse('$_baseUrl/casos/carpetas/');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List body = jsonDecode(response.body);
        return body.map((e) => Carpeta.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load carpetas');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or retrieve carpetas');
    }
  }

  Future<Carpeta?> createCarpeta(Carpeta carpeta) async {
    final url = Uri.parse('$_baseUrl/casos/carpetas/');
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(carpeta.toJson()),
      );
      if (response.statusCode == 201) {
        return Carpeta.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create carpeta');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or create carpeta');
    }
  }

  Future<Carpeta?> updateCarpeta(Carpeta carpeta) async {
    final url = Uri.parse('$_baseUrl/casos/carpetas/${carpeta.id}/');
    try {
      final response = await http.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(carpeta.toJson()),
      );
      if (response.statusCode == 200) {
        return Carpeta.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update carpeta');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or update carpeta');
    }
  }

  Future<void> deleteCarpeta(int carpetaId) async {
    final url = Uri.parse('$_baseUrl/casos/carpetas/$carpetaId/');
    try {
      final response = await http.delete(url, headers: await _getHeaders());
      if (response.statusCode != 204) {
        throw Exception('Failed to delete carpeta');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or delete carpeta');
    }
  }
}

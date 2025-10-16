import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/caso.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CasoService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<List<Caso>> getCasos() async {
    final url = Uri.parse('$_baseUrl/casos/casos/');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Caso.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load casos');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or retrieve casos');
    }
  }

  Future<Caso?> createCaso(Caso caso) async {
    final url = Uri.parse('$_baseUrl/casos/casos/'); // CORREGIDO: agregado /casos/casos/
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(caso.toJson()),
      );
      if (response.statusCode == 201) {
        return Caso.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create caso');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or create caso');
    }
  }

  Future<Caso?> updateCaso(Caso caso) async {
    final url = Uri.parse('$_baseUrl/casos/casos/${caso.id}/'); // CORREGIDO: agregado /casos/casos/
    try {
      final response = await http.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(caso.toJson()),
      );
      if (response.statusCode == 200) {
        return Caso.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update caso');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or update caso');
    }
  }

  Future<void> deleteCaso(int casoId) async {
    final url = Uri.parse('$_baseUrl/casos/casos/$casoId/'); // CORREGIDO: agregado /casos/casos/
    try {
      final response = await http.delete(
        url,
        headers: await _getHeaders(),
      );
      if (response.statusCode != 204) {
        throw Exception('Failed to delete caso');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or delete caso');
    }
  }
}
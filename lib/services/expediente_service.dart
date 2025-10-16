import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/expediente.dart';

class ExpedienteService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<List<Expediente>> getExpedientes() async {
    final url = Uri.parse('$_baseUrl/casos/expedientes/');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List body = jsonDecode(response.body);
        return body.map((e) => Expediente.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load expedientes');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or retrieve expedientes');
    }
  }

  Future<Expediente?> createExpediente(Expediente expediente) async {
    final url = Uri.parse('$_baseUrl/casos/expedientes/');
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(expediente.toJson()),
      );
      if (response.statusCode == 201) {
        return Expediente.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create expediente');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or create expediente');
    }
  }

  Future<Expediente?> updateExpediente(Expediente expediente) async {
    final url = Uri.parse('$_baseUrl/casos/expedientes/${expediente.id}/');
    try {
      final response = await http.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(expediente.toJson()),
      );
      if (response.statusCode == 200) {
        return Expediente.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update expediente');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or update expediente');
    }
  }

  Future<void> deleteExpediente(int expedienteId) async {
    final url = Uri.parse('$_baseUrl/casos/expedientes/$expedienteId/');
    try {
      final response = await http.delete(url, headers: await _getHeaders());
      if (response.statusCode != 204) {
        throw Exception('Failed to delete expediente');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or delete expediente');
    }
  }
}

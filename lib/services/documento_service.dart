import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/documento.dart';

class DocumentoService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Documento>> getDocumentos() async {
    final url = Uri.parse('$_baseUrl/documentos/documentos/');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List body = jsonDecode(response.body);
        return body.map((e) => Documento.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load documentos');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or retrieve documentos');
    }
  }

  Future<Documento?> createDocumento(Documento documento) async {
    final url = Uri.parse('$_baseUrl/documentos/documentos/');
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(documento.toJson()),
      );
      if (response.statusCode == 201) {
        return Documento.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create documento');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or create documento');
    }
  }

  Future<Documento?> updateDocumento(Documento documento) async {
    final url = Uri.parse('$_baseUrl/documentos/documentos/${documento.id}/');
    try {
      final response = await http.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(documento.toJson()),
      );
      if (response.statusCode == 200) {
        return Documento.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update documento');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or update documento');
    }
  }

  Future<void> deleteDocumento(int documentoId) async {
    final url = Uri.parse('$_baseUrl/documentos/documentos/$documentoId/');
    try {
      final response = await http.delete(url, headers: await _getHeaders());
      if (response.statusCode != 204) {
        throw Exception('Failed to delete documento');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or delete documento');
    }
  }
}

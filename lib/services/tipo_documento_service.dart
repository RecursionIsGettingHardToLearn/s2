import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/tipo_documento.dart';

class TipoDocumentoService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<TipoDocumento>> getTipoDocumentos() async {
    final url = Uri.parse('$_baseUrl/documentos/tipos_documentos/');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List body = jsonDecode(response.body);
        return body.map((e) => TipoDocumento.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load tipos de documento');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or retrieve tipos de documento');
    }
  }

  Future<TipoDocumento?> createTipoDocumento(TipoDocumento tipoDocumento) async {
    final url = Uri.parse('$_baseUrl/documentos/tipos_documentos/');
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(tipoDocumento.toJson()),
      );
      if (response.statusCode == 201) {
        return TipoDocumento.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create tipo de documento');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or create tipo de documento');
    }
  }

  Future<TipoDocumento?> updateTipoDocumento(TipoDocumento tipoDocumento) async {
    final url = Uri.parse('$_baseUrl/documentos/tipos_documentos/${tipoDocumento.id}/');
    try {
      final response = await http.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(tipoDocumento.toJson()),
      );
      if (response.statusCode == 200) {
        return TipoDocumento.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update tipo de documento');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or update tipo de documento');
    }
  }

  Future<void> deleteTipoDocumento(int tipoDocumentoId) async {
    final url = Uri.parse('$_baseUrl/documentos/tipos_documentos/$tipoDocumentoId/');
    try {
      final response = await http.delete(url, headers: await _getHeaders());
      if (response.statusCode != 204) {
        throw Exception('Failed to delete tipo de documento');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or delete tipo de documento');
    }
  }
}

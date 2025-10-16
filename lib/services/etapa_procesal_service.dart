import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/etapa_procesal.dart';

class EtapaProcesalService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
  }

  // Obtener todas las Etapas Procesales
  Future<List<EtapaProcesal>> getEtapasProcesales() async {
    final url = Uri.parse('$_baseUrl/documentos/etapas_procesales/');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List body = jsonDecode(response.body);
        return body.map((e) => EtapaProcesal.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load etapas procesales');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or retrieve etapas procesales');
    }
  }

  // Crear una nueva Etapa Procesal
  Future<EtapaProcesal?> createEtapaProcesal(EtapaProcesal etapaProcesal) async {
    final url = Uri.parse('$_baseUrl/documentos/etapas_procesales/');
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(etapaProcesal.toJson()),
      );
      if (response.statusCode == 201) {
        return EtapaProcesal.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create etapa procesal');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or create etapa procesal');
    }
  }

  // Actualizar una Etapa Procesal existente
  Future<EtapaProcesal?> updateEtapaProcesal(EtapaProcesal etapaProcesal) async {
    final url = Uri.parse('$_baseUrl/documentos/etapas_procesales/${etapaProcesal.id}/');
    try {
      final response = await http.put(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(etapaProcesal.toJson()),
      );
      if (response.statusCode == 200) {
        return EtapaProcesal.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update etapa procesal');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or update etapa procesal');
    }
  }

  // Eliminar una Etapa Procesal
  Future<void> deleteEtapaProcesal(int etapaProcesalId) async {
    final url = Uri.parse('$_baseUrl/documentos/etapas_procesales/$etapaProcesalId/');
    try {
      final response = await http.delete(url, headers: await _getHeaders());
      if (response.statusCode != 204) {
        throw Exception('Failed to delete etapa procesal');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or delete etapa procesal');
    }
  }
}

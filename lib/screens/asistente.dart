// lib/screens/inquilino.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/app_drawer.dart';
import '../main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv
class AsistenteHomePage extends StatefulWidget {
  const AsistenteHomePage({super.key});

  @override
  State<AsistenteHomePage> createState() => _AsistenteHomePageState();
}

class _AsistenteHomePageState extends State<AsistenteHomePage> {
  String _username = '';
  String _userRole = 'ASI';

  @override
  void initState() {
    super.initState();
    _loadUserDataAndRole();
  }

  Future<void> _loadUserDataAndRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('user_role') ?? 'ASI';
      _username = prefs.getString('username') ?? 'Asistente Usuario';
    });
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refresh_token');
    final String? accessToken = prefs.getString('access_token');

    if (refreshToken == null) {
      print('No refresh token available for logout from AsistenteHomePage.');
    } else {
      final String baseUrl = dotenv.env['API_BASE_URL']!;
      final String logoutUrl = '${baseUrl}seguridad/logout/';

      try {
        final response = await http.post(
          Uri.parse(logoutUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(<String, String>{
            'refresh': refreshToken,
          }),
        );

        if (response.statusCode == 200) {
          print('Logout successful from AsistenteHomePage.');
        } else {
          print('Error during backend logout: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('Exception during logout from AsistenteHomePage: $e');
      }
    }

    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    await prefs.remove('user_role');
    await prefs.remove('username');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen(onLoginSuccess: _onLoginSuccessPlaceholder)),
      (Route<dynamic> route) => false,
    );
  }

  static void _onLoginSuccessPlaceholder() {
    // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Asistente'),
      ),
      drawer: AppDrawer(
        userRole: _userRole,
        username: _username,
        onLogout: _handleLogout,
      ),
      body: Center(
        child: Text('Contenido específico para el Dashboard del Asistente. ¡Bienvenido, $_username!'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_drawer.dart';
import 'dart:convert'; // For jsonEncode
import 'package:http/http.dart' as http; // For http requests
import '../main.dart'; // Import the new LoginScreen
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
class AbogadoHomePage extends StatefulWidget {
  const AbogadoHomePage({super.key});

  @override
  State<AbogadoHomePage> createState() => _AbogadoHomePageState();
}

class _AbogadoHomePageState extends State<AbogadoHomePage> {
  String _username = '';
  String _userRole = 'ABO';

  @override
  void initState() {
    super.initState();
    _loadUserDataAndRole();
  }

  Future<void> _loadUserDataAndRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('user_role') ?? 'ABO';
      _username = prefs.getString('username') ?? 'Abogado Usuario';
    });
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refresh_token');
    final String? accessToken = prefs.getString('access_token');

    if (refreshToken == null) {
      print('No refresh token available for logout from AbogadoHomePage.');
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
          print('Logout successful from AbogadoHomePage.');
        } else {
          print('Error during backend logout: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('Exception during logout from AbogadoHomePage: $e');
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
        title: const Text('Dashboard Abogado'),
      ),
      drawer: AppDrawer(
        userRole: _userRole,
        username: _username,
        onLogout: _handleLogout,
      ),
      body: Center(
        child: Text('Contenido específico para el Dashboard del Abogado. ¡Bienvenido, $_username!'),
      ),
    );
  }
}

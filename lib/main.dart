import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/asistente.dart';
import 'screens/abogado.dart';
import 'screens/cliente.dart';
import '../routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación con Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
      routes: {
        //asistent
        AppRoutes.clienteDashboard: (context) => const AsistenteHomePage(),


        // abogado routes
        AppRoutes.abogadoDashboard: (context) => const AbogadoHomePage(),
        

        // cliente routes
        AppRoutes.asistenteDashboard: (context) => const ClienteHomePage(),
       

       
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  
  if (accessToken != null && accessToken.isNotEmpty) {
    String? userRole = await _fetchUserRole(accessToken); // Obtenemos el rol desde el backend

    if (userRole != null) {
      // Guardamos el rol en las preferencias compartidas para futuras referencias
      await prefs.setString('user_role', userRole);

      setState(() {
        _isLoggedIn = true;
        _userRole = userRole; // Actualizamos el rol del usuario
        _isLoading = false;
      });
    } else {
      // Si no se pudo obtener el rol, mostramos el login
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  } else {
    setState(() {
      _isLoggedIn = false;
      _isLoading = false;
    });
  }
}
Future<String?> _fetchUserRole(String accessToken) async {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final String meUrl = '${baseUrl}seguridad/usuarios/me/'; // Endpoint de usuario autenticado
  try {
    final response = await http.get(
      Uri.parse(meUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken', // Token de autenticación
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      return userData['actor']['tipoActor'];  // Extraemos el tipo de actor (ABO, CLI, ASI)
    } else {
      print('Error al obtener los datos del usuario: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error al obtener los datos del usuario: $e');
    return null;
  }
}


  void _onLoginSuccess() {
    _checkLoginStatus();
  }

  Widget _getHomePageForRole(String role) {
  switch (role) {
    case 'ABO':  // Abogado
      return const AbogadoHomePage();
    case 'CLI':  // Cliente
      return const ClienteHomePage();
    case 'ASI':  // Asistente
      return const AsistenteHomePage();
    default:
      return Scaffold(
        appBar: AppBar(title: const Text('Error de Rol')),
        body: const Center(child: Text('Rol de usuario desconocido o no asignado.')),
      );
  }
}


@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  } else {
    if (_isLoggedIn && _userRole != null) {
      return _getHomePageForRole(_userRole!);  // Redirige según el rol
    } else {
      return LoginScreen(onLoginSuccess: _onLoginSuccess);  // Si no está logueado, mostramos la pantalla de login
    }
  }
}

}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String baseUrl = dotenv.env['API_BASE_URL']!;
    final String loginUrl = '${baseUrl}seguridad/login/';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String accessToken = data['access'];
        final String refreshToken = data['refresh'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        final int? fetchedUserId = await _fetchUserId(accessToken);
        final String? fetchedUserRole = await _fetchUserRole(accessToken);

        if (fetchedUserId != null && fetchedUserRole != null) {
          await prefs.setInt('user_id', fetchedUserId);
          await prefs.setString('username', username);
          await prefs.setString('user_role', fetchedUserRole);

          print('Login exitoso. Access Token: $accessToken');
          print('Refresh Token: $refreshToken');
          print('User ID: $fetchedUserId');
          print('User Role: $fetchedUserRole');

          widget.onLoginSuccess();
        } else {
          setState(() {
            _errorMessage = 'Error: No se pudo obtener el ID o rol de usuario.';
          });
          print('Error: No se pudo obtener el ID o rol de usuario después del login.');
          await prefs.remove('access_token');
          await prefs.remove('refresh_token');
          await prefs.remove('user_id');
          await prefs.remove('user_role');
          await prefs.remove('username');
        }
      } else {
        setState(() {
          _errorMessage = 'Credenciales incorrectas o error en el servidor.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Verifica tu red.';
      });
      print('Error en login: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _fetchUserRole(String accessToken) async {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final String meUrl = '${baseUrl}seguridad/usuarios/me/'; // Endpoint de usuario autenticado
  try {
    final response = await http.get(
      Uri.parse(meUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken', // Token de autenticación
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);

      // Agregar un print para ver toda la respuesta y verificar su estructura
      print('Respuesta del servidor: $userData');

      // Asegúrate de que los datos están bien estructurados
      if (userData.containsKey('actor') && userData['actor'] != null) {
        final actor = userData['actor'];
        if (actor.containsKey('tipoActor')) {
          return actor['tipoActor'];  // Extraemos el tipo de actor (ABO, CLI, ASI)
        } else {
          print('Error: No se encontró el campo "tipoActor"');
          return null;
        }
      } else {
        print('Error: No se encontró el campo "actor" en la respuesta');
        return null;
      }
    } else {
      print('Error al obtener los datos del usuario: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error al obtener los datos del usuario: $e');
    return null;
  }
}


  Future<int?> _fetchUserId(String accessToken) async {
    final String baseUrl = dotenv.env['API_BASE_URL']!;
    final String meUrl = '${baseUrl}seguridad/usuarios/me/';
    try {
      final response = await http.get(
        Uri.parse(meUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return userData['id'] as int?;
      } else {
        print('Error al obtener datos de /usuarios/me: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Excepción al obtener datos de /usuarios/me: $e');
      return null;
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Bienvenido', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
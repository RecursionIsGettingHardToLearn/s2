import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../menuItems.dart'; // Tu archivo de configuración de menú

class AppDrawer extends StatefulWidget {
  final String userRole;
  final String username; // Nuevo: para mostrar el nombre de usuario
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.userRole,
    required this.username, // Requiere el nombre de usuario
    required this.onLogout,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> _handleSignOut() async {
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menuItems = menuItemsByRole[widget.userRole] ?? [];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader( // Usa UserAccountsDrawerHeader para una mejor presentación
            accountName: Text('', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            accountEmail: Text('Rol: ${widget.userRole}', style: const TextStyle(color: Colors.white70)),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ...menuItems.map((item) {
            if (item.subItems != null && item.subItems!.isNotEmpty) {
              return ExpansionTile(
                leading: item.icon != null ? FaIcon(item.icon!) : null,
                title: Text(item.title),
                children: item.subItems!.map((subItem) {
                  return ListTile(
                    leading: subItem.icon != null ? FaIcon(subItem.icon!, size: 20) : null,
                    title: Text(subItem.title),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                      if (subItem.action == 'signout') {
                        _handleSignOut();
                      } else if (subItem.to != null) {
                        Navigator.pushNamed(context, subItem.to!);
                      }
                    },
                  );
                }).toList(),
              );
            } else {
              return ListTile(
                leading: item.icon != null ? FaIcon(item.icon!) : null,
                title: Text(item.title),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  if (item.action == 'signout') {
                    _handleSignOut();
                  } else if (item.to != null) {
                    Navigator.pushNamed(context, item.to!);
                  }
                },
              );
            }
          }).toList(), // Mantener toList() aquí si se usa spread operator en ListView children
        ],
      ),
    );
  }
}
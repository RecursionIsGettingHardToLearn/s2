import 'package:flutter/material.dart';
import '../../models/carpeta.dart';
import '../../services/carpeta_service.dart';
import 'carpeta_form_screen.dart';

class CarpetaListScreen extends StatefulWidget {
  const CarpetaListScreen({super.key});

  @override
  State<CarpetaListScreen> createState() => _CarpetaListScreenState();
}

class _CarpetaListScreenState extends State<CarpetaListScreen> {
  late Future<List<Carpeta>> _future;
  final _service = CarpetaService();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    setState(() {
      _future = _service.getCarpetas();
    });
  }

  Future<void> _delete(int id) async {
    await _service.deleteCarpeta(id);
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carpetas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarpetaFormScreen()),
              ).then((_) => _fetch());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Carpeta>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay carpetas.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final c = data[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 3,
                child: ListTile(
                  title: Text(c.nombre),
                  subtitle: Text(
                    'Expediente: ${c.expediente}'
                    '${c.carpetaPadre != null ? ' • Padre: ${c.carpetaPadre}' : ''}'
                    ' • Estado: ${c.estado}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _delete(c.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CarpetaFormScreen(carpeta: c),
                            ),
                          ).then((_) => _fetch());
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/tipo_documento.dart';
import '../../services/tipo_documento_service.dart';
import 'tipo_documento_form_screen.dart';

class TipoDocumentoListScreen extends StatefulWidget {
  const TipoDocumentoListScreen({super.key});

  @override
  State<TipoDocumentoListScreen> createState() => _TipoDocumentoListScreenState();
}

class _TipoDocumentoListScreenState extends State<TipoDocumentoListScreen> {
  late Future<List<TipoDocumento>> _tipoDocumentosFuture;
  final TipoDocumentoService _tipoDocumentoService = TipoDocumentoService();

  @override
  void initState() {
    super.initState();
    _fetchTipoDocumentos();
  }

  void _fetchTipoDocumentos() {
    setState(() {
      _tipoDocumentosFuture = _tipoDocumentoService.getTipoDocumentos();
    });
  }

  Future<void> _deleteTipoDocumento(int id) async {
    await _tipoDocumentoService.deleteTipoDocumento(id);
    _fetchTipoDocumentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Documento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TipoDocumentoFormScreen()),
              ).then((_) => _fetchTipoDocumentos());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TipoDocumento>>(
        future: _tipoDocumentosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay tipos de documento.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final tipoDocumento = data[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 3,
                child: ListTile(
                  title: Text(tipoDocumento.nombre),
                  subtitle: Text('Activo: ${tipoDocumento.activo}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTipoDocumento(tipoDocumento.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TipoDocumentoFormScreen(tipoDocumento: tipoDocumento),
                            ),
                          ).then((_) => _fetchTipoDocumentos());
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

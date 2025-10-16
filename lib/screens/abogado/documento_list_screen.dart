import 'package:flutter/material.dart';
import '../../models/documento.dart';
import '../../services/documento_service.dart';
import 'documento_form_screen.dart';

class DocumentoListScreen extends StatefulWidget {
  const DocumentoListScreen({super.key});

  @override
  State<DocumentoListScreen> createState() => _DocumentoListScreenState();
}

class _DocumentoListScreenState extends State<DocumentoListScreen> {
  late Future<List<Documento>> _documentosFuture;
  final DocumentoService _documentoService = DocumentoService();

  @override
  void initState() {
    super.initState();
    _fetchDocumentos();
  }

  void _fetchDocumentos() {
    setState(() {
      _documentosFuture = _documentoService.getDocumentos();
    });
  }

  Future<void> _deleteDocumento(int id) async {
    await _documentoService.deleteDocumento(id);
    _fetchDocumentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DocumentoFormScreen()),
              ).then((_) => _fetchDocumentos());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Documento>>(
        future: _documentosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay documentos.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final documento = data[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 3,
                child: ListTile(
                  title: Text(documento.nombreDocumento),
                  subtitle: Text('Tipo: ${documento.tipoDocumento} • Estado: ${documento.estado}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteDocumento(documento.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DocumentoFormScreen(documento: documento),
                            ),
                          ).then((_) => _fetchDocumentos());
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

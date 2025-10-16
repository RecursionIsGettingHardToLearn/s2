import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../services/expediente_service.dart';
import 'expediente_form_screen.dart';

class ExpedienteListScreen extends StatefulWidget {
  const ExpedienteListScreen({super.key});

  @override
  State<ExpedienteListScreen> createState() => _ExpedienteListScreenState();
}

class _ExpedienteListScreenState extends State<ExpedienteListScreen> {
  late Future<List<Expediente>> _expedientesFuture;
  final _service = ExpedienteService();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    setState(() {
      _expedientesFuture = _service.getExpedientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExpedienteFormScreen()),
              ).then((_) => _fetch());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Expediente>>(
        future: _expedientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay expedientes.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final exp = data[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 3,
                child: ListTile(
                  title: Text(exp.nroExpediente),
                  subtitle: Text('Caso: ${exp.caso} • Estado: ${exp.estado}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _service.deleteExpediente(exp.id);
                          _fetch();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExpedienteFormScreen(expediente: exp),
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

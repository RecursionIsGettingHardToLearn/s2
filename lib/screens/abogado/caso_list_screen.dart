import 'package:flutter/material.dart';
import 'caso_form_screen.dart';
import '../../models/caso.dart';
import '../../services/caso_service.dart';

class CasoListScreen extends StatefulWidget {
  @override
  _CasoListScreenState createState() => _CasoListScreenState();
}

class _CasoListScreenState extends State<CasoListScreen> {
  late Future<List<Caso>> _casosFuture;
  final CasoService _casoService = CasoService();

  @override
  void initState() {
    super.initState();
    _fetchCasos();
  }

  Future<void> _fetchCasos() async {
    setState(() {
      _casosFuture = _casoService.getCasos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CasoFormScreen()),
              ).then((_) => _fetchCasos());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Caso>>(
        future: _casosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay casos.'));
          } else {
            final casos = snapshot.data!;
            return ListView.builder(
              itemCount: casos.length,
              itemBuilder: (context, index) {
                final caso = casos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: ListTile(
                    title: Text(caso.nroCaso),
                    subtitle: Text(caso.descripcion),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón para eliminar
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _casoService.deleteCaso(caso.id);
                            _fetchCasos();
                          },
                        ),
                        // Botón para editar
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navegar a la pantalla de edición con el caso seleccionado
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CasoFormScreen(caso: caso),
                              ),
                            ).then((_) => _fetchCasos());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

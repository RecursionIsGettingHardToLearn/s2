import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../models/caso.dart';
import '../../services/expediente_service.dart';
import '../../services/caso_service.dart';

class ExpedienteFormScreen extends StatefulWidget {
  final Expediente? expediente;

  const ExpedienteFormScreen({super.key, this.expediente});

  @override
  State<ExpedienteFormScreen> createState() => _ExpedienteFormScreenState();
}

class _ExpedienteFormScreenState extends State<ExpedienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _expedienteService = ExpedienteService();
  final _casoService = CasoService();

  final _nroExpController = TextEditingController();
  final _estadoController = TextEditingController();
  final _fechaCreacionController = TextEditingController();

  List<Caso> _casos = [];
  Caso? _casoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarCasos();

    if (widget.expediente != null) {
      _nroExpController.text = widget.expediente!.nroExpediente;
      _estadoController.text = widget.expediente!.estado;
      _fechaCreacionController.text = widget.expediente!.fechaCreacion;
      // Como 'caso' viene como nroCaso (string), lo mapeamos
      // al objeto Caso por nroCaso si está disponible.
      // (Si no hay match, el usuario puede seleccionar uno).
    } else {
      _estadoController.text = 'ABIERTO';
      _fechaCreacionController.text = DateTime.now().toIso8601String().split('T')[0];
    }
  }

  Future<void> _cargarCasos() async {
    try {
      final casos = await _casoService.getCasos();
      setState(() {
        _casos = casos;
        if (widget.expediente != null) {
          _casoSeleccionado = _casos.firstWhere(
            (c) => c.nroCaso == widget.expediente!.caso,
            orElse: () => _casos.isNotEmpty ? _casos.first : null as Caso,
          );
        }
      });
    } catch (e) {
      // Podrías mostrar un SnackBar con el error
    }
  }

  @override
  void dispose() {
    _nroExpController.dispose();
    _estadoController.dispose();
    _fechaCreacionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime initialDate = _fechaCreacionController.text.isNotEmpty
        ? DateTime.tryParse(_fechaCreacionController.text) ?? DateTime.now()
        : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _fechaCreacionController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_casoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un caso')),
      );
      return;
    }

    final expediente = Expediente(
      id: widget.expediente?.id ?? 0,
      caso: _casoSeleccionado!.nroCaso,
      casoId: _casoSeleccionado!.id, // **Se envía este**
      nroExpediente: _nroExpController.text,
      estado: _estadoController.text,
      fechaCreacion: _fechaCreacionController.text,
    );

    if (widget.expediente != null) {
      await _expedienteService.updateExpediente(expediente);
    } else {
      await _expedienteService.createExpediente(expediente);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expediente == null ? 'Nuevo Expediente' : 'Editar Expediente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Dropdown de Casos
                DropdownButtonFormField<Caso>(
                  value: _casoSeleccionado,
                  items: _casos
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text('${c.nroCaso} - ${c.descripcion}'),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _casoSeleccionado = val),
                  decoration: const InputDecoration(labelText: 'Caso'),
                  validator: (val) => val == null ? 'Selecciona un caso' : null,
                ),
                TextFormField(
                  controller: _nroExpController,
                  decoration: const InputDecoration(labelText: 'Nro. Expediente'),
                  validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                ),
                TextFormField(
                  controller: _estadoController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                TextFormField(
                  controller: _fechaCreacionController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Creación',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _selectDate,
                  validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

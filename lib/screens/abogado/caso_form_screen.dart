import 'package:flutter/material.dart';
import '../../models/caso.dart';
import '../../services/caso_service.dart';

class CasoFormScreen extends StatefulWidget {
  final Caso? caso;

  CasoFormScreen({this.caso});

  @override
  _CasoFormScreenState createState() => _CasoFormScreenState();
}

class _CasoFormScreenState extends State<CasoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final CasoService _casoService = CasoService();

  // Controladores para los campos de texto
  final TextEditingController _nroCasoController = TextEditingController();
  final TextEditingController _tipoCasoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _prioridadController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.caso != null) {
      _nroCasoController.text = widget.caso!.nroCaso;
      _tipoCasoController.text = widget.caso!.tipoCaso;
      _descripcionController.text = widget.caso!.descripcion;
      _estadoController.text = widget.caso!.estado;
      _prioridadController.text = widget.caso!.prioridad;
      _fechaInicioController.text = widget.caso!.fechaInicio;
      _fechaFinController.text = widget.caso!.fechaFin ?? '';
    } else {
      _estadoController.text = 'ABIERTO';
      _prioridadController.text = 'MEDIA';
    }
  }

  @override
  void dispose() {
    // Liberar los controladores cuando el widget se destruya
    _nroCasoController.dispose();
    _tipoCasoController.dispose();
    _descripcionController.dispose();
    _estadoController.dispose();
    _prioridadController.dispose();
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    super.dispose();
  }

  Future<void> _saveCaso() async {
    if (_formKey.currentState!.validate()) {
      final caso = Caso(
        id: widget.caso?.id ?? 0,
        nroCaso: _nroCasoController.text,
        tipoCaso: _tipoCasoController.text,
        descripcion: _descripcionController.text,
        estado: _estadoController.text,
        prioridad: _prioridadController.text,
        fechaInicio: _fechaInicioController.text,
        fechaFin: _fechaFinController.text.isEmpty ? null : _fechaFinController.text,
        creadoEn: '',
        actualizadoEn: '',
      );

      if (widget.caso != null) {
        await _casoService.updateCaso(caso);
      } else {
        await _casoService.createCaso(caso);
      }

      Navigator.pop(context);
    }
  }

  // Function to show DatePicker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate
        ? (_fechaInicioController.text.isNotEmpty 
            ? DateTime.parse(_fechaInicioController.text) 
            : DateTime.now())
        : (_fechaFinController.text.isNotEmpty 
            ? DateTime.parse(_fechaFinController.text) 
            : DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicioController.text = "${picked.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
        } else {
          _fechaFinController.text = "${picked.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.caso == null ? 'Nuevo Caso' : 'Editar Caso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nroCasoController,
                  decoration: const InputDecoration(labelText: 'Número de Caso'),
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null,
                ),
                TextFormField(
                  controller: _tipoCasoController,
                  decoration: const InputDecoration(labelText: 'Tipo de Caso'),
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextFormField(
                  controller: _estadoController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                TextFormField(
                  controller: _prioridadController,
                  decoration: const InputDecoration(labelText: 'Prioridad'),
                ),
                // Fecha de Inicio with Date Picker
                TextFormField(
                  controller: _fechaInicioController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Inicio',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context, true),
                  validator: (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null,
                ),
                // Fecha de Fin with Date Picker
                TextFormField(
                  controller: _fechaFinController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Fin',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context, false),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _saveCaso,
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
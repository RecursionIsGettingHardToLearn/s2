import 'package:flutter/material.dart';
import '../../models/tipo_documento.dart';
import '../../services/tipo_documento_service.dart';

class TipoDocumentoFormScreen extends StatefulWidget {
  final TipoDocumento? tipoDocumento;

  const TipoDocumentoFormScreen({super.key, this.tipoDocumento});

  @override
  State<TipoDocumentoFormScreen> createState() => _TipoDocumentoFormScreenState();
}

class _TipoDocumentoFormScreenState extends State<TipoDocumentoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _activoController = TextEditingController();
  final TipoDocumentoService _tipoDocumentoService = TipoDocumentoService();

  @override
  void initState() {
    super.initState();

    if (widget.tipoDocumento != null) {
      _nombreController.text = widget.tipoDocumento!.nombre;
      _descripcionController.text = widget.tipoDocumento!.descripcion;
      _activoController.text = widget.tipoDocumento!.activo ? 'true' : 'false';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _activoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final tipoDocumento = TipoDocumento(
        id: widget.tipoDocumento?.id ?? 0,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        activo: _activoController.text.toLowerCase() == 'true',
      );

      if (widget.tipoDocumento != null) {
        await _tipoDocumentoService.updateTipoDocumento(tipoDocumento);
      } else {
        await _tipoDocumentoService.createTipoDocumento(tipoDocumento);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipoDocumento == null ? 'Nuevo Tipo de Documento' : 'Editar Tipo de Documento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextFormField(
                  controller: _activoController,
                  decoration: const InputDecoration(labelText: 'Activo (true/false)'),
                  validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
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

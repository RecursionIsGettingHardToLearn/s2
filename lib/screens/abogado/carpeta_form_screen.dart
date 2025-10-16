import 'package:flutter/material.dart';
import '../../models/carpeta.dart';
import '../../models/expediente.dart';
import '../../services/carpeta_service.dart';
import '../../services/expediente_service.dart';

class CarpetaFormScreen extends StatefulWidget {
  final Carpeta? carpeta;

  const CarpetaFormScreen({super.key, this.carpeta});

  @override
  State<CarpetaFormScreen> createState() => _CarpetaFormScreenState();
}

class _CarpetaFormScreenState extends State<CarpetaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _carpetaService = CarpetaService();
  final _expedienteService = ExpedienteService();

  final _nombreController = TextEditingController();
  final _estadoController = TextEditingController();

  List<Expediente> _expedientes = [];
  Expediente? _expedienteSel;

  List<Carpeta> _todasCarpetas = [];
  Carpeta? _carpetaPadreSel;

  @override
  void initState() {
    super.initState();
    _cargarExpedientesYCarpetas();

    if (widget.carpeta != null) {
      _nombreController.text = widget.carpeta!.nombre;
      _estadoController.text = widget.carpeta!.estado;
    } else {
      _estadoController.text = 'ACTIVO';
    }
  }

  Future<void> _cargarExpedientesYCarpetas() async {
    try {
      final expedientes = await _expedienteService.getExpedientes();
      final carpetas = await _carpetaService.getCarpetas();

      setState(() {
        _expedientes = expedientes;
        _todasCarpetas = carpetas;

        if (widget.carpeta != null) {
          // Emparejar expediente por nroExpediente (string)
          _expedienteSel = _expedientes.firstWhere(
            (e) => e.nroExpediente == widget.carpeta!.expediente,
            orElse: () => _expedientes.isNotEmpty ? _expedientes.first : null as Expediente,
          );

          // Emparejar carpeta padre por nombre (si vino uno)
          if (widget.carpeta!.carpetaPadre != null) {
            final posiblesPadres = _carpetasFiltradasPorExpediente();
            _carpetaPadreSel = posiblesPadres.firstWhere(
              (c) => c.nombre == widget.carpeta!.carpetaPadre,
              orElse: () => posiblesPadres.isNotEmpty ? posiblesPadres.first : null as Carpeta,
            );
          }
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando datos: $e')),
      );
    }
  }

  List<Carpeta> _carpetasFiltradasPorExpediente() {
    if (_expedienteSel == null) return [];
    // Filtra por string nroExpediente (representación)
    return _todasCarpetas
        .where((c) => c.expediente == _expedienteSel!.nroExpediente && c.id != (widget.carpeta?.id ?? -1))
        .toList();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_expedienteSel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un expediente')),
      );
      return;
    }

    final carpeta = Carpeta(
      id: widget.carpeta?.id ?? 0,
      expediente: _expedienteSel!.nroExpediente,     // para mostrar
      expedienteId: _expedienteSel!.id,              // para enviar
      carpetaPadre: _carpetaPadreSel?.nombre,        // para mostrar
      carpetaPadreId: _carpetaPadreSel?.id,          // para enviar
      nombre: _nombreController.text,
      estado: _estadoController.text,
      creadoEn: widget.carpeta?.creadoEn,
      actualizadoEn: widget.carpeta?.actualizadoEn,
    );

    if (widget.carpeta != null) {
      await _carpetaService.updateCarpeta(carpeta);
    } else {
      await _carpetaService.createCarpeta(carpeta);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final carpetasDelExpediente = _carpetasFiltradasPorExpediente();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carpeta == null ? 'Nueva Carpeta' : 'Editar Carpeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Expediente
                DropdownButtonFormField<Expediente>(
                  value: _expedienteSel,
                  items: _expedientes
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text('${e.nroExpediente} — ${e.estado}'),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() {
                    _expedienteSel = val;
                    _carpetaPadreSel = null; // reset si cambió el expediente
                  }),
                  decoration: const InputDecoration(labelText: 'Expediente'),
                  validator: (v) => v == null ? 'Selecciona un expediente' : null,
                ),

                // Carpeta padre (opcional)
                DropdownButtonFormField<Carpeta>(
                  isExpanded: true,
                  value: _carpetaPadreSel,
                  items: [
                    const DropdownMenuItem<Carpeta>(
                      value: null,
                      child: Text('— Sin carpeta padre —'),
                    ),
                    ...carpetasDelExpediente.map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.nombre),
                        )),
                  ],
                  onChanged: (val) => setState(() => _carpetaPadreSel = val),
                  decoration: const InputDecoration(labelText: 'Carpeta Padre (opcional)'),
                ),

                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                ),
                TextFormField(
                  controller: _estadoController,
                  decoration: const InputDecoration(labelText: 'Estado'),
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

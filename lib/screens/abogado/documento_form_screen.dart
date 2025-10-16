import 'package:flutter/material.dart';
import '../../models/documento.dart';
import '../../models/carpeta.dart';
import '../../models/tipo_documento.dart';
import '../../models/etapa_procesal.dart';
import '../../services/documento_service.dart';
import '../../services/carpeta_service.dart';
import '../../services/tipo_documento_service.dart';
import '../../services/etapa_procesal_service.dart';

class DocumentoFormScreen extends StatefulWidget {
  final Documento? documento;

  const DocumentoFormScreen({super.key, this.documento});

  @override
  State<DocumentoFormScreen> createState() => _DocumentoFormScreenState();
}

class _DocumentoFormScreenState extends State<DocumentoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreDocumentoController = TextEditingController();
  final _rutaDocumentoController = TextEditingController();
  final _tamanoController = TextEditingController();
  final _estadoController = TextEditingController();
  final _palabraClaveController = TextEditingController();
  final _fechaDocController = TextEditingController();

  final DocumentoService _documentoService = DocumentoService();
  final CarpetaService _carpetaService = CarpetaService();
  final TipoDocumentoService _tipoDocumentoService = TipoDocumentoService();
  final EtapaProcesalService _etapaProcesalService = EtapaProcesalService();

  List<Carpeta> _carpetas = [];
  List<TipoDocumento> _tiposDocumento = [];
  List<EtapaProcesal> _etapasProcesales = [];

  Carpeta? _carpetaSeleccionada;
  TipoDocumento? _tipoDocumentoSeleccionado;
  EtapaProcesal? _etapaProcesalSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarCarpetas();
    _cargarTiposDocumento();
    _cargarEtapasProcesales();

    if (widget.documento != null) {
      _nombreDocumentoController.text = widget.documento!.nombreDocumento;
      _rutaDocumentoController.text = widget.documento!.rutaDocumento;
      _tamanoController.text = widget.documento!.tamano.toString();
      _estadoController.text = widget.documento!.estado;
      _palabraClaveController.text = widget.documento!.palabraClave;
      _fechaDocController.text = widget.documento!.fechaDoc;

      // Pre-seleccionar Carpeta, TipoDocumento y EtapaProcesal
      _carpetaSeleccionada = _carpetas.firstWhere(
        (c) => c.id == widget.documento!.carpetaId,
        orElse: () => Carpeta(
          id: 0,
          nombre: "Default Carpeta",
          estado: "ACTIVO",
          expediente: "Dis"
        ),
      );

      _tipoDocumentoSeleccionado = _tiposDocumento.firstWhere(
        (t) => t.id == widget.documento!.tipoDocumentoId,
        orElse: () => TipoDocumento(
          id: 0,
          nombre: "Default TipoDocumento",
          descripcion: "Default",
          activo: true,
        ),
      );

      _etapaProcesalSeleccionada = _etapasProcesales.firstWhere(
        (e) => e.id == widget.documento!.etapaProcesalId,
        orElse: () => EtapaProcesal(
          id: 0,
          nombre: "Default Etapa",
          descripcion: "Default",
          estado: "ACTIVO",
        ),
      );
    }
  }

  // Cargar carpetas desde el servicio
  Future<void> _cargarCarpetas() async {
    try {
      final carpetas = await _carpetaService.getCarpetas();
      if (mounted) {
        setState(() {
          _carpetas = carpetas;
        });
      }
    } catch (e) {
      // Manejo de error
    }
  }

  // Cargar tipos de documento desde el servicio
  Future<void> _cargarTiposDocumento() async {
    try {
      final tiposDocumento = await _tipoDocumentoService.getTipoDocumentos();
      if (mounted) {
        setState(() {
          _tiposDocumento = tiposDocumento;
        });
      }
    } catch (e) {
      // Manejo de error
    }
  }

  // Cargar etapas procesales desde el servicio
  Future<void> _cargarEtapasProcesales() async {
    try {
      final etapasProcesales = await _etapaProcesalService.getEtapasProcesales();
      if (mounted) {
        setState(() {
          _etapasProcesales = etapasProcesales;
        });
      }
    } catch (e) {
      // Manejo de error
    }
  }

  @override
  void dispose() {
    _nombreDocumentoController.dispose();
    _rutaDocumentoController.dispose();
    _tamanoController.dispose();
    _estadoController.dispose();
    _palabraClaveController.dispose();
    _fechaDocController.dispose();
    super.dispose();
  }

  // Guardar o actualizar el documento
  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final documento = Documento(
        id: widget.documento?.id ?? 0,
        nombreDocumento: _nombreDocumentoController.text.isNotEmpty
            ? _nombreDocumentoController.text
            : "Documento Sin Nombre", // Verificación para evitar nulos
        rutaDocumento: _rutaDocumentoController.text.isNotEmpty
            ? _rutaDocumentoController.text
            : "Ruta No Proporcionada", // Verificación para evitar nulos
        tamano: double.parse(_tamanoController.text.isNotEmpty
            ? _tamanoController.text
            : '0.0'), // Verificación para evitar nulos
        estado: _estadoController.text.isNotEmpty
            ? _estadoController.text
            : "ACTIVO", // Verificación para evitar nulos
        palabraClave: _palabraClaveController.text.isNotEmpty
            ? _palabraClaveController.text
            : "Sin Palabra Clave", // Verificación para evitar nulos
        fechaDoc: _fechaDocController.text.isNotEmpty
            ? _fechaDocController.text
            : "0000-00-00", // Verificación para evitar nulos
        carpetaId: _carpetaSeleccionada!.id,
        tipoDocumentoId: _tipoDocumentoSeleccionado!.id,
        etapaProcesalId: _etapaProcesalSeleccionada?.id,
        carpeta: _carpetaSeleccionada!.nombre,
        tipoDocumento: _tipoDocumentoSeleccionado!.nombre,
        etapaProcesal: _etapaProcesalSeleccionada?.nombre,
        creadoEn: widget.documento?.creadoEn ?? '',
        actualizadoEn: widget.documento?.actualizadoEn ?? '',
      );

      if (widget.documento != null) {
        await _documentoService.updateDocumento(documento);
      } else {
        await _documentoService.createDocumento(documento);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documento == null ? 'Nuevo Documento' : 'Editar Documento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<Carpeta>(
                  value: _carpetaSeleccionada,
                  items: _carpetas.map((e) {
                    return DropdownMenuItem<Carpeta>(
                      value: e,
                      child: Text(e.nombre),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _carpetaSeleccionada = val),
                  decoration: const InputDecoration(labelText: 'Carpeta'),
                ),
                DropdownButtonFormField<TipoDocumento>(
                  value: _tipoDocumentoSeleccionado,
                  items: _tiposDocumento.map((e) {
                    return DropdownMenuItem<TipoDocumento>(
                      value: e,
                      child: Text(e.nombre),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _tipoDocumentoSeleccionado = val),
                  decoration: const InputDecoration(labelText: 'Tipo de Documento'),
                ),
                DropdownButtonFormField<EtapaProcesal>(
                  value: _etapaProcesalSeleccionada,
                  items: _etapasProcesales.map((e) {
                    return DropdownMenuItem<EtapaProcesal>(
                      value: e,
                      child: Text(e.nombre),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _etapaProcesalSeleccionada = val),
                  decoration: const InputDecoration(labelText: 'Etapa Procesal'),
                ),
                TextFormField(
                  controller: _nombreDocumentoController,
                  decoration: const InputDecoration(labelText: 'Nombre Documento'),
                  validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
                ),
                TextFormField(
                  controller: _rutaDocumentoController,
                  decoration: const InputDecoration(labelText: 'Ruta Documento'),
                ),
                TextFormField(
                  controller: _tamanoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Tamaño (MB o KB)'),
                ),
                TextFormField(
                  controller: _estadoController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                TextFormField(
                  controller: _palabraClaveController,
                  decoration: const InputDecoration(labelText: 'Palabra Clave'),
                ),
                TextFormField(
                  controller: _fechaDocController,
                  decoration: const InputDecoration(labelText: 'Fecha Documento'),
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

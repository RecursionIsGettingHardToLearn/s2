class Documento {
  final int id;
  final String nombreDocumento;
  final String rutaDocumento;
  final double tamano;
  final String estado;
  final String palabraClave;
  final String fechaDoc;

  final int carpetaId;  // Para crear o actualizar, necesitamos el ID de la Carpeta
  final int tipoDocumentoId;  // Para crear o actualizar, necesitamos el ID de TipoDocumento
  final int? etapaProcesalId; // Para crear o actualizar, necesitamos el ID de EtapaProcesal

  // Solo para mostrar
  final String carpeta;  // Carpeta nombre
  final String tipoDocumento;  // Tipo de Documento nombre
  final String? etapaProcesal;  // Etapa Procesal nombre (puede ser null)
  
  final String creadoEn;
  final String actualizadoEn;

  Documento({
    required this.id,
    required this.nombreDocumento,
    required this.rutaDocumento,
    required this.tamano,
    required this.estado,
    required this.palabraClave,
    required this.fechaDoc,
    required this.carpetaId,
    required this.tipoDocumentoId,
    this.etapaProcesalId,
    required this.carpeta,
    required this.tipoDocumento,
    this.etapaProcesal,
    required this.creadoEn,
    required this.actualizadoEn,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      nombreDocumento: json['nombreDocumento'],
      rutaDocumento: json['rutaDocumento'],
      tamano: json['tamano'],
      estado: json['estado'],
      palabraClave: json['palabraClave'] ?? '',
      fechaDoc: json['fechaDoc'],
      carpetaId: json['carpetaId'],
      tipoDocumentoId: json['tipoDocumentoId'],
      etapaProcesalId: json['etapaProcesalId'],
      carpeta: json['carpeta'],
      tipoDocumento: json['tipoDocumento'],
      etapaProcesal: json['etapaProcesal'],
      creadoEn: json['creadoEn'],
      actualizadoEn: json['actualizadoEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreDocumento': nombreDocumento,
      'rutaDocumento': rutaDocumento,
      'tamano': tamano,
      'estado': estado,
      'palabraClave': palabraClave,
      'fechaDoc': fechaDoc,
      'carpeta': carpetaId,
      'tipoDocumento': tipoDocumentoId,
      'etapaProcesal': etapaProcesalId,
    };
  }
}

class Carpeta {
  final int id;

  // Representación para mostrar (viene del GET por tu to_representation)
  final String expediente;      // nroExpediente (string)
  final String? carpetaPadre;   // nombre de la carpeta padre, si hay

  // Para crear/editar (enviar a la API)
  final int? expedienteId;      // ID real del Expediente
  final int? carpetaPadreId;    // ID real de la Carpeta padre

  final String nombre;
  final String estado;

  // Solo lectura (GET)
  final String? creadoEn;
  final String? actualizadoEn;

  Carpeta({
    required this.id,
    required this.expediente,
    this.carpetaPadre,
    this.expedienteId,
    this.carpetaPadreId,
    required this.nombre,
    required this.estado,
    this.creadoEn,
    this.actualizadoEn,
  });

  factory Carpeta.fromJson(Map<String, dynamic> json) {
    return Carpeta(
      id: json['id'],
      expediente: json['expediente'],          // llega como nroExpediente
      carpetaPadre: json['carpetaPadre'],      // llega como nombre o null
      expedienteId: null,
      carpetaPadreId: null,
      nombre: json['nombre'],
      estado: json['estado'],
      creadoEn: json['creadoEn'],
      actualizadoEn: json['actualizadoEn'],
    );
  }

  /// Para POST/PUT (enviar IDs)
  Map<String, dynamic> toJson() {
    return {
      'expediente': expedienteId,
      'nombre': nombre,
      'estado': estado,
      'carpetaPadre': carpetaPadreId, // puede ser null
    };
  }

  Carpeta copyWith({
    int? id,
    String? expediente,
    String? carpetaPadre,
    int? expedienteId,
    int? carpetaPadreId,
    String? nombre,
    String? estado,
    String? creadoEn,
    String? actualizadoEn,
  }) {
    return Carpeta(
      id: id ?? this.id,
      expediente: expediente ?? this.expediente,
      carpetaPadre: carpetaPadre ?? this.carpetaPadre,
      expedienteId: expedienteId ?? this.expedienteId,
      carpetaPadreId: carpetaPadreId ?? this.carpetaPadreId,
      nombre: nombre ?? this.nombre,
      estado: estado ?? this.estado,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }
}

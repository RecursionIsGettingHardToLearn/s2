class TipoDocumento {
  final int id;
  final String nombre;
  final String descripcion;
  final bool activo;

  TipoDocumento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.activo,
  });

  factory TipoDocumento.fromJson(Map<String, dynamic> json) {
    return TipoDocumento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      activo: json['activo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'activo': activo,
    };
  }
}

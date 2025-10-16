class EtapaProcesal {
  final int id;
  final String nombre;
  final String descripcion;
  final String estado;

  EtapaProcesal({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory EtapaProcesal.fromJson(Map<String, dynamic> json) {
    return EtapaProcesal(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
}

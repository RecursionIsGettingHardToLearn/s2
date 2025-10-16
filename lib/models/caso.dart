class Caso {
  final int id;
  final String nroCaso;
  final String tipoCaso;
  final String descripcion;
  final String estado;
  final String prioridad;
  final String fechaInicio;
  final String? fechaFin;
  final String creadoEn;
  final String actualizadoEn;

  Caso({
    required this.id,
    required this.nroCaso,
    required this.tipoCaso,
    required this.descripcion,
    required this.estado,
    required this.prioridad,
    required this.fechaInicio,
    this.fechaFin,
    required this.creadoEn,
    required this.actualizadoEn,
  });

  factory Caso.fromJson(Map<String, dynamic> json) {
    return Caso(
      id: json['id'],
      nroCaso: json['nroCaso'],
      tipoCaso: json['tipoCaso'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      prioridad: json['prioridad'],
      fechaInicio: json['fechaInicio'],
      fechaFin: json['fechaFin'],
      creadoEn: json['creadoEn'],
      actualizadoEn: json['actualizadoEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nroCaso': nroCaso,
      'tipoCaso': tipoCaso,
      'descripcion': descripcion,
      'estado': estado,
      'prioridad': prioridad,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
    };
  }
}

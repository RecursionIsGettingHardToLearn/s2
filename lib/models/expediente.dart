class Expediente {
  final int id;
  // Para listar: llega como string nroCaso (por tu to_representation)
  final String caso; 
  // Para crear/editar: enviamos el ID del Caso
  final int? casoId;

  final String nroExpediente;
  final String estado;
  final String fechaCreacion;

  Expediente({
    required this.id,
    required this.caso,
    this.casoId,
    required this.nroExpediente,
    required this.estado,
    required this.fechaCreacion,
  });

  factory Expediente.fromJson(Map<String, dynamic> json) {
    return Expediente(
      id: json['id'],
      caso: json['caso'], // viene como nroCaso (string)
      casoId: null,       // no viene en la representación
      nroExpediente: json['nroExpediente'],
      estado: json['estado'],
      fechaCreacion: json['fechaCreacion'],
    );
  }

  /// Para crear/editar: DRF espera el ID del caso en 'caso'
  Map<String, dynamic> toJson() {
    return {
      'caso': casoId, // IMPORTANTE: enviar ID
      'nroExpediente': nroExpediente,
      'estado': estado,
      'fechaCreacion': fechaCreacion,
    };
  }
}

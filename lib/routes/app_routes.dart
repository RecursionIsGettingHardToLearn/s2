// lib/utils/app_routes.dart
class AppRoutes {
  // Cliente (Client)
  static const String clienteDashboard = '/cliente/dashboard';
  static const String clientePerfil = '/cliente/perfil';
  static const String clienteMisCasos = '/cliente/mis-casos';
  static const String clienteDocumentos = '/cliente/documentos';
  static const String clienteConsultas = '/cliente/consultas';
  static const String clienteNotificaciones = '/cliente/notificaciones';
  static const String clienteCambiarContra = '/cliente/cambiar-contra';
  static const String clientePagos = '/cliente/pagos';
  static const String clienteComunicados = '/cliente/comunicados';
  static const String clienteConsultasDocumentos = '/cliente/consultas-documentos';

  // Abogado (Lawyer)
  static const String abogadoDashboard = '/abogado/dashboard';
  static const String abogadoPerfil = '/abogado/perfil';
  static const String abogadoMisCasos = '/abogado/mis-casos';
  static const String abogadoExpedientes = '/abogado/expedientes';
  static const String abogadoGestionCarpeta = '/abogado/gestion-carpeta';
  static const String abogadoTipoDocumento = '/abogado/gestion-tipo-documento';
  static const String abogadoGestionDocumentos = '/abogado/gestion-documentos';

  static const String abogadoAsignarCasos = '/abogado/asignar-casos';
  static const String abogadoPartesProcesales = '/abogado/partes-procesales';
  static const String abogadoConsultas = '/abogado/consultas';
  static const String abogadoCambiarContra = '/abogado/cambiar-contra';
  static const String abogadoComunicados = '/abogado/comunicados';
  static const String abogadoGestionEquipo = '/abogado/gestion-equipo';

  // Asistente (Assistant)
  static const String asistenteDashboard = '/asistente/dashboard';
  static const String asistentePerfil = '/asistente/perfil';
  static const String asistenteCasosAsignados = '/asistente/casos-asignados';
  static const String asistenteDocumentosGestion = '/asistente/documentos-gestion';
  static const String asistenteConsultas = '/asistente/consultas';
  static const String asistenteTareas = '/asistente/tareas';
  static const String asistenteHistorialAccesos = '/asistente/historial-accesos';
  static const String asistenteComunicados = '/asistente/comunicados';
  static const String asistenteReportarIncidente = '/asistente/reportar-incidente';

  // Rutas comunes para todos los roles (puedes añadir rutas comunes si es necesario)
  static const String asistenteCambiarContra = '/cambiar-contrasena';
  static const String notificacionesGenerales = '/notificaciones';
}
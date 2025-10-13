// src/config/menuItems.dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class MenuItem {
  final String? to; // Make 'to' optional for parent items
  final String title;
  final IconData? icon; // Usamos IconData para los íconos de Flutter
  final String? action; // Puedes extender esto si tienes más acciones
  final List<MenuItem>? subItems; // New property for dropdown items

  MenuItem({
    this.to,
    required this.title,
    this.icon,
    this.action,
    this.subItems,
  });
}

// Menú de items por rol con rutas actualizadas desde `app_routes.dart`
final Map<String, List<MenuItem>> menuItemsByRole = {
  'CLI': [
    MenuItem(
      to: AppRoutes.clienteDashboard,
      title: 'DASHBOARD',
      icon: FontAwesomeIcons.home,
    ),
    MenuItem(
      title: 'Mis Casos',
      icon: FontAwesomeIcons.gavel,
      subItems: [
        MenuItem(
          to: AppRoutes.clienteMisCasos,
          title: 'Ver Mis Casos',
          icon: FontAwesomeIcons.legal,
        ),
        MenuItem(
          to: AppRoutes.clienteConsultas,
          title: 'Consultas Legales',
          icon: FontAwesomeIcons.comments,
        ),
      ],
    ),
    MenuItem(
      title: 'Documentos',
      icon: FontAwesomeIcons.fileAlt,
      subItems: [
        MenuItem(
          to: AppRoutes.clienteDocumentos,
          title: 'Mis Documentos',
          icon: FontAwesomeIcons.paperclip,
        ),
        MenuItem(
          to: AppRoutes.clienteConsultasDocumentos,
          title: 'Consultas de Documentos',
          icon: FontAwesomeIcons.fileSignature,
        ),
      ],
    ),
    MenuItem(
      title: 'Finanzas',
      icon: FontAwesomeIcons.moneyBillWave,
      subItems: [
        MenuItem(
          to: AppRoutes.clientePagos,
          title: 'Mis Pagos',
          icon: FontAwesomeIcons.creditCard,
        ),
      ],
    ),
    MenuItem(
      title: 'Comunicación',
      icon: FontAwesomeIcons.bullhorn,
      subItems: [
        MenuItem(
          to: AppRoutes.clienteComunicados,
          title: 'Comunicados',
          icon: FontAwesomeIcons.envelopeOpenText,
        ),
        MenuItem(
          to: AppRoutes.clienteNotificaciones,
          title: 'Notificaciones',
          icon: FontAwesomeIcons.bell,
        ),
      ],
    ),
    MenuItem(
      title: 'Perfil',
      icon: FontAwesomeIcons.user,
      subItems: [
        MenuItem(
          to: AppRoutes.clientePerfil,
          title: 'Ver Perfil',
          icon: FontAwesomeIcons.userCircle,
        ),
        MenuItem(
          to: AppRoutes.clienteCambiarContra,
          title: 'Cambiar Contraseña',
          icon: FontAwesomeIcons.key,
        ),
        MenuItem(
          title: 'Cerrar Sesión',
          icon: FontAwesomeIcons.signOutAlt, // Ícono de logout
          action: 'signout', // Acción que manejará el logout
        ),
      ],
    ),
  ],
  'ABO': [
    MenuItem(
      to: AppRoutes.abogadoDashboard,
      title: 'DASHBOARD',
      icon: FontAwesomeIcons.home,
    ),
    MenuItem(
      title: 'Mis Casos',
      icon: FontAwesomeIcons.gavel,
      subItems: [
        MenuItem(
          to: AppRoutes.abogadoMisCasos,
          title: 'Ver Mis Casos',
          icon: FontAwesomeIcons.legal,
        ),
        MenuItem(
          to: AppRoutes.abogadoAsignarCasos,
          title: 'Asignar Casos',
          icon: FontAwesomeIcons.sitemap,
        ),
      ],
    ),
    MenuItem(
      title: 'Documentos',
      icon: FontAwesomeIcons.fileAlt,
      subItems: [
        MenuItem(
          to: AppRoutes.abogadoGestionDocumentos,
          title: 'Gestionar Documentos',
          icon: FontAwesomeIcons.filePdf,
        ),
        MenuItem(
          to: AppRoutes.abogadoPartesProcesales,
          title: 'Partes Procesales',
          icon: FontAwesomeIcons.fileContract,
        ),
      ],
    ),
    MenuItem(
      title: 'Consultas',
      icon: FontAwesomeIcons.comments,
      subItems: [
        MenuItem(
          to: AppRoutes.abogadoConsultas,
          title: 'Consultas Legales',
          icon: FontAwesomeIcons.comment,
        ),
      ],
    ),
    MenuItem(
      title: 'Perfil',
      icon: FontAwesomeIcons.user,
      subItems: [
        MenuItem(
          to: AppRoutes.abogadoPerfil,
          title: 'Ver Perfil',
          icon: FontAwesomeIcons.userCircle,
        ),
        MenuItem(
          to: AppRoutes.abogadoCambiarContra,
          title: 'Cambiar Contraseña',
          icon: FontAwesomeIcons.key,
        ),
        MenuItem(
          title: 'Cerrar Sesión',
          icon: FontAwesomeIcons.signOutAlt, // Ícono de logout
          action: 'signout', // Acción que manejará el logout
        ),
      ],
    ),
  ],
  'ASI': [
    MenuItem(
      to: AppRoutes.asistenteDashboard,
      title: 'DASHBOARD',
      icon: FontAwesomeIcons.home,
    ),
    MenuItem(
      title: 'Casos Asignados',
      icon: FontAwesomeIcons.gavel,
      subItems: [
        MenuItem(
          to: AppRoutes.asistenteCasosAsignados,
          title: 'Ver Casos Asignados',
          icon: FontAwesomeIcons.list,
        ),
      ],
    ),
    MenuItem(
      title: 'Documentos',
      icon: FontAwesomeIcons.fileAlt,
      subItems: [
        MenuItem(
          to: AppRoutes.asistenteDocumentosGestion,
          title: 'Gestionar Documentos',
          icon: FontAwesomeIcons.filePdf,
        ),
      ],
    ),
    MenuItem(
      title: 'Tareas',
      icon: FontAwesomeIcons.tasks,
      subItems: [
        MenuItem(
          to: AppRoutes.asistenteTareas,
          title: 'Mis Tareas',
          icon: FontAwesomeIcons.clipboard,
        ),
      ],
    ),
    MenuItem(
      title: 'Accesos',
      icon: FontAwesomeIcons.key,
      subItems: [
        MenuItem(
          to: AppRoutes.asistenteHistorialAccesos,
          title: 'Historial de Accesos',
          icon: FontAwesomeIcons.history,
        ),
      ],
    ),
    MenuItem(
      title: 'Comunicación',
      icon: FontAwesomeIcons.bullhorn,
      subItems: [
        MenuItem(
          to: AppRoutes.asistenteComunicados,
          title: 'Comunicados',
          icon: FontAwesomeIcons.envelopeOpenText,
        ),
      ],
    ),
    MenuItem(
      title: 'Incidentes',
      icon: FontAwesomeIcons.exclamationTriangle,
      subItems: [
        MenuItem(
          to: AppRoutes.asistenteReportarIncidente,
          title: 'Reportar Incidente',
          icon: FontAwesomeIcons.bug,
        ),
      ],
    ),
    MenuItem(
      title: 'Perfil',
      icon: FontAwesomeIcons.user,
      subItems: [
        MenuItem(
          to: AppRoutes.asistentePerfil,
          title: 'Ver Perfil',
          icon: FontAwesomeIcons.userCircle,
        ),
        MenuItem(
          to: AppRoutes.asistenteCambiarContra,
          title: 'Cambiar Contraseña',
          icon: FontAwesomeIcons.key,
        ),
        MenuItem(
          title: 'Cerrar Sesión',
          icon: FontAwesomeIcons.signOutAlt, // Ícono de logout
          action: 'signout', // Acción que manejará el logout
        ),
      ],
    ),
  ],
};

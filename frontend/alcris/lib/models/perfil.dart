class PerfilUsuario {
  final String id;
  final String nombre;
  final String eslogan;
  final String localidad;
  final int servicios;
  final int pendientes;
  final int completados;
  final bool esAdmin;

  PerfilUsuario({
    required this.id,
    required this.nombre,
    required this.eslogan,
    required this.localidad,
    required this.servicios,
    required this.pendientes,
    required this.completados,
    required this.esAdmin,
  });

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    return PerfilUsuario(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] ?? 'Usuario',
      eslogan: json['eslogan'] ?? 'Cliente registrado en Alcris',
      localidad: json['localidad'] ?? 'Localidad',
      servicios: json['servicios'] ?? 0,
      pendientes: json['pendientes'] ?? 0,
      completados: json['completados'] ?? 0,
      esAdmin: (json['rol'] == 'admin'), // Se activa si el rol en Node es 'admin'
    );
  }
}
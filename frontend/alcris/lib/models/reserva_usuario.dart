Map<String, dynamic> _mapa(dynamic valor) =>
    valor is Map ? Map<String, dynamic>.from(valor) : <String, dynamic>{};

class ReservaUsuario {
  final String id;
  final String codigo;
  final String fecha;
  final String hora;
  final String estado;
  final String total;
  final String servicio;
  final String paquete;
  final String vehiculo;
  final String notas;

  ReservaUsuario({
    required this.id,
    required this.codigo,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.total,
    required this.servicio,
    required this.paquete,
    required this.vehiculo,
    required this.notas,
  });

  factory ReservaUsuario.fromJson(Map<String, dynamic> json) {
    final service = _mapa(json['servicios']);
    final paquete = _mapa(json['paquetes_servicio']);
    final vehiculo = _mapa(json['vehiculos']);

    final nombreServicio = (service['nombre'] ?? '').toString();
    final nombrePaquete = (paquete['nombre'] ?? '').toString();

    final marca = (vehiculo['marca'] ?? '').toString();
    final modelo = (vehiculo['modelo'] ?? '').toString();
    final placa = (vehiculo['placa'] ?? '').toString();
    final textoVehiculo = [marca, modelo, placa]
        .where((valor) => valor.isNotEmpty)
        .join(' · ');

    final totalNum = num.tryParse((json['total'] ?? 0).toString()) ?? 0;
    final totalTexto = totalNum == totalNum.roundToDouble()
        ? totalNum.round().toString()
        : totalNum.toStringAsFixed(2);

    return ReservaUsuario(
      id: (json['id'] ?? '').toString(),
      codigo: (json['codigo_reserva'] ?? '').toString(),
      fecha: (json['fecha_cita'] ?? '').toString(),
      hora: (json['hora_cita'] ?? '').toString(),
      estado: (json['estado'] ?? 'pendiente').toString(),
      total: '\$ $totalTexto COP',
      servicio: nombrePaquete.isNotEmpty
          ? (nombreServicio.isNotEmpty ? '$nombreServicio · $nombrePaquete' : nombrePaquete)
          : nombreServicio,
      paquete: nombrePaquete,
      vehiculo: textoVehiculo,
      notas: (json['notas'] ?? '').toString(),
    );
  }

  String get fechaFormateada {
    final partes = fecha.split('-');
    if (partes.length == 3) return '${partes[2]}/${partes[1]}/${partes[0]}';
    return fecha;
  }

  String get horaFormateada => hora.length >= 5 ? hora.substring(0, 5) : hora;
}

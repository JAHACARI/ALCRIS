class ServicioAdmin {
  final int id;
  final String nombre, descripcion;
  final int precio;
  final List<PaqueteAdmin> paquetes;
  ServicioAdmin({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    this.paquetes = const [],
  });
  factory ServicioAdmin.fromJson(Map<String, dynamic> j) => ServicioAdmin(
    id: j['id'],
    nombre: j['nombre'],
    descripcion: j['descripcion'],
    precio: j['precio'],
    paquetes: [
      for (final p in (j['paquetes'] ?? []) as List) PaqueteAdmin.fromJson(p),
    ],
  );
}

class PagoAdmin {
  final int id, monto, precioServicio;
  final String referencia,
      cliente,
      vehiculo,
      servicio,
      refNequi,
      comprobanteUrl;
  final DateTime creadoEn;
  PagoAdmin({
    required this.id,
    required this.monto,
    required this.precioServicio,
    required this.referencia,
    required this.cliente,
    required this.vehiculo,
    required this.servicio,
    required this.refNequi,
    required this.comprobanteUrl,
    required this.creadoEn,
  });
  factory PagoAdmin.fromJson(Map<String, dynamic> j) => PagoAdmin(
    id: j['id'],
    monto: j['monto'],
    precioServicio: j['precioServicio'],
    referencia: j['referencia'],
    cliente: j['cliente'],
    vehiculo: j['vehiculo'],
    servicio: j['servicio'],
    refNequi: j['refNequi'],
    comprobanteUrl: j['comprobanteUrl'],
    creadoEn: DateTime.parse(j['creadoEn']).toLocal(),
  );
  bool get coincide => monto == precioServicio;
}

String cop(int n) =>
    '\$${n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';

class PaqueteAdmin {
  final int? id;
  final String nombre, descripcion;
  final int precio, diasMin, diasMax;
  final bool destacado;
  PaqueteAdmin({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.diasMin,
    required this.diasMax,
    required this.destacado,
  });
  factory PaqueteAdmin.fromJson(Map<String, dynamic> j) => PaqueteAdmin(
    id: j['id'],
    nombre: j['nombre'] ?? '',
    descripcion: j['descripcion'] ?? '',
    precio: (j['precio'] as num).toInt(),
    diasMin: (j['diasMin'] as num?)?.toInt() ?? 1,
    diasMax: (j['diasMax'] as num?)?.toInt() ?? 1,
    destacado: j['destacado'] == true,
  );
  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'precio': precio,
    'dias_min': diasMin,
    'dias_max': diasMax,
    'destacado': destacado,
  };
}

class ReservaAdmin {
  final int id, total;
  final String codigo,
      fecha,
      hora,
      estado,
      formaPago,
      cliente,
      vehiculo,
      servicio;
  final bool confirmable;
  ReservaAdmin({
    required this.id,
    required this.total,
    required this.codigo,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.formaPago,
    required this.confirmable,
    required this.cliente,
    required this.vehiculo,
    required this.servicio,
  });
  factory ReservaAdmin.fromJson(Map<String, dynamic> j) => ReservaAdmin(
    id: j['id'],
    total: (j['total'] as num).toInt(),
    codigo: j['codigo'] ?? '',
    fecha: j['fecha'] ?? '',
    hora: (j['hora'] ?? '').toString(),
    estado: j['estado'] ?? '',
    formaPago: j['formaPago'] ?? '',
    confirmable: j['confirmable'] == true,
    cliente: j['cliente'] ?? '',
    vehiculo: j['vehiculo'] ?? '',
    servicio: j['servicio'] ?? '',
  );
}

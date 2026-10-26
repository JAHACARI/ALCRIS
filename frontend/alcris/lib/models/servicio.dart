class ServicioAdmin {
  final int id;
  final String nombre, descripcion;
  final int precio;
  ServicioAdmin({required this.id, required this.nombre, required this.descripcion, required this.precio});
  factory ServicioAdmin.fromJson(Map<String, dynamic> j) => ServicioAdmin(
        id: j['id'], nombre: j['nombre'], descripcion: j['descripcion'], precio: j['precio']);
}

class PagoAdmin {
  final int id, monto, precioServicio;
  final String referencia, cliente, vehiculo, servicio, refNequi, comprobanteUrl;
  final DateTime creadoEn;
  PagoAdmin({required this.id, required this.monto, required this.precioServicio, required this.referencia,
      required this.cliente, required this.vehiculo, required this.servicio, required this.refNequi,
      required this.comprobanteUrl, required this.creadoEn});
  factory PagoAdmin.fromJson(Map<String, dynamic> j) => PagoAdmin(
        id: j['id'], monto: j['monto'], precioServicio: j['precioServicio'],
        referencia: j['referencia'], cliente: j['cliente'], vehiculo: j['vehiculo'],
        servicio: j['servicio'], refNequi: j['refNequi'], comprobanteUrl: j['comprobanteUrl'],
        creadoEn: DateTime.parse(j['creadoEn']).toLocal());
  bool get coincide => monto == precioServicio;
}

String cop(int n) =>
    '\$${n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';

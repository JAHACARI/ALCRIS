import 'package:flutter/material.dart';

class DesgloseCostos extends StatelessWidget {
  final String servicioBasico;
  final String materiales;
  final String descuento;
  final String total;

  const DesgloseCostos({
    super.key,
    required this.servicioBasico,
    required this.materiales,
    required this.descuento,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Costos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          _buildFilaCosto('Servicio básico', servicioBasico),
          _buildFilaCosto('Materiales', materiales),
          _buildFilaCosto('Descuento cliente', descuento, esDescuento: true),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1.5, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text(total, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE94560))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFilaCosto(String concepto, String valor, {bool esDescuento = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(concepto, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(
            valor,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: esDescuento ? const Color(0xFFE94560) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
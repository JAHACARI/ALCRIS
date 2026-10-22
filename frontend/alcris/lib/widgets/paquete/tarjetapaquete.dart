import 'package:flutter/material.dart';

class TarjetaPaquete extends StatelessWidget {
  final Map<String, dynamic> datos;
  final bool isSelected;
  final VoidCallback onTap;

  const TarjetaPaquete({
    super.key,
    required this.datos,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🛠️ FILTRO ANTICRASH: Si la clave viene nula o no existe, se asigna un string seguro
    final String nombre = (datos['nombre'] ?? datos['title'] ?? 'Paquete').toString();
    final String descripcion = (datos['descripcion'] ?? datos['desc'] ?? '').toString();
    final String tiempo = (datos['tiempo'] ?? '').toString();
    final String precio = (datos['precio'] ?? '').toString();
    final String paneles = (datos['paneles'] ?? 'Revisión Completa').toString(); // Respaldo seguro si paneles viene null
    final String tag = (datos['tag'] ?? '').toString();

    // Filtros de respaldo para colores por si vienen nulos
    final Color colorTitle = datos['colorTitle'] is Color ? datos['colorTitle'] : const Color(0xFF0F172A);
    final Color tagBg = datos['tagBg'] is Color ? datos['tagBg'] : const Color(0xFFFFEBEE);
    final Color tagColor = datos['tagColor'] is Color ? datos['tagColor'] : const Color(0xFFE94560);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE94560) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nombre,
                  style: TextStyle(
                    color: colorTitle,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (tag.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: tagColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              descripcion,
              style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.3),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paneles,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    if (tiempo.isNotEmpty)
                      Text(
                        tiempo,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                  ],
                ),
                if (precio.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      precio,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

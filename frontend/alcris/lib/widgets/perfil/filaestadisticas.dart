import 'package:flutter/material.dart';
import 'tarjetaestadistica.dart';

class FilaEstadisticas extends StatelessWidget {
  const FilaEstadisticas({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: TarjetaEstadistica(numero: '8', etiqueta: 'Servicios')),
        SizedBox(width: 12),
        Expanded(child: TarjetaEstadistica(numero: '2', etiqueta: 'Pendientes')),
        SizedBox(width: 12),
        Expanded(child: TarjetaEstadistica(numero: '8', etiqueta: 'Servicios')),
      ],
    );
  }
}
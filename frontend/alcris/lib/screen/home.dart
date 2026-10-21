import 'package:flutter/material.dart';
import 'package:alcris/widgets/common/cabecerahome.dart';
import 'package:alcris/widgets/common/menuinferior.dart';
import 'package:alcris/screen/auth/registro.dart'; // Importación oficial de tu pantalla de registro

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0; 

  final List<Map<String, dynamic>> _serviciosTaller = [
    {'title': 'Latonería de precisión', 'desc': 'Enderezado de chasis, golpes severos y restauración geométrica estructural.', 'icon': Icons.build_rounded, 'color': const Color(0xFFE94560)},
    {'title': 'Pintura automotriz', 'desc': 'Aplicación en cabina presurizada, horneado y control de tono computarizado.', 'icon': Icons.brush_rounded, 'color': const Color(0xFF0055A5)},
    {'title': 'Detallado & Pulido', 'desc': 'Eliminación de microrrayas, brillo tridimensional y protección cerámica.', 'icon': Icons.auto_awesome_rounded, 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          const CabeceraHome(titulo: 'ALCRIS HOME'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('¡Hola, Bienvenido!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const Text('Expertos en restauración y estética automotriz', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 20),

                  const Text('¿QUÉ HACEMOS?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Colors.black54)),
                  const SizedBox(height: 12),
                  ..._serviciosTaller.map((s) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: s['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(s['icon'], color: s['color'], size: 24)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            const SizedBox(height: 4),
                            Text(s['desc'], style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.3)),
                          ],
                        )),
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: 16),

                  const Text('ACCIONES RÁPIDAS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  
                  // --- BOTÓN CON ENLACE DE NAVEGACIÓN ACTIVO ---
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
                      child: Row(
                        children: [
                          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.calendar_month_rounded, color: Color(0xFFE94560), size: 26)),
                          const SizedBox(width: 16),
                          const Text('Agendar Cita en Línea', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF003366), Color(0xFF0055A5)], begin: Alignment.topLeft), borderRadius: BorderRadius.circular(20)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('Garantía Alcris Premium', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Todos nuestros trabajos de pintura cuentan con 1 año de cobertura certificada contra imperfecciones.', style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.3)),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuInferior(currentIndex: _currentIndex, onTap: (indexPulsado) {}),
    );
  }
}
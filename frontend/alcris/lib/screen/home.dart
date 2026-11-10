import 'package:flutter/material.dart';
import 'package:alcris/widgets/common/cabecerahome.dart';
import 'package:alcris/widgets/common/menuinferior.dart';
import 'package:alcris/screen/auth/registro.dart';
import 'package:alcris/screen/auth/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pilaresTaller = [
    {
      'title': 'Repuestos Originales',
      'desc':
          'Garantizamos el uso de autopartes legítimas e insumos de pintura premium homologados.',
      'icon': Icons.extension_rounded,
      'color': const Color(0xFF0055A5),
    },
    {
      'title': 'Personal Calificado',
      'desc':
          'Técnicos certificados en restauración estructural y colorimetría automotriz.',
      'icon': Icons.engineering_rounded,
      'color': Colors.teal,
    },
  ];

  final List<String> _imagenesGaleria = [
    'assets/images/abolladura.jpg',
    'assets/images/pintura y polichado.jpg',
    'assets/images/lijado.png',
  ];

  // NUEVO MÉTODO: Muestra el banner de confirmación antes de redirigir
  void _mostrarBannerCuenta(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.account_circle_rounded, color: Color(0xFF0055A5)),
              SizedBox(width: 10),
              Text(
                '¿Tienes cuenta?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: const Text(
            'Para agendar tu cita en línea necesitamos verificar si ya estás registrado en ALCRIS.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            // BOTÓN NO -> Va a RegistroScreen
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // Cierra el banner
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistroScreen(),
                  ),
                );
              },
              child: const Text('No, registrarme'),
            ),
            // BOTÓN SÍ -> Va a LoginScreen
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE94560),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // Cierra el banner
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // REEMPLAZA LoginScreen() con el nombre exacto de tu clase de Login
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Sí, iniciar sesión'),
            ),
          ],
        );
      },
    );
  }

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
                  const Text(
                    '¡Hola, Bienvenido!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Text(
                    'Expertos en restauración y estética automotriz de confianza.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // BOTÓN AGENDAR CITA ACTUALIZADO
                  GestureDetector(
                    onTap: () => _mostrarBannerCuenta(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: Color(0xFFE94560),
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Agendar Cita en Línea',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'NUESTRO TRABAJO EN DETALLE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imagenesGaleria.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(_imagenesGaleria[index]),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    '¿POR QUÉ ELEGIR ALCRIS?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._pilaresTaller.map(
                    (p) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: p['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(p['icon'], color: p['color'], size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['title'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p['desc'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuInferior(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

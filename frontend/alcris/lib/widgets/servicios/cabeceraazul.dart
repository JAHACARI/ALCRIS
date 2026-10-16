import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CabeceraPremium extends StatelessWidget {
  final String titulo;

  const CabeceraPremium({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Contenedor Principal (Cabecera con bordes inferiores redondeados)
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2B48), Color(0xFF0A1E36), Color(0xFF051224)],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

          ),
          padding: const EdgeInsets.only(
            top: 60,
            left: 24,
            right: 24,
            bottom: 24,
          ),
          child: Stack(
            children: [
              // Logotipo de fondo con degradado de opacidad (Fondo JPG sutil)
              Positioned(
                right: -40,
                top: -10,
                bottom: -10,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      colors: [Colors.transparent, Colors.white],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Opacity(
                    opacity: 0.12,
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Contenido Principal (Fila Superior de Identidad + Título Inferior)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Contenedor del Icono con efecto de cristal (Glassmorphism)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.12),
                                  Colors.white.withOpacity(0.04),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.18),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Bloque de Textos del Taller
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Alcris',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Etiqueta de estado/registro en verde
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF00E676),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Crea tu cuenta',
                                    style: TextStyle(
                                      color: Color(0xFF00E676),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Texto Dinámico Principal (Título)
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. Línea de Degradado + Sombra Inferior de Flotado (Ajustada a la curvatura)
        Container(
          height: 4,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
          ), // Margen sutil para estilizar la división redondeada
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.transparent,
                Color.fromARGB(255, 230, 8, 0),
                Color.fromARGB(255, 240, 105, 105),
                Color.fromARGB(255, 230, 0, 0),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

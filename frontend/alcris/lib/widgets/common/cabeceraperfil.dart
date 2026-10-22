import 'package:flutter/material.dart';

class Cabeceraperfil extends StatelessWidget {
  final String titulo;

  const Cabeceraperfil({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Contenedor Principal (Cabecera Azul)
        Container(
          width: double.infinity,
          height: 170,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // Combinación de colores para un degradado profundo y moderno
              colors: [
                Color(0xFF0F2B48),
                Color(0xFF0A1E36),
                Color(0xFF051224),
              ],
              stops: [0.0, 0.5, 1.0], // Distribución suave del degradado
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Logotipo de fondo con degradado de opacidad (difuminado en el fondo)
              Positioned(
                right: -15,
                top: -10,
                bottom: -10,
                child: ShaderMask(
                  // Este ShaderMask hace que el logo se desvanezca hacia la izquierda
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      colors: [Colors.transparent, Colors.white],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Opacity(
                    opacity: 0.12, // Controla qué tan sutil se ve el logo de fondo
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              // Contenido Principal (Icono + Textos)
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Contenedor del Icono con efecto de cristal (Glassmorphism sutil)
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        // Degradado interno del recuadro del icono
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.12),
                            Colors.white.withOpacity(0.04),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5), // Mayor opacidad para fondo oscuro
                            blurRadius: 16,                       // Más difuminado para simular altura
                            offset: const Offset(0, 8),           // Mayor desplazamiento hacia abajo
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.white,
                        size: 26,
                  ),
                    ),
                    const SizedBox(width: 18),
                    
                    // Bloque de Textos
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
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
                                'Tu informacion está segura',
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 2. Línea de Degradado (Agregada) + Sombra Inferior de Flotado
        Container(
          height: 4,
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
            // Sombra inferior para proyectar el efecto flotante sobre la zona blanca
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
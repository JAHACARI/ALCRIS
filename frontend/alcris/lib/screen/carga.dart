import 'dart:async';
import 'dart:developer';
import 'package:alcris/screen/registro.dart';
import 'package:flutter/material.dart';

/// 1. Controlador Principal del Splash Screen
class AlcrisSplashScreen extends StatefulWidget {
  const AlcrisSplashScreen({super.key});

  @override
  State<AlcrisSplashScreen> createState() => _AlcrisSplashScreenState();
}

class _AlcrisSplashScreenState extends State<AlcrisSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Temporizador de 3 segundos para cambiar de pantalla
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RegistroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 3),
              SplashLogo(), // Widget del logo central
              Spacer(flex: 2),
              SplashLoadingIndicator(), // Widget indicador de carga abajo
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2. Widget de Fondo con Degradado Azul
class SplashBackground extends StatelessWidget {
  final Widget child;

  const SplashBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0C3A75), // Azul más claro/vivo superior
            Color(0xFF041935), // Azul oscuro profundo inferior
          ],
        ),
      ),
      child: child,
    );
  }
}

/// 3. Widget del Logo "ALCRIS"
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'alcris_logo_hero',
      child: Text(
        'ALCRIS',
        style: TextStyle(
          fontFamily: 'CustomFont', 
          fontSize: 64,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          letterSpacing: 2.0,
          color: Colors.white,
          shadows: [
            // Sombra sutil inferior para dar el efecto de relieve plateado
            Shadow(
              offset: const Offset(0, 4),
              blurRadius: 6.0,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// 4. Widget del Indicador de Carga Minimalista
class SplashLoadingIndicator extends StatelessWidget {
  const SplashLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
      ),
    );
  }
}


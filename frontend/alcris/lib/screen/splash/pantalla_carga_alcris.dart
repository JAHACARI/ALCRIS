import 'dart:async';
import 'package:alcris/screen/servicios/servicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/themes/colors.dart';
import 'package:alcris/screen/auth/registro.dart';
import 'package:alcris/screen/home.dart';

class PantallaCargaAlcris extends StatefulWidget {
  const PantallaCargaAlcris({super.key});

  @override
  State<PantallaCargaAlcris> createState() => _PantallaCargaAlcrisState();
}

class _PantallaCargaAlcrisState extends State<PantallaCargaAlcris>
    with SingleTickerProviderStateMixin {
  late AnimationController controlAnimacion;
  late Animation<double> animacionAparicion;
  late Animation<double> animacionEscala;

  @override
  void initState() {
    super.initState();

    controlAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    animacionAparicion = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controlAnimacion, curve: Curves.easeInOut),
    );

    animacionEscala = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: controlAnimacion, curve: Curves.elasticOut),
    );

    controlAnimacion.forward();

    // Navega a home después de cargar
    Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    controlAnimacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoOscuro,
      body: Center(
        child: AnimatedBuilder(
          animation: controlAnimacion,
          builder: (context, child) {
            return Opacity(
              opacity: animacionAparicion.value,
              child: Transform.scale(
                scale: animacionEscala.value,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

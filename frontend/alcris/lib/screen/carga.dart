import 'dart:developer';

import 'package:alcris/screen/servicio.dart';
import 'package:alcris/widgets/botonsiguiente.dart';
import 'package:alcris/widgets/tarjetalogo.dart';
import 'package:flutter/material.dart';
import 'package:alcris/core/themes/colors.dart';
import 'package:alcris/screen/registro.dart';

// Importamos nuestros nuevos componentes modulares
import 'package:alcris/widgets/botonsiguiente.dart';
import 'package:alcris/widgets/tarjetalogo.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.background),
        child: SafeArea(
          child: Stack(
            children: [
              // Contenido Principal Centralizado
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TarjetaLogo(assetPath: 'assets/images/logo.jpg'),
                    const SizedBox(height: 32),
                    Text(
                      'Latoneria y Pintura',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Botón integrado en la parte inferior de la pantalla
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: BotonSiguiente(
                    texto: 'Empezar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

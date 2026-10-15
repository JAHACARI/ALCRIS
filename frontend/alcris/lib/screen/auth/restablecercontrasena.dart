import 'package:flutter/material.dart';
import 'package:alcris/widgets/recuperar contraseña/tarjetarestablecer.dart';

class RestablecerScreen extends StatelessWidget {
  // 1. Añadimos la variable obligatoria en el constructor
  final String emailUsuario;

  const RestablecerScreen({super.key, required this.emailUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 142, 159, 182),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.reply_rounded, color: Colors.black87, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 80),
              // 2. Le heredamos el correo directamente a la tarjeta interna
              TarjetaRestablecer(emailUsuario: emailUsuario),
            ],
          ),
        ),
      ),
    );
  }
}
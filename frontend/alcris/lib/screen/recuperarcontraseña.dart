import 'package:alcris/widgets/recuperar%20contrase%C3%B1a/tarjetarecuperar.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/recuperar contraseña/tarjetarecuperar.dart';

class RecuperarScreen extends StatelessWidget {
  const RecuperarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B61B4),
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
              const SizedBox(height: 100),
              const TarjetaRecuperar(),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CabeceraAzul extends StatelessWidget {
  final String titulo;
  const CabeceraAzul({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF003366), Color(0xFF0055A5)], begin: Alignment.topCenter),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.card_travel, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Alcris', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Taller automotriz', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              ]),
              ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset('assets/images/logo.jpg', width: 84, height: 84, fit: BoxFit.contain)),
            ],
          ),
          const SizedBox(height: 24),
          Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ],
      ),
    );
  }
}
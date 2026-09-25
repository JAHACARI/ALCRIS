import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final Map<String, dynamic> config;
  const CampoTexto({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(config['label'], style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            child: TextField(
              obscureText: config['obscure'] ?? false,
              decoration: InputDecoration(hintText: config['hint'], hintStyle: const TextStyle(color: Colors.grey, fontSize: 12), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), border: InputBorder.none, suffixIcon: config['suffix']),
            ),
          ),
        ],
      ),
    );
  }
}
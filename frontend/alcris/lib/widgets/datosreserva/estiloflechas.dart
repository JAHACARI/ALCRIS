import 'package:flutter/material.dart';

class BotonFlecha extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const BotonFlecha({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 14, color: const Color(0xFF64748B)),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
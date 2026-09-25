import 'package:flutter/material.dart';

class TarjetaServicio extends StatelessWidget {
  final Map<String, dynamic> datos;
  const TarjetaServicio({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: datos['bg'], borderRadius: BorderRadius.circular(12)),
            child: Icon(datos['icon'], color: datos['color'], size: 22),
          ),
          const SizedBox(height: 12),
          Text(datos['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.bold, height: 1.1)),
          Text(datos['subtitle'], style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Expanded(child: Text(datos['desc'], maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.3))),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today_rounded, size: 14),
              label: const Text('Reservar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.zero),
            ),
          ),
        ],
      ),
    );
  }
}
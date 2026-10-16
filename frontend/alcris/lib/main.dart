import 'package:alcris/screen/splash/pantalla_carga_alcris.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Alcris());
}

class Alcris extends StatelessWidget {
  const Alcris({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaCargaAlcris(),
    );
  }
}

import 'package:alcris/screen/carga.dart';
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
      home: Scaffold(body: Principal()),
    );
  }
}

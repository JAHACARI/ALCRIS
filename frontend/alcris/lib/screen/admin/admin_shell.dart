import 'package:flutter/material.dart';
import 'pagos_page.dart';
import 'servicios_page.dart';

/// Panel administrativo (Pagos Nequi + Servicios y precios).
/// Se abre desde el home cuando el usuario es admin:
///   Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminShell()));
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _i = 0;
  static const _titulos = ['Pagos Nequi', 'Servicios y precios'];
  final _pages = const [PagosPage(), ServiciosPage()];

  @override
  Widget build(BuildContext context) => Theme(
        // Tema propio del panel: no afecta al resto de la app.
        data: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFC8203C), primary: const Color(0xFFC8203C)),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0B2A6B), foregroundColor: Colors.white),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text(_titulos[_i])),
          body: _pages[_i],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _i,
            onDestinationSelected: (v) => setState(() => _i = v),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Pagos'),
              NavigationDestination(icon: Icon(Icons.build_outlined), label: 'Servicios'),
            ],
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'resumen_page.dart';
import 'pagos_page.dart';
import 'reservas_page.dart';
import 'servicios_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _i = 0;

  // 1. Asegúrate de tener los 4 títulos aquí
  static const _titulos = [
    'Resumen',
    'Pagos Nequi',
    'Reservas',
    'Servicios y precios',
  ];

  // 2. Asegúrate de tener las 4 páginas aquí en el mismo orden
  final _pages = const [
    ResumenPage(),
    PagosPage(),
    ReservasPage(),
    ServiciosPage(),
  ];

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC8203C),
            primary: const Color(0xFFC8203C),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: const Color(0xFF0B2A6B),
            foregroundColor: Colors.white,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text(_titulos[_i])),
          body: _pages[_i],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _i,
            onDestinationSelected: (v) => setState(() => _i = v),
            // 3. Tus 4 destinos abajo deben coincidir en cantidad exacta
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                label: 'Resumen',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                label: 'Pagos',
              ),
              NavigationDestination(
                icon: Icon(Icons.event_note_outlined),
                label: 'Reservas',
              ),
              NavigationDestination(
                icon: Icon(Icons.build_outlined),
                label: 'Servicios',
              ),
            ],
          ),
        ),
      );
}
import 'package:flutter/material.dart';
import 'resumen_page.dart';
import 'pagos_page.dart';
import 'reservas_page.dart';
import 'servicios_page.dart';
import 'horarios_page.dart'; // 1. Nueva importación agregada

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _i = 0;

  // 2. Títulos actualizados (5 en total)
  static const _titulos = [
    'Resumen',
    'Pagos Nequi',
    'Reservas',
    'Servicios y precios',
    'Horarios',
  ];

  // 3. Páginas actualizadas en el mismo orden (5 en total)
  final _pages = const [
    ResumenPage(),
    PagosPage(),
    ReservasPage(),
    ServiciosPage(),
    HorariosPage(),
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
            backgroundColor: Color(0xFF0B2A6B),
            foregroundColor: Colors.white,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text(_titulos[_i])),
          // Nota opcional: Cambiar '_pages[_i]' por 'IndexedStack(index: _i, children: _pages)' 
          // evitará que las pestañas se destruyan y recarguen cada vez que cambias de vista.
          body: _pages[_i],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _i,
            onDestinationSelected: (v) => setState(() => _i = v),
            // 4. Destinos actualizados que coinciden en cantidad exacta (5 en total)
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
              NavigationDestination(
                icon: Icon(Icons.schedule),
                label: 'Horarios',
              ),
            ],
          ),
        ),
      );
}

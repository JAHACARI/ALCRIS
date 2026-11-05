import 'package:flutter/material.dart';
import 'package:alcris/screen/auth/login.dart'; // <- pantalla de login (LoginScreen)
import 'resumen_page.dart';
import 'pagos_page.dart';
import 'reservas_page.dart';
import 'servicios_page.dart';
import 'horarios_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _i = 0;

  static const _titulos = [
    'Resumen',
    'Pagos Nequi',
    'Reservas',
    'Servicios y precios',
    'Horarios',
  ];

  final _pages = const [
    ResumenPage(),
    PagosPage(),
    ReservasPage(),
    ServiciosPage(),
    HorariosPage(),
  ];

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      // Aquí limpia tu sesión (SharedPreferences, FirebaseAuth.signOut(), token, etc.)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

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
          appBar: AppBar(
            title: Text(_titulos[_i]),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar sesión',
                onPressed: _cerrarSesion,
              ),
            ],
          ),
          // Nota opcional: cambiar '_pages[_i]' por
          // 'IndexedStack(index: _i, children: _pages)' evita que las
          // pestañas se destruyan y recarguen al cambiar de vista.
          body: _pages[_i],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _i,
            onDestinationSelected: (v) => setState(() => _i = v),
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
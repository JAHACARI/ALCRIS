import 'package:alcris/screen/servicios/servicio.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/common/cabeceraperfil.dart';
import 'package:alcris/widgets/common/menuinf2.dart';
import 'package:alcris/widgets/common/perfil/tarjetausuario.dart';
import 'package:alcris/screen/admin/admin_shell.dart';
import 'package:alcris/widgets/common/perfil/btoncerrar.dart';

// IMPORTS OFICIALES DE TU BACKEND
import 'package:alcris/services/perfil.dart';
import 'package:alcris/models/perfil.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int _currentIndex = 1;

  // Variables para controlar el estado del Backend de forma limpia
  final PerfilService _perfilService = PerfilService();
  PerfilUsuario? _usuario;
  bool _estaCargando = true;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarDatosPerfil();
  }

  // Método asíncrono para gestionar la petición HTTP sin parpadeos de FutureBuilder
  Future<void> _cargarDatosPerfil() async {
    try {
      setState(() {
        _estaCargando = true;
        _mensajeError = null;
      });

      // Petición al servicio (puedes inyectar tu token real de SharedPreferences/SecureStorage)
      final datos = await _perfilService.obtenerPerfil("TU_TOKEN_DE_SESION");

      setState(() {
        _usuario = datos;
        _estaCargando = false;
      });
    } catch (e) {
      setState(() {
        _mensajeError = e.toString().replaceAll('Exception: ', '');
        _estaCargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          const Cabeceraperfil(titulo: 'PERFIL'),
          Expanded(child: _construirContenidoPrincipal()),
        ],
      ),
      bottomNavigationBar: MenuInferior2(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  // Vista estructurada libre de FutureBuilder, cuadritos y tarjetas innecesarias
  Widget _construirContenidoPrincipal() {
    // 1. Estado de carga de la API
    if (_estaCargando) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF0B2A6B),
          strokeWidth: 3,
        ),
      );
    }

    // 2. Estado de error en la red o servidor
    if (_mensajeError != null || _usuario == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 60,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _mensajeError ??
                    'No se pudieron sincronizar los datos con el servidor',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: _cargarDatosPerfil,
                icon: const Icon(Icons.refresh, color: Color(0xFF0B2A6B)),
                label: const Text(
                  'Reintentar',
                  style: TextStyle(
                    color: Color(0xFF0B2A6B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Renderizado de interfaz limpia con Datos Reales
    final usuario = _usuario!;
    return RefreshIndicator(
      onRefresh: _cargarDatosPerfil, // Pull to refresh nativo
      color: const Color(0xFF0B2A6B),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Componente de Perfil con el ID y datos dinámicos mapeados del backend
            TarjetaUsuario(
              nombre: usuario.nombre,
              eslogan: usuario.eslogan,
              localidad: usuario.localidad,
            ),
            const SizedBox(height: 24), // Espaciado elegante e incremental
            // Panel administrativo condicional según respuesta del BACKEND Node.js
            if (usuario.esAdmin) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF3FA), // Círculo azul claro premium
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Color(0xFF0B2A6B),
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Panel Administrativo',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  subtitle: Text(
                    'Gestionar pagos, reservas y precios',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminShell()),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Botón Solicitar Servicio con Degradado Horizontal Fluido
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE94560), Color(0xFFC0392B)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE94560).withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaServicios(),
                  ),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Solicitar Servicio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botón independiente de Salida
            const BotonCerrarSesion(),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alcris/widgets/common/CabeceraServicio.dart';
import 'package:alcris/widgets/common/menuinf2.dart';
import 'package:alcris/widgets/servicios/tarjetaservicio.dart';
import 'package:alcris/widgets/common/perfil/tarjetausuario.dart';
import 'package:alcris/widgets/common/perfil/btoncerrar.dart';
import 'package:alcris/services/api2_servicios.dart';
import 'package:alcris/screen/chat/chat_alcris.dart';
import 'package:alcris/screen/auth/login.dart';
import 'package:alcris/screen/servicios/detallepaquete.dart';

class PantallaServicios extends StatefulWidget {
  const PantallaServicios({super.key});
  @override
  State<PantallaServicios> createState() => _PantallaServiciosState();
}

class _PantallaServiciosState extends State<PantallaServicios> {
  int _currentIndex = 1;

  // Cambia aquí los números por el teléfono real del taller Alcris
  static const String _telefonoMostrar = '3223201720';
  static const String _telefonoLlamada = '+573223201720';

  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _futureServicios;

  @override
  void initState() {
    super.initState();
    _futureServicios = _apiService.obtenerServicios();
  }

  Future<void> _abrirManualPDF() async {
    final Uri pdfUrl = Uri.parse("https://w3.org");

    try {
      if (await canLaunchUrl(pdfUrl)) {
        await launchUrl(pdfUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'No se pudo abrir el visor de documentos';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el manual: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _mostrarContactoTaller() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Contacto del Taller Alcris',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Comunícate con nosotros para soporte o consultas sobre tu vehículo.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94560).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_in_talk_rounded,
                        color: Color(0xFFE94560),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Teléfono del Taller',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(height: 2),
                          Text(
                            _telefonoMostrar,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copiar número',
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: Color(0xFF0B2A6B),
                      ),
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: _telefonoMostrar),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Número copiado al portapapeles'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('tel:$_telefonoLlamada');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  icon: const Icon(Icons.call_rounded, size: 18),
                  label: const Text('Llamar al taller'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2A6B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Map<String, dynamic> _mapearDisenoServicio(
    Map<String, dynamic> servicioBackend,
  ) {
    String nombre = (servicioBackend['nombre'] ?? '').toLowerCase();
    IconData icon = Icons.build_rounded;
    Color color = Colors.blueGrey;
    Color bg = const Color(0xFFECEFF1);

    if (nombre.contains('latonería') || nombre.contains('latoneria')) {
      icon = Icons.build_rounded;
      color = Colors.redAccent;
      bg = const Color(0xFFFFEBEE);
    } else if (nombre.contains('pintura')) {
      icon = Icons.brush_rounded;
      color = Colors.blueAccent;
      bg = const Color(0xFFE3F2FD);
    } else if (nombre.contains('lavado') || nombre.contains('limpieza')) {
      icon = Icons.opacity_rounded;
      color = Colors.cyan;
      bg = const Color(0xFFE0F7FA);
    } else if (nombre.contains('diagnóstico') || nombre.contains('revision')) {
      icon = Icons.search_rounded;
      color = Colors.blueGrey;
      bg = const Color(0xFFECEFF1);
    }

    return {
      'id': servicioBackend['id'],
      'title': servicioBackend['nombre'] ?? 'Servicio Alcris',
      'subtitle': servicioBackend['subtitulo'] ?? 'Calidad Premium',
      'desc': servicioBackend['descripcion'] ?? 'Sin descripción disponible.',
      'precio': servicioBackend['precio_base'] ?? servicioBackend['precio'],
      'icon': icon,
      'color': color,
      'bg': bg,
      'paquetes': servicioBackend['paquetes'] ?? [],
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titulos = ['PERFIL', 'SERVICIOS', 'ASISTENTE CHAT'];
    final bool esChat = _currentIndex == 2;

    return Scaffold(
      backgroundColor: esChat
          ? const Color(0xFF0B1220)
          : const Color(0xFFF7F9FC),
      body: Column(
        children: [
          if (!esChat) CabeceraServicio(titulo: titulos[_currentIndex]),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildVistaPerfil(),
                _buildGridServicios(),
                const ChatAlcris(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuInferior2(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  Widget _buildVistaPerfil() {
    final List<Map<String, dynamic>> guiasSoporte = [
      {
        'id': 'manual',
        'titulo': 'Manual de Usuario',
        'subtitulo': 'Aprende a usar la app y agendar servicios',
        'icono': Icons.menu_book_rounded,
        'color': const Color(0xFF0B2A6B),
      },
      {
        'id': 'contacto',
        'titulo': 'Contacto del Taller',
        'subtitulo': 'Tel: $_telefonoMostrar · Atención y soporte técnico',
        'icono': Icons.support_agent_rounded,
        'color': const Color(0xFFE94560),
      },
    ];
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tarjeta de Usuario
          const TarjetaUsuario(
            nombre: 'User_Name',
            eslogan: 'Cliente registrado en Alcris',
            localidad: 'Localidad',
          ),
          const SizedBox(height: 24),
          // 2. Botón Ver Catálogo
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _currentIndex = 1),
              icon: const Icon(Icons.build_rounded),
              label: const Text('Ver catálogo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B2A6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 3. Botón Cerrar Sesión
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _cerrarSesion,
              icon: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFC0392B),
                size: 20,
              ),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC0392B),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFC0392B), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          // 4. Listado de Documentación
          const Text(
            'Guías y Documentación',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: guiasSoporte.length,
            itemBuilder: (context, index) {
              final item = guiasSoporte[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icono'],
                        color: item['color'],
                        size: 22,
                      ),
                    ),
                    title: Text(
                      item['titulo'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item['subtitulo'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () {
                      if (item['id'] == 'manual') {
                        _abrirManualPDF();
                      } else if (item['id'] == 'contacto') {
                        _mostrarContactoTaller();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridServicios() {
    return FutureBuilder<List>(
      future: _futureServicios,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0B2A6B)),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Error al cargar servicios: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureServicios = _apiService.obtenerServicios();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        final servicios = snapshot.data ?? [];
        if (servicios.isEmpty) {
          return const Center(
            child: Text('No hay servicios disponibles en este momento.'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _futureServicios = _apiService.obtenerServicios();
            });
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: servicios.length,
            itemBuilder: (context, index) {
              final item = _mapearDisenoServicio(servicios[index]);
              return TarjetaServicio(
                datos: item,
                onReservar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleServicioScreen(servicio: item),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

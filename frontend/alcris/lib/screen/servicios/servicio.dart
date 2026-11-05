import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Paquete para abrir el PDF
import 'package:alcris/widgets/common/CabeceraServicio.dart';
import 'package:alcris/widgets/common/menuinf2.dart';
import 'package:alcris/widgets/servicios/tarjetaservicio.dart';
import 'package:alcris/widgets/common/perfil/tarjetausuario.dart';
import 'package:alcris/widgets/common/perfil/btoncerrar.dart';
import 'package:alcris/services/api2_servicios.dart';
import 'package:alcris/screen/chat/chat_alcris.dart';
import 'package:alcris/screen/auth/login.dart';

// Importación unificada de la pantalla de servicios
import 'package:alcris/screen/servicios/detallepaquete.dart';

class PantallaServicios extends StatefulWidget {
  const PantallaServicios({super.key});
  @override
  State<PantallaServicios> createState() => _PantallaServiciosState();
}

class _PantallaServiciosState extends State<PantallaServicios> {
  int _currentIndex = 1;

  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _futureServicios;

  @override
  void initState() {
    super.initState();
    _futureServicios = _apiService.obtenerServicios();
  }

  // 📄 FUNCIÓN EXCLUSIVA: Abre el archivo PDF del manual de forma externa en el dispositivo
  Future<void> _abrirManualPDF() async {
    // Reemplaza esta URL de prueba por el enlace final de tu PDF (subido a tu hosting, drive, etc.)
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
        'id': 'faq',
        'titulo': 'Preguntas Frecuentes',
        'subtitulo': 'Dudas sobre tiempos, precios y garantías',
        'icono': Icons.help_outline_rounded,
        'color': Colors.blueGrey,
      },
      {
        'id': 'contacto',
        'titulo': 'Contacto del Taller',
        'subtitulo': 'Información de atención y soporte técnico',
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
                      // 🔥 Ejecuta de verdad la apertura del PDF si pulsa sobre el manual
                      if (item['id'] == 'manual') {
                        _abrirManualPDF();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Abriendo de forma estática: ${item['titulo']}',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
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
    return FutureBuilder<List<dynamic>>(
      future: _futureServicios,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Error al conectar con Alcris Backend:\n${snapshot.error}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          final datosBackend = snapshot.data!;
          if (datosBackend.isEmpty) {
            return const Center(
              child: Text("No hay servicios disponibles en el catálogo."),
            );
          }
          final List<Map<String, dynamic>> serviciosFormateados = datosBackend
              .map(
                (s) =>
                    _mapearDisenoServicio(Map<String, dynamic>.from(s as Map)),
              )
              .toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nuestros servicios',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${serviciosFormateados.length} disponibles',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: serviciosFormateados.length,
                  itemBuilder: (context, index) {
                    final item = serviciosFormateados[index];
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
              ],
            ),
          );
        }
        return const Center(child: Text("No se pudieron mapear los módulos."));
      },
    );
  }
}

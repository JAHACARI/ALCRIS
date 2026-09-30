import 'package:flutter/material.dart';
import 'package:alcris/widgets/servicios/cabeceraazul.dart';
import 'package:alcris/widgets/menuinferior.dart';
import 'package:alcris/widgets/servicios/tarjetaservicio.dart';
import 'package:alcris/screen/detallepaquete.dart';
import 'package:alcris/widgets/perfil/tarjetaseguridad.dart';
import 'package:alcris/widgets/perfil/tarjetausuario.dart';
import 'package:alcris/widgets/perfil/botonperfil.dart';
import 'package:alcris/widgets/perfil/filaestadisticas.dart';

// 1. IMPORTA TU SERVICIO DE CONEXIÓN
import 'package:alcris/services/api2_servicios.dart';

class PantallaServicios extends StatefulWidget {
  const PantallaServicios({super.key});
  @override
  State<PantallaServicios> createState() => _PantallaServiciosState();
}

class _PantallaServiciosState extends State<PantallaServicios> {
  int _currentIndex =
      1; // Empezamos en la pestaña de servicios (index 1) para ver la carga

  // 2. INSTANCIAMOS EL SERVICIO DE LA API Y EL FUTURE
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _futureServicios;

  @override
  void initState() {
    super.initState();
    // 3. LLAMAMOS AL BACKEND AL INICIAR LA PANTALLA
    _futureServicios = _apiService.obtenerServicios();
  }

  // 4. FUNCIÓN AUXILIAR PARA ASIGNAR DISEÑO SEGÚN LO QUE VENGA DE LA BASE DE DATOS
  Map<String, dynamic> _mapearDisenoServicio(
    Map<String, dynamic> servicioBackend,
  ) {
    String nombre = (servicioBackend['nombre'] ?? '').toLowerCase();

    // Valores por defecto si la base de datos no coincide
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
      'id': servicioBackend['id'], // Importante para cuando hagas la reserva
      'title': servicioBackend['nombre'] ?? 'Servicio Alcris',
      'subtitle': servicioBackend['subtitulo'] ?? 'Calidad Premium',
      'desc': servicioBackend['descripcion'] ?? 'Sin descripción disponible.',
      'precio': servicioBackend['precio'], // Campo nuevo de tu backend
      'icon': icon,
      'color': color,
      'bg': bg,
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titulos = [
      'PERFIL',
      'SERVICIOS',
      'ASISTENTE CHAT',
      'CONFIGURACIÓN',
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          CabeceraAzul(titulo: titulos[_currentIndex]),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildVistaPerfil(),
                _buildGridServicios(), // Esta vista ahora consumirá datos reales
                _buildPlaceholder('Chatbot IA de Alcris'),
                _buildPlaceholder('Ajustes del Sistema'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuInferior(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  Widget _buildVistaPerfil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const TarjetaUsuario(
            nombre: 'User_Name',
            eslogan: 'Cliente registrado en Alcris',
            localidad: 'Localidad',
          ),
          const SizedBox(height: 16),
          const FilaEstadisticas(),
          const SizedBox(height: 16),
          const TarjetaSeguridad(
            titulo: 'Name_Card',
            subtitulo: 'crea una nueva contraseña segura',
          ),
          const SizedBox(height: 28),
          BotonPerfil(onPressed: () => setState(() => _currentIndex = 1)),
        ],
      ),
    );
  }

  // 5. MODIFICAMOS EL DIV DE SERVICIOS PARA USAR EL FUTUREBUILDER
  Widget _buildGridServicios() {
    return FutureBuilder<List<dynamic>>(
      future: _futureServicios,
      builder: (context, snapshot) {
        // A. Mientras el backend responde, muestra un indicador de carga redondo
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
          );
        }

        // B. Si el backend falló o está apagado
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

        // C. Éxito: Cuando el JSON llega correctamente
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nuestros servicios',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Reserva en línea',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.64,
                  children: serviciosFormateados
                      .map(
                        (s) => TarjetaServicio(
                          datos: s,
                          onReservar: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleServicioScreen(servicio: s),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text("No se encontraron servicios."));
      },
    );
  }

  Widget _buildPlaceholder(String msg) => Center(
    child: Text(
      msg,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

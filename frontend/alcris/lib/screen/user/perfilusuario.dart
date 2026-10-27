import 'package:alcris/screen/servicios/servicio.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/common/cabeceraperfil.dart';
import 'package:alcris/widgets/common/menuinf2.dart';
import 'package:alcris/widgets/perfil/tarjetaestadistica.dart';
import 'package:alcris/widgets/perfil/tarjetaseguridad.dart';
import 'package:alcris/widgets/perfil/tarjetausuario.dart';
import 'package:alcris/screen/admin/admin_shell.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  int _currentIndex = 1; 
  // 1. Cambiamos a true para que el botón sea visible
  bool esAdmin = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          const Cabeceraperfil(titulo: 'PERFIL'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Componente del Perfil de Usuario
                  const TarjetaUsuario(
                    nombre: 'User_Name',
                    eslogan: 'Cliente registrado en Alcris',
                    localidad: 'Localidad',
                  ),
                  const SizedBox(height: 16),

                  // 2. Fila de Contadores Estadísticos
                  const Row(
                    children: [
                      Expanded(child: TarjetaEstadistica(numero: '8', etiqueta: 'Servicios')),
                      SizedBox(width: 12),
                      Expanded(child: TarjetaEstadistica(numero: '2', etiqueta: 'Pendientes')),
                      SizedBox(width: 12),
                      Expanded(child: TarjetaEstadistica(numero: '8', etiqueta: 'Servicios')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. Componente de Seguridad de Contraseña
                  const TarjetaSeguridad(
                    titulo: 'Name_Card',
                    subtitulo: 'crea una nueva contraseña segura',
                  ),
                  const SizedBox(height: 16),

                  // 4. Panel administrativo (Diseño mejorado tipo tarjeta)
                  if (esAdmin) ...[
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B2A6B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.admin_panel_settings, color: Color(0xFF0B2A6B)),
                        ),
                        title: const Text(
                          'Panel Administrativo', 
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        subtitle: const Text('Gestionar pagos, reservas y precios'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminShell()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 5. Botón Solicitar Servicio con Degradado Lineal
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE94560), Color(0xFFC0392B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4))
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: ()  => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PantallaServicios(),
                          ),
                          (route) => false,
                        ), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Solicitar Servicio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
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
}
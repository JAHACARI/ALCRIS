import 'package:flutter/material.dart';
import 'package:alcris/screen/servicio.dart';
import 'package:alcris/screen/verificarcuenta.dart';
import 'package:alcris/widgets/cabeceraregistro.dart';

// Importación de los nuevos componentes modulares aislados
import 'package:alcris/widgets/login/bloquesocial.dart';
import 'package:alcris/widgets/login/enlaceregistro.dart';
import 'package:alcris/widgets/login/formulariologin.dart';

// Capa de infraestructura
import 'package:alcris/services/api3_verifycuenta.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _ocultarContrasena = true;

  // Controladores de búfer para inyección y captura de texto
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Pipeline asíncrono para la verificación de credenciales en Node.js
  Future<void> _procesarLogin() async {
    final correo = _correoController.text.trim();
    final password = _passwordController.text;

    if (correo.isEmpty || password.isEmpty) {
      _mostrarAlerta('Por favor, ingresa tu correo y contraseña.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      ),
    );

    try {
      final respuesta = await _apiService.iniciarSesion(
        email: correo,
        contrasena: password,
      );

      if (mounted) Navigator.pop(context);

      _mostrarAlerta(respuesta['message'] ?? '¡Login exitoso!');

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PantallaServicios()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      
      final String mensajeError = e.toString().replaceAll('Exception: ', '');

      // Redirección forzada hacia la verificación si el backend responde con error de activación (403)
      if (mensajeError.contains('verificar') || mensajeError.contains('403')) {
        _mostrarAlerta('Debes verificar tu cuenta primero.');
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificarCuentaScreen(email: correo),
            ),
          );
        }
      } else {
        _mostrarAlerta(mensajeError);
      }
    }
  }

  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> camposLogin = [
      {
        'label': 'usuario o correo',
        'hint': 'CORREO@gmail.com',
        'labelcolor': Colors.white,
        'controller': _correoController,
      },
      {
        'label': 'contraseña',
        'hint': '********',
        'labelcolor': Colors.white,
        'obscure': _ocultarContrasena,
        'controller': _passwordController,
        'suffix': IconButton(
          icon: Icon(
            _ocultarContrasena
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 18,
            color: Colors.grey.shade600,
          ),
          onPressed: () => setState(() => _ocultarContrasena = !_ocultarContrasena),
        ),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CabeceraRegistro(titulo: 'Inicia Sesión'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    'Unete a nuestro mundo hoy',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 20),
                  
                  // Componente 1: Bloque de Inputs y acciones de credenciales
                  FormularioLogin(
                    campos: camposLogin,
                    onLoginPressed: _procesarLogin,
                  ),
                  
                  // Componente 2: Separador e inicios alternativos (Oauth2)
                  BloqueSocial(
                    onGoogleTap: () {},
                  ),
                  const SizedBox(height: 24),
                  
                  // Componente 3: Enlace plano inferior
                  const EnlaceRegistro(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
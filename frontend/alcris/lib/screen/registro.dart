import 'package:alcris/screen/verificarcuenta.dart';
import 'package:flutter/material.dart';
import 'package:alcris/screen/login.dart';
import 'package:alcris/widgets/cabeceraregistro.dart';

// Importación de los componentes modulares en archivos independientes
import 'package:alcris/widgets/registro/botoncrear.dart';
import 'package:alcris/widgets/registro/enlacelogin.dart';
import 'package:alcris/widgets/registro/formulario.dart';

// Conexión con el servicio de infraestructura de la API
import 'package:alcris/services/api3_verifycuenta.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool _acepto = false, _ocultar = true;

  // 1. Controladores completos exigidos por el pipeline del Backend
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController(); // 👈 NUEVO
  final TextEditingController _localidadController = TextEditingController(); // 👈 NUEVO
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmarPasswordController = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    // Liberación estricta de memoria para prevenir fugas (Memory Leaks)
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose(); // 👈 NUEVO
    _localidadController.dispose(); // 👈 NUEVO
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  // Método centralizado para la orquestación y validación del pipeline de registro
  Future<void> _procesarRegistro() async {
    // 1. Validación de nulidad en campos obligatorios (incluyendo teléfono y localidad)
    if (_nombreController.text.trim().isEmpty ||
        _correoController.text.trim().isEmpty ||
        _telefonoController.text.trim().isEmpty || // 👈 NUEVO
        _localidadController.text.trim().isEmpty || // 👈 NUEVO
        _passwordController.text.trim().isEmpty ||
        _confirmarPasswordController.text.trim().isEmpty) {
      _mostrarAlerta('Por favor, llena todos los campos obligatorios.');
      return;
    }

    // 2. Validación de consistencia criptográfica local (Contraseñas idénticas)
    if (_passwordController.text != _confirmarPasswordController.text) {
      _mostrarAlerta('Las contraseñas no coinciden.');
      return;
    }

    // 3. Validación de restricciones legales de negocio (Términos aceptados)
    if (!_acepto) {
      _mostrarAlerta('Debes aceptar los términos y condiciones para continuar.');
      return;
    }

    // 4. Inyección del indicador de progreso asíncrono bloqueante
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      ),
    );

  try {
      // 5. Consumo del endpoint enviando los datos reales del usuario
      await _apiService.registrarUsuario(
        nombre: _nombreController.text.trim(),
        email: _correoController.text.trim(),
        contrasena: _passwordController.text,
        telefono: _telefonoController.text.trim(),
        localidad: _localidadController.text.trim(),
      );

      if (mounted) Navigator.pop(context); // Desmontar Loader

      _mostrarAlerta('¡Cuenta creada! Por favor introduce tu código de verificación.');

      // 👇 NAVEGACIÓN MODIFICADA: Enrutamos pasándole el correo electrónico capturado
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerificarCuentaScreen(
              email: _correoController.text.trim(),
            ),
          ),
        );
      }

      // Desmontaje seguro del Loader
      if (mounted) Navigator.pop(context);

      _mostrarAlerta('¡Cuenta creada con éxito! Por favor inicia sesión.');

      // Enrutamiento limpio hacia la raíz de autenticación sin persistencia de historial
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      // Gestión y encapsulamiento de excepciones controladas del servidor
      if (mounted) Navigator.pop(context);
      _mostrarAlerta(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Capa visual abstracta para el despliegue instantáneo de notificaciones efímeras
  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    // Diccionario de configuración inyectado con los nuevos campos integrados
    final List<Map<String, dynamic>> campos = [
      {
        'label': 'Nombre completo',
        'hint': 'Tu nombre...',
        'controller': _nombreController,
      },
      {
        'label': 'Correo electrónico',
        'hint': 'CORREO@gmail.com',
        'controller': _correoController,
      },
      {
        'label': 'Teléfono celular', // 👈 NUEVO CAMPOS EN UI
        'hint': 'Ej: 3123456789',
        'controller': _telefonoController,
      },
      {
        'label': 'Localidad / Ciudad', // 👈 NUEVO CAMPOS EN UI
        'hint': 'Tu ubicación actual...',
        'controller': _localidadController,
      },
      {
        'label': 'Contraseña',
        'hint': '*********',
        'obscure': _ocultar,
        'controller': _passwordController,
        'suffix': IconButton(
          icon: Icon(
            _ocultar ? Icons.visibility_off : Icons.visibility,
            size: 18,
          ),
          onPressed: () => setState(() => _ocultar = !_ocultar),
        ),
      },
      {
        'label': 'Confirmar contraseña',
        'hint': '*********',
        'obscure': true,
        'controller': _confirmarPasswordController,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CabeceraRegistro(titulo: 'Crear Cuenta'),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Únete a nuestro mundo hoy',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Componente 1: Formulario estructural con soporte dinámico para los 6 inputs
                  FormularioRegistro(
                    campos: campos,
                    aceptoValue: _acepto,
                    onAceptoChanged: (v) => setState(() => _acepto = v),
                  ),
                  const SizedBox(height: 24),
                  // Componente 2: Botón con gradiente de acción centralizada
                  BotonCrearCuenta(onPressed: _procesarRegistro),
                  const SizedBox(height: 16),
                  // Componente 3: Link inferior plano estático
                  const EnlaceLogin(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
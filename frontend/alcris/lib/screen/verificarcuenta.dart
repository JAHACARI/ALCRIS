import 'package:flutter/material.dart';
import 'package:alcris/screen/login.dart';
import 'package:alcris/services/api3_verifycuenta.dart';

class VerificarCuentaScreen extends StatefulWidget {
  final String email; // Recibe el email desde el registro para procesar la petición

  const VerificarCuentaScreen({super.key, required this.email});

  @override
  State<VerificarCuentaScreen> createState() => _VerificarCuentaScreenState();
}

class _VerificarCuentaScreenState extends State<VerificarCuentaScreen> {
  final TextEditingController _codigoController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _estaCargando = false;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  // Lógica para consumir la verificación del Backend
  Future<void> _enviarVerificacion() async {
    final codigo = _codigoController.text.trim();

    if (codigo.isEmpty || codigo.length < 6) {
      _mostrarSnackBar('Por favor, ingresa el código completo de 6 dígitos.');
      return;
    }

    setState(() => _estaCargando = true);

    try {
      final resultado = await _apiService.verificarCuenta(
        email: widget.email,
        codigo: codigo,
      );

      _mostrarSnackBar(resultado['message'] ?? '¡Cuenta verificada con éxito!');

      if (mounted) {
        // Redirección directa hacia el Login de forma limpia
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _mostrarSnackBar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _estaCargando = false);
    }
  }

  // Lógica para solicitar un nuevo código de validación
  Future<void> _solicitarReenvio() async {
    try {
      final resultado = await _apiService.reenviarCodigoVerificacion(email: widget.email);
      
      // Si el correo falló en desarrollo, tu backend devuelve un codigo_debug de auxilio
      String mensaje = resultado['message'] ?? 'Código reenviado.';
      if (resultado.containsKey('codigo_debug')) {
        mensaje += " (Código de desarrollo: ${resultado['codigo_debug']})";
      }
      
      _mostrarSnackBar(mensaje);
    } catch (e) {
      _mostrarSnackBar(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verificar Cuenta', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFC0392B),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.mark_email_read_rounded, size: 80, color: Color(0xFFE94560)),
            const SizedBox(height: 24),
            const Text(
              'Confirmación de Correo',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 10),
            Text(
              'Hemos enviado un código de seguridad de 6 dígitos a la dirección:\n${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 36),
            
            // Input de inserción numérica del código
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _codigoController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                decoration: const InputDecoration(
                  counterText: "", // Oculta el contador de caracteres por defecto
                  hintText: "000000",
                  hintStyle: TextStyle(color: Colors.grey, letterSpacing: 8),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón de Envío Dinámico
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _estaCargando ? null : _enviarVerificacion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC0392B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _estaCargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirmar Código', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),

            // Enlace de reenvío interactivo
            TextButton(
              onPressed: _solicitarReenvio,
              child: const Text(
                '¿No recibiste el código? Solicitar uno nuevo',
                style: TextStyle(color: Color(0xFFE94560), fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
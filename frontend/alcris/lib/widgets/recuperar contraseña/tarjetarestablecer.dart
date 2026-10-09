import 'package:flutter/material.dart';
import 'package:alcris/services/api5_restablecercontraseña.dart'; 
import 'package:alcris/widgets/recuperar contraseña/barrafortaleza.dart';
import 'package:alcris/widgets/recuperar contraseña/botondegradado.dart';

class TarjetaRestablecer extends StatefulWidget {
  // Pasamos el email desde la pantalla anterior para cumplir el req.body.email del backend
  final String emailUsuario;

  const TarjetaRestablecer({super.key, required this.emailUsuario});

  @override
  State<TarjetaRestablecer> createState() => _TarjetaRestablecerState();
}

class _TarjetaRestablecerState extends State<TarjetaRestablecer> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final ApiService _apiService = ApiService(); // Instanciamos tu servicio aislado
  
  String _codigoDigitado = '';
  bool _ocultarNueva = true;
  bool _ocultarConfirmar = true;
  bool _estaCargando = false;

  void _enviarNuevaContrasena() async {
    final nueva = _passController.text.trim();
    final confirmar = _confirmPassController.text.trim();

    // 1. Validaciones locales en Flutter
    if (_codigoDigitado.length < 6) {
      _alerta('Por favor, completa los 6 dígitos del código.'); 
      return;
    }
    if (nueva.length < 6) {
      _alerta('La contraseña debe tener mínimo 6 caracteres.'); 
      return;
    }
    if (nueva != confirmar) {
      _alerta('Las contraseñas no coinciden.'); 
      return;
    }

    setState(() => _estaCargando = true);

    // 2. Consumo del servicio conectado al Backend
    final resultado = await _apiService.restablecerContrasena(
      email: widget.emailUsuario,
      codigo: _codigoDigitado,
      nuevaContrasena: nueva,
    );

    if (!mounted) return;
    setState(() => _estaCargando = false);

    // 3. Respuesta visual según el resultado
    if (resultado['exito'] == true) {
      _alerta(resultado['mensaje'], ok: true);
      
      // Retraso para que el usuario logre leer el SnackBar de éxito antes de regresar
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    } else {
      // Muestra los errores del controlador del backend (ej: "Código inválido o expirado")
      _alerta(resultado['mensaje']);
    }
  }

  void _alerta(String msg, {bool ok = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ok ? Colors.green : Colors.redAccent, 
        content: Text(msg),
        duration: const Duration(seconds: 2),
      )
    );
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFF8), 
        borderRadius: BorderRadius.circular(24), 
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 6))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10), 
              decoration: BoxDecoration(color: const Color(0xFFF3A3B1), borderRadius: BorderRadius.circular(12)), 
              child: const Icon(Icons.lock_open_rounded, color: Color(0xFF0F172A), size: 24)
            ),
            const SizedBox(width: 14),
            const Expanded(child: Text('Nueva\ncontraseña', style: TextStyle(color: Color(0xFF003366), fontSize: 22, fontWeight: FontWeight.bold, height: 1.1))),
          ]),
          const SizedBox(height: 12),
          const Text('crea una nueva contraseña segura', style: TextStyle(color: Color(0xFF003366), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Mapea los cambios en caliente de los 6 cuadros grises superiores
          BarraFortaleza(onCodigoCompleto: (val) => _codigoDigitado = val),
          const SizedBox(height: 24),

          const Text('Nueva contraseña', style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildInput(
            controller: _passController, 
            obscure: _ocultarNueva,
            suffix: IconButton(
              icon: Icon(_ocultarNueva ? Icons.visibility_off : Icons.visibility, size: 18), 
              onPressed: () => setState(() => _ocultarNueva = !_ocultarNueva)
            ),
          ),
          const SizedBox(height: 16),

          const Text('Confirmar contraseña', style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildInput(
            controller: _confirmPassController, 
            obscure: _ocultarConfirmar,
            suffix: IconButton(
              icon: Icon(_ocultarConfirmar ? Icons.visibility_off : Icons.visibility, size: 18), 
              onPressed: () => setState(() => _ocultarConfirmar = !_ocultarConfirmar)
            ),
          ),
          const SizedBox(height: 28),

          _estaCargando 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFE94560)))
              : BotonDegradado(texto: 'restablecer contraseña', onPressed: _enviarNuevaContrasena),
        ],
      ),
    );
  }

  Widget _buildInput({required TextEditingController controller, required bool obscure, required Widget suffix}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller, 
        obscureText: obscure,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF0D2C59)), 
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(vertical: 14), 
          suffixIcon: suffix
        ),
      ),
    );
  }
}
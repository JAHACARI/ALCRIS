import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alcris/widgets/recuperar contraseña/barrafortaleza.dart';
import 'package:alcris/widgets/recuperar contraseña/botondegradado.dart';

class TarjetaRestablecer extends StatefulWidget {
  const TarjetaRestablecer({super.key});
  @override
  State<TarjetaRestablecer> createState() => _TarjetaRestablecerState();
}

class _TarjetaRestablecerState extends State<TarjetaRestablecer> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  
  String _codigoDigitado = '';
  bool _ocultarNueva = true;
  bool _ocultarConfirmar = true;
  bool _estaCargando = false;

  void _enviarNuevaContrasena() async {
    final nueva = _passController.text;
    if (_codigoDigitado.length < 6) {
      _alerta('Por favor, completa los 6 dígitos del código.'); return;
    }
    if (nueva.length < 6) {
      _alerta('La contraseña debe tener mínimo 6 caracteres.'); return;
    }
    if (nueva != _confirmPassController.text) {
      _alerta('Las contraseñas no coinciden.'); return;
    }

    setState(() => _estaCargando = true);
    try {
      final url = Uri.parse('http://10.0.2'); 
      final res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': _codigoDigitado, 'password': nueva}),
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        _alerta(data['message'] ?? 'Contraseña restablecida', ok: true);
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        _alerta(data['message'] ?? 'Error al actualizar');
      }
    } catch (e) {
      _alerta('Error de red: No se pudo conectar al servidor.');
    } finally {
      setState(() => _estaCargando = false);
    }
  }

  void _alerta(String msg, {bool ok = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: ok ? Colors.green : Colors.redAccent, content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(color: const Color(0xFFEAEFF8), borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF3A3B1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.lock_open_rounded, color: Color(0xFF0F172A), size: 24)),
            const SizedBox(width: 14),
            const Expanded(child: Text('Nueva\ncontraseña', style: TextStyle(color: Color(0xFF003366), fontSize: 22, fontWeight: FontWeight.bold, height: 1.1))),
          ]),
          const SizedBox(height: 12),
          const Text('crea una nueva contraseña segura', style: TextStyle(color: Color(0xFF003366), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Captura los 6 números digitados en tiempo real dentro del callback
          BarraFortaleza(onCodigoCompleto: (val) => _codigoDigitado = val),
          const SizedBox(height: 24),

          const Text('Nueva contraseña', style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildInput(
            controller: _passController, obscure: _ocultarNueva,
            suffix: IconButton(icon: Icon(_ocultarNueva ? Icons.visibility_off : Icons.visibility, size: 18), onPressed: () => setState(() => _ocultarNueva = !_ocultarNueva)),
          ),
          const SizedBox(height: 16),

          const Text('Confirmar contraseña', style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _buildInput(
            controller: _confirmPassController, obscure: _ocultarConfirmar,
            suffix: IconButton(icon: Icon(_ocultarConfirmar ? Icons.visibility_off : Icons.visibility, size: 18), onPressed: () => setState(() => _ocultarConfirmar = !_ocultarConfirmar)),
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
        controller: controller, obscureText: obscure,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF0D2C59)), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 14), suffixIcon: suffix),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:alcris/services/api4_recuperarcontrasena.dart';
import 'package:alcris/screen/restablecercontrasena.dart';
import 'package:alcris/widgets/recuperar contraseña/botondegradado.dart'; // Importación de tu botón reutilizable

class TarjetaRecuperar extends StatefulWidget {
  const TarjetaRecuperar({super.key});

  @override
  State<TarjetaRecuperar> createState() => _TarjetaRecuperarState();
}

class _TarjetaRecuperarState extends State<TarjetaRecuperar> {
  final TextEditingController _emailController = TextEditingController();
  bool _estaCargando = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _esCorreoValido(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  void _procesarEnvio() async {
    final emailIngresado = _emailController.text.trim(); 

    if (emailIngresado.isEmpty || !_esCorreoValido(emailIngresado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent, 
          content: Text('Por favor, ingresa un correo electrónico válido.'),
        ),
      );
      return;
    }

    setState(() => _estaCargando = true);

    final resultado = await ApiService.enviarCodigoRecuperacion(emailIngresado);

    setState(() => _estaCargando = false);

    if (resultado['exito']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text(resultado['mensaje'])),
      );
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RestablecerScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.redAccent, content: Text(resultado['mensaje'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFF8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF3A3B1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.lock_rounded, color: Color(0xFF0F172A), size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('¿olvidaste tú\ncontraseña?', style: TextStyle(color: Color(0xFF003366), fontSize: 24, fontWeight: FontWeight.bold, height: 1.1)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('No te preocupes, te enviaremos intrucciones para recuperarla', style: TextStyle(color: Color(0xFF003366), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('correo electrónico', style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: _emailController, // SOLUCIÓN: Controlador nativo conectado para capturar el texto
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'tvm646967@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.email_outlined, color: Colors.black87, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          
          // Implementación limpia de tu widget BotonDegradado con indicador de carga integrado
          _estaCargando
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFE94560)))
              : BotonDegradado(
                  texto: 'enviar código',
                  onPressed: _procesarEnvio,
                ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(text: 'Volver al '),
                  TextSpan(text: 'inicio de sesión', style: TextStyle(color: Color(0xFFE94560), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
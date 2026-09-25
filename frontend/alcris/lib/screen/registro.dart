import 'package:alcris/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:alcris/screen/servicio.dart'; 
import 'package:alcris/widgets/cabeceraregistro.dart';
import 'package:alcris/widgets/camposdetexto.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool _acepto = false, _ocultar = true;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> campos = [
      {'label': 'Nombre completo', 'hint': 'Tu nombre...'},
      {'label': 'Correo electrónico', 'hint': 'CORREO@gmail.com'},
      {
        'label': 'Contraseña',
        'hint': '*********',
        'obscure': _ocultar,
        'suffix': IconButton(
          icon: Icon(
            _ocultar ? Icons.visibility_off : Icons.visibility,
            size: 18,
          ),
          onPressed: () => setState(() => _ocultar = !_ocultar),
        ),
      },
      {'label': 'Confirmar contraseña', 'hint': '*********', 'obscure': true},
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
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ...campos.map((c) => CampoTexto(config: c)),
                        Row(
                          children: [
                            Checkbox(
                              value: _acepto,
                              activeColor: Colors.redAccent,
                              onChanged: (v) => setState(() => _acepto = v ?? false),
                            ),
                            const Text(
                              'Acepto los ',
                              style: TextStyle(fontSize: 12),
                            ),
                            const Text(
                              'términos y condiciones',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE94560),
                          Color(0xFFC0392B),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Crear Cuenta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón inferior configurado para ir al Login
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                        children: [
                          TextSpan(text: '¿Ya tienes cuenta? \n'),
                          TextSpan(
                            text: 'inicia sesión aquí',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

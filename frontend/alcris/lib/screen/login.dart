import 'package:flutter/material.dart';
import 'package:alcris/screen/servicio.dart';
import 'package:alcris/screen/registro.dart';
// Importamos de manera limpia todos tus componentes de la carpeta widgets
import 'package:alcris/widgets/cabeceraregistro.dart';
import 'package:alcris/widgets/camposdetexto.dart';
import 'package:alcris/widgets/login/botonsocial.dart';
import 'package:alcris/widgets/login/botonlogin.dart';
import 'package:alcris/widgets/login/logincard.dart';
import 'package:alcris/widgets/login/loginseparador.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _ocultarContrasena = true;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> camposLogin = [
      {'label': 'usuario o correo', 'hint': 'User Name',
      'labelcolor': Colors.white},
      {
        
        'label': 'contraseña',
        'hint': '********',
        'labelcolor': Colors.white,
        'obscure': _ocultarContrasena,
        'suffix': IconButton(
          icon: Icon(_ocultarContrasena ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: Colors.grey.shade600),
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
                  const Text('Unete a nuestro mundo hoy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                  const SizedBox(height: 20),
                  
                  LoginCard(
                    children: [
                      const Center(
                        child: Text('LOGIN', style: TextStyle(color: Color(0xFFE94560), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 20),
                      ...camposLogin.map((c) => CampoTexto(config: c)),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text('OLVIDASTE TU CONTRASEÑA?', style: TextStyle(color: Color(0xFFE94560), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      LoginBoton(
                        onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const PantallaServicios()), (route) => false),
                      ),
                      const SizedBox(height: 24),
                      const LoginSeparador(),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(child: BotonSocial(icon: Icons.g_mobiledata_rounded, label: 'Google', iconColor: Colors.black87, onTap: () {})),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistroScreen())),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                        children: [
                          TextSpan(text: '¿No tienes cuenta?  '),
                          TextSpan(text: 'Crea una', style: TextStyle(color: Color(0xFFE94560), fontWeight: FontWeight.bold)),
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
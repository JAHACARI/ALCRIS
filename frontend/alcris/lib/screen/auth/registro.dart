import 'package:alcris/screen/auth/verificarcuenta.dart';
import 'package:flutter/material.dart';
import 'package:alcris/screen/auth/login.dart';
import 'package:alcris/widgets/common/cabeceraregistro.dart';
import 'package:alcris/screen/home.dart';
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

  // Reglas de la contraseña
  bool get _tieneMinimo6 => _passwordController.text.length >= 6;
  bool get _tieneMayuscula =>
      _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _tieneSimbolo =>
      _passwordController.text.contains(RegExp(r'[^A-Za-z0-9]'));
  bool get _contrasenaValida =>
      _tieneMinimo6 && _tieneMayuscula && _tieneSimbolo;

  // 1. Controladores completos exigidos por el pipeline del Backend
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _localidadController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmarPasswordController =
      TextEditingController();

  final ApiService _apiService = ApiService();

  // 2. Lista oficial de los municipios del departamento del Huila
  final List<String> _municipiosHuila = [
    'Acevedo',
    'Agrado',
    'Aipe',
    'Algeciras',
    'Altamira',
    'Baraya',
    'Campoalegre',
    'Colombia',
    'Elías',
    'Garzón',
    'Gigante',
    'Guadalupe',
    'Hobo',
    'Íquira',
    'Isnos',
    'La Argentina',
    'La Plata',
    'Nátaga',
    'Neiva',
    'Oporapa',
    'Paicol',
    'Palermo',
    'Palestina',
    'Pital',
    'Pitalito',
    'Rivera',
    'Saladoblanco',
    'San Agustín',
    'Santa María',
    'Suaza',
    'Tarqui',
    'Tello',
    'Teruel',
    'Tesalia',
    'Timaná',
    'Villavieja',
    'Yaguará',
  ];

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _localidadController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  // 3. Función que despliega la lista desde abajo con buscador en tiempo real
  void _mostrarSelectorMunicipios() {
    List<String> municipiosFiltrados = List.from(_municipiosHuila);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona tu municipio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar municipio del Huila...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (textoBusqueda) {
                      setModalState(() {
                        municipiosFiltrados = _municipiosHuila
                            .where(
                              (m) => m.toLowerCase().contains(
                                textoBusqueda.toLowerCase(),
                              ),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: municipiosFiltrados.length,
                      itemBuilder: (context, index) {
                        final municipio = municipiosFiltrados[index];
                        final isSelected =
                            _localidadController.text == municipio;

                        return ListTile(
                          title: Text(
                            municipio,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.redAccent
                                  : Colors.black87,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.redAccent,
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          onTap: () {
                            setState(() {
                              _localidadController.text = municipio;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

    Future<void> _procesarRegistro() async {
    if (_nombreController.text.trim().isEmpty ||
        _correoController.text.trim().isEmpty ||
        _telefonoController.text.trim().isEmpty ||
        _localidadController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmarPasswordController.text.trim().isEmpty) {
      _mostrarAlerta('Por favor, llena todos los campos obligatorios.');
      return;
    }

    if (!_contrasenaValida) {
      _mostrarAlerta(
        'La contraseña debe tener al menos 6 caracteres, una mayúscula y un símbolo.',
      );
      return;
    }

    if (_passwordController.text != _confirmarPasswordController.text) {
      _mostrarAlerta('Las contraseñas no coinciden.');
      return;
    }

    if (!_acepto) {
      _mostrarAlerta(
        'Debes aceptar los términos y condiciones para continuar.',
      );
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
      await _apiService.registrarUsuario(
        nombre: _nombreController.text.trim(),
        email: _correoController.text.trim(),
        contrasena: _passwordController.text,
        telefono: _telefonoController.text.trim(),
        localidad: _localidadController.text.trim(),
      );

      if (mounted) Navigator.pop(context);

      _mostrarAlerta(
        '¡Cuenta creada! Por favor introduce tu código de verificación.',
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerificarCuentaScreen(email: _correoController.text.trim()),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _mostrarAlerta(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _mostrarTerminosYCondiciones() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: Colors.redAccent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Términos y Tratamiento de Datos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Autorización de Tratamiento de Datos Personales',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'Al aceptar, autorizas de manera previa, expresa e informada a Alcris para recolectar, almacenar, usar y tratar tus datos personales con el propósito de gestionar tu cuenta, agendar servicios, enviar notificaciones y brindar soporte técnico.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
                SizedBox(height: 12),
                Text(
                  'Marco Legal Aplicable:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'El tratamiento de tu información se rige por la Ley Estatutaria 1581 de 2012 (Régimen General de Protección de Datos Personales de Colombia) y el Decreto Reglamentario 1377 de 2013. Como titular, tienes derecho a conocer, actualizar, rectificar y solicitar la supresión de tus datos en cualquier momento.',
                  style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  _acepto = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar y Continuar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Widget _requisitoContrasena(String texto, bool cumplido) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            cumplido ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: cumplido ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              color: cumplido ? Colors.green.shade700 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaRequisitosContrasena() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tu contraseña debe cumplir:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          _requisitoContrasena('Al menos 6 caracteres', _tieneMinimo6),
          _requisitoContrasena('Una letra mayúscula (A-Z)', _tieneMayuscula),
          _requisitoContrasena('Un símbolo (ej: ! @ # %)', _tieneSimbolo),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        'label': 'Teléfono celular',
        'hint': 'Ej: 3123456789',
        'controller': _telefonoController,
      },
      {
        'label': 'Municipio',
        'hint': 'Selecciona tu ubicación...',
        'controller': _localidadController,
        // 🛠️ INYECCIÓN POR SUFFIX: Usa el botón nativo del mapa para disparar el modal sin alterar la UI hija
        'suffix': IconButton(
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            size: 30,
            color: Colors.grey,
          ),
          onPressed: _mostrarSelectorMunicipios,
        ),
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      FormularioRegistro(
                        campos: campos,
                        aceptoValue: _acepto,
                        onAceptoChanged: (v) {
                          if (v) {
                            _mostrarTerminosYCondiciones();
                          } else {
                            setState(() => _acepto = false);
                          }
                        },
                      ),
                      _listaRequisitosContrasena(),
                      const SizedBox(height: 24),
                      BotonCrearCuenta(onPressed: _procesarRegistro),
                      const SizedBox(height: 16),
                      const EnlaceLogin(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Flecha flotante arriba a la izquierda para volver atrás / Home
          Positioned(
            top: MediaQuery.of(context).padding.top + 50,
            right: 22,
            child: Material(
              color: const Color.fromARGB(255, 219, 218, 218).withOpacity(0.25),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: 'Volver al inicio',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
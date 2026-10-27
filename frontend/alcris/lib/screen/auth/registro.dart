import 'package:alcris/screen/auth/verificarcuenta.dart';
import 'package:flutter/material.dart';
import 'package:alcris/screen/auth/login.dart';
import 'package:alcris/widgets/common/cabeceraregistro.dart';

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

  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
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
                  FormularioRegistro(
                    campos: campos,
                    aceptoValue: _acepto,
                    onAceptoChanged: (v) => setState(() => _acepto = v),
                  ),
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
    );
  }
}

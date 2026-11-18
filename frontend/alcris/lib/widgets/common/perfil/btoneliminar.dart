import 'package:flutter/material.dart';

class BotonEliminarCuenta extends StatefulWidget {
  final Future<void> Function() onConfirmarEliminacion;

  const BotonEliminarCuenta({
    super.key,
    required this.onConfirmarEliminacion,
  });

  @override
  State<BotonEliminarCuenta> createState() => _BotonEliminarCuentaState();
}

class _BotonEliminarCuentaState extends State<BotonEliminarCuenta> {
  bool _isDeleting = false;

  Future<void> _mostrarDialogoConfirmacion() async {
    final TextEditingController confirmController = TextEditingController();
    const String palabraClave = 'ELIMINAR';

    final bool? confirmado = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool coincide =
                confirmController.text.trim().toUpperCase() == palabraClave;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFC0392B),
                size: 40,
              ),
              title: const Text(
                'Confirmar eliminación de cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1E293B),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Esta acción es permanente y no se puede deshacer. Se borrarán todos tus datos y reservas.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Escribe ELIMINAR para confirmar:',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: palabraClave,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC0392B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: coincide
                      ? () => Navigator.of(dialogContext).pop(true)
                      : null,
                  child: const Text('Confirmar eliminación'),
                ),
              ],
            );
          },
        );
      },
    );

    confirmController.dispose();

    if (confirmado == true) {
      await _ejecutarEliminacion();
    }
  }

  Future<void> _ejecutarEliminacion() async {
    setState(() => _isDeleting = true);

    try {
      await widget.onConfirmarEliminacion();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: const Color(0xFFC0392B),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _isDeleting ? null : _mostrarDialogoConfirmacion,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFC0392B),
          side: const BorderSide(color: Color(0xFFC0392B), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: _isDeleting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFFC0392B),
                ),
              )
            : const Icon(Icons.delete_forever_rounded, size: 22),
        label: Text(
          _isDeleting ? 'Eliminando cuenta...' : 'Eliminar cuenta',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
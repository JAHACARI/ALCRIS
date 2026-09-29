import 'package:flutter/material.dart';

/// Pantalla de carga de Alcris.
///
/// - Fondo negro suave.
/// - Logo con revelado progresivo de izquierda a derecha.
/// - Brillo sutil detrás de las letras.
class PantallaCargaAlcris extends StatefulWidget {
  final Duration revealDuration;
  final VoidCallback? onComplete;
  final bool loop;

  const PantallaCargaAlcris({
    super.key,
    this.revealDuration = const Duration(milliseconds: 2200),
    this.onComplete,
    this.loop = false,
  });

  @override
  State<PantallaCargaAlcris> createState() => _PantallaCargaAlcrisState();
}

class _PantallaCargaAlcrisState extends State<PantallaCargaAlcris>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _reveal;
  late final Animation<double> _glow;

  static const Color _bg = Color(0xFF0E0E10);
  static const Color _azul = Color(0xFF1A5CFF);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.revealDuration,
    );

    _reveal = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.85, curve: Curves.easeInOutCubic),
    );

    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
      ),
    );

    if (widget.loop) {
      _controller.repeat();
    } else {
      _controller.forward().whenComplete(() {
        widget.onComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double logoWidth =
                    (constraints.maxWidth * 0.78).clamp(220.0, 420.0);

                return SizedBox(
                  width: logoWidth,
                  child: AspectRatio(
                    aspectRatio: 4.2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.35 * _glow.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _azul.withValues(alpha: 0.45),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: _azul.withValues(alpha: 0.18),
                                  blurRadius: 48,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ClipRect(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: _reveal.value.clamp(0.0, 1.0),
                            child: Image.asset(
                              'assets/images/logo_alcris.jpg',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => _LogoFallback(
                                progress: _reveal.value,
                              ),
                            ),
                          ),
                        ),
                        if (_reveal.value > 0.02 && _reveal.value < 0.98)
                          Positioned(
                            left: logoWidth * _reveal.value - 6,
                            top: 0,
                            bottom: 0,
                            child: IgnorePointer(
                              child: Container(
                                width: 12,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      _azul.withValues(
                                        alpha: 0.25 * _glow.value,
                                      ),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  final double progress;

  const _LogoFallback({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFF1A5CFF),
            Colors.black,
            Colors.black,
            Color(0xFF1A5CFF),
          ],
          stops: [0.0, 0.08, 0.92, 1.0],
        ).createShader(bounds);
      },
      child: Text(
        'ALCRIS',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.5,
          height: 1.0,
          fontFamily: 'Roboto',
          foreground: Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.white,
        ),
      ),
    );
  }
}

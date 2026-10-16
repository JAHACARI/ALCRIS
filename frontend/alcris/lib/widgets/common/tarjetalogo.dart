import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TarjetaLogo extends StatelessWidget {
  final String assetPath;

  const TarjetaLogo({
    super.key,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final bool esSvg = assetPath.toLowerCase().endsWith('.svg');

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 240,
        maxHeight: 240,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            spreadRadius: -4,
            offset: Offset(0, 22),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: esSvg
            ? SvgPicture.asset(
                assetPath,
                fit: BoxFit.contain,
                width: 240,
                height: 240,
              )
            : Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

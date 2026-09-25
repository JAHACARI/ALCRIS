import 'package:flutter/material.dart';

class MenuInferior extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MenuInferior({super.key, required this.currentIndex, required this.onTap});

  @override
  State<MenuInferior> createState() => _MenuInferiorState();
}

class _MenuInferiorState extends State<MenuInferior> {
  // Guardamos el índice sobre el que está el mouse (-1 = ninguno)
  int _hoveredIndex = -1;

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.home_filled, 'label': 'Inicio'},
    {'icon': Icons.person_rounded, 'label': 'Perfil'},
    {'icon': Icons.assignment_rounded, 'label': 'Servicios'},
    {'icon': Icons.smart_toy_outlined, 'label': 'Chat'},
    {'icon': Icons.settings_outlined, 'label': 'Config'},
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF0055A5),
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: List.generate(_items.length, (index) {
        final bool isHovered = _hoveredIndex == index;
        final bool isSelected = widget.currentIndex == index;

        return BottomNavigationBarItem(
          icon: MouseRegion(
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = -1),
            cursor: SystemMouseCursors.click,
            // Usamos AnimatedContainer para animar la traslación y elevación
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              // Desplaza el ícono -6 píxeles en el eje Y (hacia arriba) si hay hover
              transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
              padding: const EdgeInsets.only(bottom: 2), // Evita que se corte la parte inferior
              child: Icon(
                _items[index]['icon'],
                color: isSelected 
                    ? const Color(0xFF0055A5) 
                    : (isHovered ? const Color(0xFF0055A5).withOpacity(0.7) : Colors.grey),
              ),
            ),
          ),
          label: _items[index]['label'],
        );
      }),
    );
  }
}
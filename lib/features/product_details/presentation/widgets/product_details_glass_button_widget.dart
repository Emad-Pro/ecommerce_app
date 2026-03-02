import 'dart:ui';

import 'package:flutter/material.dart';

class ProductDetailsGlassButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProductDetailsGlassButtonWidget({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Icon(icon, size: 22, color: iconColor ?? Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}

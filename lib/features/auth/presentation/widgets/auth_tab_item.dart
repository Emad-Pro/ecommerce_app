import 'package:flutter/material.dart';

class AuthTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const AuthTabItem({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          style: TextStyle(
            fontSize: 15,
            fontFamily: "cairo",
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant.withOpacity(0.8),
            letterSpacing: 0.2,
          ),
          child: Text(title),
        ),
      ),
    );
  }
}

import 'package:ecommerce_app/features/auth/presentation/widgets/auth_tab_item.dart';
import 'package:flutter/material.dart';

class AuthTabBar extends StatelessWidget {
  final bool isEmail;
  final Function(bool) onTabChanged;

  const AuthTabBar({required this.isEmail, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final alignment = isEmail ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd;

    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            alignment: alignment,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth / 2,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: colorScheme.shadow.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AuthTabItem(title: 'الإيميل', isSelected: isEmail, onTap: () => onTabChanged(true)),
              ),
              Expanded(
                child: AuthTabItem(title: 'رقم الجوال', isSelected: !isEmail, onTap: () => onTabChanged(false)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

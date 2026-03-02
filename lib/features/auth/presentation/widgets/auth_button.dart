import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthButton({required this.text, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: colorScheme.primary.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(color: colorScheme.onPrimary, strokeWidth: 2),
                )
              : Text(
                  text,
                  style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
        ),
      ),
    );
  }
}

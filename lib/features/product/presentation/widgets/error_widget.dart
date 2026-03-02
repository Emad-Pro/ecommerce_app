import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    String displayMessage = message;
    IconData errorIcon = Icons.error_outline_rounded;

    if (message.toLowerCase().contains('no internet') || message.toLowerCase().contains('network')) {
      displayMessage = 'يبدو أنه لا يوجد اتصال بالإنترنت.\nيرجى التحقق من الشبكة والمحاولة مرة أخرى.';
      errorIcon = Icons.wifi_off_rounded;
    } else if (message.contains('ErrorHandler')) {
      displayMessage = 'عذراً، حدث خطأ غير متوقع.\nنعمل على حله في أسرع وقت.';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: colorScheme.errorContainer.withOpacity(0.5), shape: BoxShape.circle),
            child: Icon(errorIcon, size: 64, color: colorScheme.error),
          ),
          const SizedBox(height: 24),

          Text(
            'أُووبس!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),

          Text(
            displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.6, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

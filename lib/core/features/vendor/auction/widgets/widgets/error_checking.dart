// lib/core/features/vendor/other/widgets/error_page.dart
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorPage({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text("Coba Lagi"),
          )
        ],
      ),
    );
  }
}

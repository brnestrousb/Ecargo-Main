import 'package:flutter/material.dart';

class StepTitle extends StatelessWidget {
  final String title;

  const StepTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
    );
  }
}

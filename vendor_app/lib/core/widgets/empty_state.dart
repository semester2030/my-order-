import 'package:flutter/material.dart';

/// Empty state placeholder (Phase 1: minimal).
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message ?? 'لا توجد بيانات'),
    );
  }
}

import 'package:flutter/material.dart';

/// Loading view placeholder (Phase 1: shows centered CircularProgressIndicator).
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

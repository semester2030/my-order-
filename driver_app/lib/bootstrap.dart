import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/di/providers.dart';

/// Bootstrap function to initialize app
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize local storage
  final container = ProviderContainer();
  final localStorage = container.read(localStorageProvider);
  await localStorage.init();

  // Run app
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DriverApp(),
    ),
  );
}

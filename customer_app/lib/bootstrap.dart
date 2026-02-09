import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/storage/local_storage.dart';

/// Bootstrap function to initialize app
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize local storage
  final localStorage = LocalStorage();
  await localStorage.init();

  // Run app
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

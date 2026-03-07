import 'package:get_it/get_it.dart';

import '../../feature/new/di/new_module.dart';

final GetIt sl = GetIt.instance;

/// Dependency Injection Container
///
/// Centralized dependency injection setup using GetIt.
/// All dependencies are registered here and can be accessed
/// throughout the application.
abstract final class InjectionContainer {
  static bool _initialized = false;

  /// Initialize all dependencies
  ///
  /// Should be called once during app startup, before runApp().
  static Future<void> init() async {
    if (_initialized) return;

    // Core services
    await _initCore();

    // Feature modules
    await CreateModule().register(sl);

    _initialized = true;
  }

  static Future<void> _initCore() async {
    // Example registrations
    // sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }
}
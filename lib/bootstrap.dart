import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/di/injection_container.dart';
import 'feature/app/presentation/app.dart';

/// Application bootstrap
///
/// Handles all initialization before running the app:
/// - Dependency injection
/// - Error handling setup
/// - BLoC observer registration
/// - Platform-specific setup
/// - Auth state check for initial routing
/// - Psychotype test check for initial routing
Future<void> bootstrap() async {
  // Run in a guarded zone for error handling
  await runZonedGuarded(
        () async {
      // Preserve splash screen while initializing
WidgetsFlutterBinding.ensureInitialized();


      // Initialize dependency injection
      await InjectionContainer.init();


      // Register BLoC observer for debugging
      if (kDebugMode) {
        Bloc.observer = _AppBlocObserver();
      }

      runApp(const App());
    },
        (error, stackTrace) {
      // Global error handling
      debugPrint('❌ Error: $error');
      debugPrint('❌ StackTrace: $stackTrace');
    },
  );
}

/// BLoC observer for debugging
class _AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      debugPrint('🆕 onCreate: ${bloc.runtimeType}');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('🔄 onChange: ${bloc.runtimeType}');
      debugPrint('   Current: ${change.currentState}');
      debugPrint('   Next: ${change.nextState}');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      debugPrint('📩 onEvent: ${bloc.runtimeType} - $event');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      debugPrint('❌ onError: ${bloc.runtimeType}');
      debugPrint('   Error: $error');
      debugPrint('   StackTrace: $stackTrace');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      debugPrint('🗑️ onClose: ${bloc.runtimeType}');
    }
  }
}

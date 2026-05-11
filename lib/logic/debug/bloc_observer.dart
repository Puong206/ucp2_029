import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  /// Log ketika event ditambahkan ke Bloc
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    developer.log(
      '📤 Event: ${event.runtimeType}',
      name: 'BLoC → ${bloc.runtimeType}',
      level: 300, // INFO level
    );
  }

  /// Log ketika state berubah
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    developer.log(
      '${change.currentState.runtimeType} → ${change.nextState.runtimeType}',
      name: 'BLoC | ${bloc.runtimeType}',
      level: 300, // INFO level
    );
    
    // Log lebih detail untuk state tertentu (optional)
    if (change.nextState.toString().length < 200) {
      developer.log(
        'State: ${change.nextState}',
        name: 'BLoC | ${bloc.runtimeType}',
        level: 400, // FINE level (more verbose)
      );
    }
  }

  /// Log ketika terjadi error di Bloc
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    developer.log(
      '❌ Error: ${error.toString()}',
      name: 'BLoC | ${bloc.runtimeType}',
      level: 900, // SEVERE level
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  /// Log ketika Bloc di-close/dispose
  @override
  void onClose(BlocBase bloc) {
    developer.log(
      '🔴 Closed',
      name: 'BLoC | ${bloc.runtimeType}',
      level: 300,
    );
    super.onClose(bloc);
  }

  /// Log ketika Bloc di-create
  @override
  void onCreate(BlocBase bloc) {
    developer.log(
      '🟢 Created',
      name: 'BLoC | ${bloc.runtimeType}',
      level: 300,
    );
    super.onCreate(bloc);
  }
}
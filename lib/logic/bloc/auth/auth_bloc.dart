import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    /// Handle app startup - check if user sudah login sebelumnya
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      developer.log('AppStarted - Checking authentication status',
          name: 'AuthBloc');

      try {
        final isAuth = await repository.isAuthenticated();

        if (isAuth) {
          // User punya token, ambil data user
          final user = await repository.getMe();
          final token = await repository.getToken();
          emit(Authenticated(user: user, token: token!));
          developer.log('AppStarted - User authenticated: ${user.email}',
              name: 'AuthBloc');
        } else {
          emit(Unauthenticated());
          developer.log('AppStarted - User not authenticated',
              name: 'AuthBloc');
        }
      } catch (e) {
        // Token invalid atau expired
        await repository.deleteToken();
        emit(Unauthenticated());
        developer.log('AppStarted - Auth check failed: $e', name: 'AuthBloc');
      }
    });

    /// Handle login request
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      developer.log('LoginRequested - Email: ${event.email}', name: 'AuthBloc');

      try {
        // Login dan dapatkan user data + token
        final user = await repository.login(event.email, event.password);
        final token = await repository.getToken();

        if (token == null) {
          throw 'Token tidak ditemukan setelah login';
        }

        emit(Authenticated(user: user, token: token));
        developer.log('LoginRequested - Success: ${user.email}',
            name: 'AuthBloc');
      } catch (e) {
        emit(AuthError(e.toString()));
        developer.log('LoginRequested - Error: $e', name: 'AuthBloc',
            error: e);
      }
    });

    /// Handle register request
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      developer.log('RegisterRequested - Email: ${event.email}',
          name: 'AuthBloc');

      try {
        await repository.register(event.nama, event.email, event.password);
        emit(RegisterSuccess(email: event.email));
        developer.log('RegisterRequested - Success: ${event.email}',
            name: 'AuthBloc');
      } catch (e) {
        emit(AuthError(e.toString()));
        developer.log('RegisterRequested - Error: $e', name: 'AuthBloc',
            error: e);
      }
    });

    /// Handle logout request
    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      developer.log('LogoutRequested', name: 'AuthBloc');

      try {
        // Call backend logout endpoint
        await repository.logout();
        emit(Unauthenticated());
        developer.log('LogoutRequested - Success', name: 'AuthBloc');
      } catch (e) {
        developer.log('LogoutRequested - Error: $e', name: 'AuthBloc',
            error: e);
        // Tetap emit Unauthenticated meski ada error
        emit(Unauthenticated());
      }
    });

    /// Handle get current user request
    on<GetMeRequested>((event, emit) async {
      emit(AuthLoading());
      developer.log('GetMeRequested', name: 'AuthBloc');

      try {
        final user = await repository.getMe();
        final token = await repository.getToken();

        if (token == null) {
          throw 'Token tidak ditemukan';
        }

        emit(Authenticated(user: user, token: token));
        developer.log('GetMeRequested - Success: ${user.email}',
            name: 'AuthBloc');
      } catch (e) {
        developer.log('GetMeRequested - Error: $e', name: 'AuthBloc',
            error: e);
        // Token invalid/expired
        await repository.deleteToken();
        emit(Unauthenticated());
      }
    });

    /// Handle check authentication status
    on<CheckAuthenticationStatus>((event, emit) async {
      developer.log('CheckAuthenticationStatus', name: 'AuthBloc');

      try {
        final isAuth = await repository.isAuthenticated();
        if (isAuth) {
          final user = await repository.getMe();
          final token = await repository.getToken();
          emit(Authenticated(user: user, token: token!));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(Unauthenticated());
        developer.log('CheckAuthenticationStatus - Error: $e',
            name: 'AuthBloc', error: e);
      }
    });
  }
}
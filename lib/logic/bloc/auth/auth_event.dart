import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Triggered saat app start untuk check apakah user sudah login sebelumnya
class AppStarted extends AuthEvent {}

/// Triggered saat user submit login form dengan email & password
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Triggered saat user submit register form
class RegisterRequested extends AuthEvent {
  final String nama;
  final String email;
  final String password;

  RegisterRequested({
    required this.nama,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [nama, email, password];
}

/// Triggered saat user klik logout button
class LogoutRequested extends AuthEvent {}

/// Triggered untuk ambil data user yang sedang login (current user)
/// Requires valid JWT token
class GetMeRequested extends AuthEvent {}

/// Triggered untuk check apakah user masih authenticated
class CheckAuthenticationStatus extends AuthEvent {}
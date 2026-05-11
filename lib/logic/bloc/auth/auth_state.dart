import 'package:equatable/equatable.dart';
import 'package:ucp2/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state saat app pertama kali start
class AuthInitial extends AuthState {}

/// Loading state saat melakukan operasi auth (login, register, logout, getMe)
class AuthLoading extends AuthState {}

/// Authenticated state ketika user berhasil login
/// Menyimpan user data dan token untuk future requests
class Authenticated extends AuthState {
  final Usermodel user;
  final String token;

  Authenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}

/// Unauthenticated state ketika user belum login atau sudah logout
class Unauthenticated extends AuthState {}

/// Error state untuk handle authentication errors
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state untuk register berhasil
/// User dapat langsung login dengan credentials yang sama
class RegisterSuccess extends AuthState {
  final String email;
  final String message;

  RegisterSuccess({
    required this.email,
    this.message = 'Register berhasil. Silakan login.',
  });

  @override
  List<Object?> get props => [email, message];
}
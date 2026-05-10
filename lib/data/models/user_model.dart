import 'package:equatable/equatable.dart';

class Usermodel extends Equatable {
  final String id;
  final String username;
  final String email;

  const Usermodel({
    required this.id,
    required this.username,
    required this.email,
  });

  factory Usermodel.fromJson(Map<String, dynamic> json) {
    return Usermodel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  @override
  List<Object?> get props => [id, username, email];
}
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/ui/widgets/auth_button.dart';
import 'package:ucp2/ui/widgets/auth_text_field.dart';
import 'package:ucp2/ui/widgets/password_strength.dart';

import '../theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralLight,
      appBar: AppBar(
        backgroundColor: AppTheme.neutralLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(
            context,
          ).pushReplacementNamed('/login'),
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Akun berhasil dibuat! Silahkan Login!'),
                backgroundColor: AppTheme.successColor,
                duration: Duration(seconds: 2),
              ),
            );
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Buat Akun Baru",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Daftar untuk mulai menyewa dengan DriveEase',
                    style: TextStyle(color: Color(0xFF999999), fontSize: 16),
                  ),
                  SizedBox(height: 28),

                  AuthTextField(
                    label: 'Nama Lengkap',
                    hintText: "Masukkan nama lengkap Anda",
                    controller: _namaController,
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Nama harus diisi";
                      if (value.length < 3) return "Nama minimal 3 karakter";
                      return null;
                    },
                  ),
                  SizedBox(height: 18),

                  AuthTextField(
                    label: 'Email',
                    hintText: "Masukkan Email Anda",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Email harus diisi";
                      if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      ).hasMatch(value)) {
                        return "Format email tidak valid";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),

                  AuthTextField(
                    label: "Password",
                    hintText: "Masukkan password",
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    onChanged: (value) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Password harus diisi";
                      if (value.length < 8)
                        return "Password minimal 8 karakter";
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  PasswordStrengthIndicator(password: _passwordController.text),
                  SizedBox(height: 10),

                  AuthTextField(
                    label: "Konfirmasi Password",
                    hintText: "Masukkan ulang password",
                    controller: _confirmPasswordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Mohon masukkan ulang password Anda!";
                      if (value != _passwordController.text)
                        return "Password tidak sesuai";
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        label: 'Daftar',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              RegisterRequested(
                                nama: _namaController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 18),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sudah punya akun?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                          TextSpan(
                            text: ' Login di sini',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(
                                context,
                              ).pushReplacementNamed('/login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

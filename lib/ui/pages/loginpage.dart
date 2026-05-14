import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/ui/theme/app_theme.dart';
import 'package:ucp2/ui/widgets/auth_button.dart';
import 'package:ucp2/ui/widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign in to your account to continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 32),

                  // Email Field
                  AuthTextField(
                    label: 'Email',
                    hint: 'Masukkan email Anda',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email diperlukan';
                      }
                      if (!value!.contains('@')) {
                        return 'Masukkan email yang valid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  AuthTextField(
                    label: 'Password',
                    hint: 'Masukkan password Anda',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppTheme.textSecondary,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password diperlukan';
                      }
                      if (value!.length < 6) {
                        return 'Password harus minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() => _rememberMe = value ?? false);
                            },
                            activeColor: AppTheme.primaryColor,
                          ),
                          Text(
                            'Ingat saya',
                            style: TextStyle(
                              fontFamily: 'Mont',
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lupa Password?',
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 14,
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      bool isLoading = state is AuthLoading;
                      return AuthButton(
                        label: 'Masuk',
                        onPressed: _login,
                        isLoading: isLoading,
                      );
                    },
                  ),
                  SizedBox(height: 24),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tidak punya akun? ",
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 14,
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
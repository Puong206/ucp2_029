import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/ui/widgets/auth_button.dart';
import 'package:ucp2/ui/widgets/auth_text_field.dart';
import '../theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please agree to Terms and Conditions'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
            RegisterRequested(
              nama: _nameController.text,
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
      appBar: AppBar(
        title: Text('Buat Akun'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration successful! Please login.'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            Navigator.of(context).pushReplacementNamed('/login');
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
                    'Create Account',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Join us to explore amazing car rentals',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 32),

                  // Name Field
                  AuthTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _nameController,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppTheme.textSecondary,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  AuthTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email is required';
                      }
                      if (!value!.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  AuthTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppTheme.textSecondary,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password is required';
                      }
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Confirm Password Field
                  AuthTextField(
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppTheme.textSecondary,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Terms Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() => _agreeToTerms = value ?? false);
                        },
                        activeColor: AppTheme.primaryColor,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to ',
                            style: TextStyle(
                              fontFamily: 'Mont',
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: TextStyle(
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Register Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      bool isLoading = state is AuthLoading;
                      return AuthButton(
                        label: 'Create Account',
                        onPressed: _register,
                        isLoading: isLoading,
                      );
                    },
                  ),
                  SizedBox(height: 20),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 14,
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.w600,
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

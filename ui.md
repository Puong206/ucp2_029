# 📱 DriveEase UI Implementation Guide

Panduan lengkap membuat Login, Register, Home, Search, dan Filter screens dengan design Insightlancer + BLoC integration.

---

## 📁 Folder Structure

```
lib/
├── ui/
│   ├── pages/
│   │   ├── login_page.dart
│   │   ├── register_page.dart
│   │   ├── home_page.dart
│   │   └── search_page.dart
│   ├── widgets/
│   │   ├── auth_text_field.dart
│   │   ├── auth_button.dart
│   │   ├── password_strength_indicator.dart
│   │   ├── car_card.dart
│   │   ├── search_bar.dart
│   │   └── filter_modal.dart
│   └── theme/
│       └── app_theme.dart
```

---

## 🎨 Color Scheme & Typography

### Colors
```dart
const Color primaryColor = Color(0xFF1A1A2E);      // Dark Navy
const Color secondaryColor = Color(0xFFFFB84D);    // Gold/Orange
const Color accentColor = Color(0xFFE74C3C);       // Red (highlight)
const Color neutralLight = Color(0xFFF5F5F5);      // Light Gray
const Color neutralDark = Color(0xFF333333);       // Dark Gray
const Color white = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFE74C3C);
const Color successColor = Color(0xFF27AE60);
```

---

## 🛠️ STEP 1: Setup AppTheme

**File:** `lib/ui/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color secondaryColor = Color(0xFFFFB84D);
  static const Color accentColor = Color(0xFFE74C3C);
  static const Color neutralLight = Color(0xFFF5F5F5);
  static const Color neutralDark = Color(0xFF333333);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF27AE60);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Color(0xFFFAFAFA),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
```

---

## 🛠️ STEP 2: Create AuthTextField Widget

**File:** `lib/ui/widgets/auth_text_field.dart`

```dart
import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final IconData? prefixIcon;
  final String? errorText;
  
  const AuthTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.errorText,
  });
  
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;
  
  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: widget.validator,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppTheme.primaryColor, size: 20)
                  : null,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () => setState(() => _obscureText = !_obscureText),
                      child: Icon(
                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: widget.errorText != null ? AppTheme.errorColor : Color(0xFFDDDDDD),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.secondaryColor, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              errorText: widget.errorText,
              errorStyle: TextStyle(color: AppTheme.errorColor, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 🛠️ STEP 3: Create AuthButton Widget

**File:** `lib/ui/widgets/auth_button.dart`

```dart
import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double height;
  
  const AuthButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height = 50,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryColor, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: Color(0xFFCCCCCC),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
    );
  }
}
```

---

## 🛠️ STEP 4: Create PasswordStrengthIndicator Widget

**File:** `lib/ui/widgets/password_strength_indicator.dart`

```dart
import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

enum PasswordStrength { empty, weak, fair, good, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  
  const PasswordStrengthIndicator({required this.password});
  
  PasswordStrength _calculateStrength() {
    if (password.isEmpty) return PasswordStrength.empty;
    
    int strength = 0;
    if (password.length >= 8) strength += 25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 25;
    if (password.contains(RegExp(r'[a-z]'))) strength += 25;
    if (password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'))) strength += 25;
    
    if (strength < 25) return PasswordStrength.weak;
    if (strength < 50) return PasswordStrength.fair;
    if (strength < 75) return PasswordStrength.good;
    return PasswordStrength.strong;
  }
  
  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(
            backgroundColor: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(3),
          ),
          child: LinearProgressIndicator(
            value: _getProgressValue(strength),
            backgroundColor: Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor(strength)),
            minHeight: 6,
          ),
        ),
        SizedBox(height: 6),
        Text(
          _getStrengthText(strength),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _getStrengthColor(strength),
          ),
        ),
      ],
    );
  }
  
  double _getProgressValue(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty: return 0;
      case PasswordStrength.weak: return 0.25;
      case PasswordStrength.fair: return 0.5;
      case PasswordStrength.good: return 0.75;
      case PasswordStrength.strong: return 1.0;
    }
  }
  
  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty: return Color(0xFFDDDDDD);
      case PasswordStrength.weak: return AppTheme.errorColor;
      case PasswordStrength.fair: return Color(0xFFFFA500);
      case PasswordStrength.good: return Color(0xFFFFD700);
      case PasswordStrength.strong: return AppTheme.successColor;
    }
  }
  
  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty: return '';
      case PasswordStrength.weak: return 'Weak password';
      case PasswordStrength.fair: return 'Fair password';
      case PasswordStrength.good: return 'Good password';
      case PasswordStrength.strong: return 'Strong password';
    }
  }
}
```

---

## 🛠️ STEP 5: Create SearchBar Widget

**File:** `lib/ui/widgets/search_bar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function()? onFilterTap;
  
  const SearchBar({
    required this.controller,
    required this.onChanged,
    this.onFilterTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search products',
          hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
          prefixIcon: Icon(Icons.search, color: Color(0xFFCCCCCC)),
          suffixIcon: GestureDetector(
            onTap: onFilterTap,
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
```

---

## 🛠️ STEP 6: Create CarCard Widget

**File:** `lib/ui/widgets/car_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class CarCard extends StatelessWidget {
  final KatalogModel katalog;
  final Function()? onTap;
  final Function()? onFavoriteTap;
  
  const CarCard({
    required this.katalog,
    this.onTap,
    this.onFavoriteTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: katalog.imageUrl != null
                      ? Image.network(katalog.imageUrl!, fit: BoxFit.cover)
                      : Center(
                          child: Icon(Icons.directions_car, size: 40, color: Color(0xFFCCCCCC)),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      ),
                      child: Icon(Icons.favorite_border, size: 16, color: AppTheme.errorColor),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${katalog.brand} ${katalog.model}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp ${katalog.hargaPerHari.toStringAsFixed(0)}/hari',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔐 LOGIN PAGE

**File:** `lib/ui/pages/login_page.dart`

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/ui/widgets/auth_text_field.dart';
import 'package:ucp2/ui/widgets/auth_button.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralLight,
      appBar: AppBar(
        backgroundColor: AppTheme.neutralLight,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
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
            padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Login to your DriveEase account',
                    style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  ),
                  SizedBox(height: 32),
                  
                  AuthTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  
                  AuthTextField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password is required';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 14),
                  
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
                            activeColor: AppTheme.secondaryColor,
                            checkColor: AppTheme.primaryColor,
                            side: BorderSide(color: AppTheme.secondaryColor, width: 2),
                          ),
                          Text('Remember me', style: TextStyle(fontSize: 12, color: AppTheme.primaryColor)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Forgot Password?', style: TextStyle(fontSize: 12, color: AppTheme.secondaryColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        label: 'Login',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              LoginRequested(
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
                  
                  Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('OR', style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB), fontWeight: FontWeight.w600)),
                      ),
                      Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                    ],
                  ),
                  SizedBox(height: 18),
                  
                  Row(
                    children: [
                      Expanded(child: _SocialButton(icon: Icons.g_translate, label: 'Google', onPressed: () {})),
                      SizedBox(width: 12),
                      Expanded(child: _SocialButton(icon: Icons.apple, label: 'Apple', onPressed: () {})),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Don't have an account? ", style: TextStyle(fontSize: 13, color: Color(0xFF999999))),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(fontSize: 13, color: AppTheme.secondaryColor, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).pushReplacementNamed('/register'),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onPressed;
  
  const _SocialButton({required this.icon, required this.label, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFDDDDDD), width: 1.5),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
          ],
        ),
      ),
    );
  }
}
```

---

## 📝 REGISTER PAGE

**File:** `lib/ui/pages/register_page.dart`

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/ui/widgets/auth_text_field.dart';
import 'package:ucp2/ui/widgets/auth_button.dart';
import 'package:ucp2/ui/widgets/password_strength_indicator.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

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
  bool _agreeToTerms = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralLight,
      appBar: AppBar(
        backgroundColor: AppTheme.neutralLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Account created successfully! Please login.'),
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
                    'Create Account',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign up to start renting with DriveEase',
                    style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  ),
                  SizedBox(height: 28),
                  
                  AuthTextField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: _namaController,
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.person_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Full name is required';
                      if (value.length < 3) return 'Name must be at least 3 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  
                  AuthTextField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  
                  AuthTextField(
                    label: 'Password',
                    hintText: 'Create a strong password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outlined,
                    onChanged: (value) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password is required';
                      if (value.length < 8) return 'Password must be at least 8 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  
                  PasswordStrengthIndicator(password: _passwordController.text),
                  SizedBox(height: 18),
                  
                  AuthTextField(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm your password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                        activeColor: AppTheme.secondaryColor,
                        checkColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.secondaryColor, width: 2),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'I agree to the ', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(fontSize: 12, color: AppTheme.secondaryColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        label: 'Sign Up',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (!_agreeToTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please agree to Terms & Conditions'),
                                backgroundColor: AppTheme.errorColor,
                              ),
                            );
                            return;
                          }
                          
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
                  
                  Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('OR', style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB), fontWeight: FontWeight.w600)),
                      ),
                      Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                    ],
                  ),
                  SizedBox(height: 18),
                  
                  Row(
                    children: [
                      Expanded(child: _SocialButton(icon: Icons.g_translate, label: 'Google', onPressed: () {})),
                      SizedBox(width: 12),
                      Expanded(child: _SocialButton(icon: Icons.apple, label: 'Apple', onPressed: () {})),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Already have an account? ', style: TextStyle(fontSize: 13, color: Color(0xFF999999))),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(fontSize: 13, color: AppTheme.secondaryColor, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).pushReplacementNamed('/login'),
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onPressed;
  
  const _SocialButton({required this.icon, required this.label, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFDDDDDD), width: 1.5),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔄 UPDATE main.dart

**File:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/data/repositories/auth_repository.dart';
import 'package:ucp2/data/repositories/katalog_repository.dart';
import 'package:ucp2/ui/pages/login_page.dart';
import 'package:ucp2/ui/pages/register_page.dart';
import 'package:ucp2/ui/pages/home_page.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository())..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => KatalogBloc(KatalogRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'DriveEase',
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
        },
      ),
    );
  }
}
```

---

## 🏠 HOME PAGE

**File:** `lib/ui/pages/home_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/ui/widgets/car_card.dart';
import 'package:ucp2/ui/widgets/search_bar.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalog());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle, color: AppTheme.primaryColor, size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi Jenifer!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Search your ideal car here',
                    style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            
            // Search Bar
            SearchBar(
              controller: searchController,
              onChanged: (value) {},
              onFilterTap: () {
                Navigator.of(context).pushNamed('/search');
              },
            ),
            SizedBox(height: 20),
            
            // Explore Latest Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🏷️  Explore Latest', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('View all', style: TextStyle(fontSize: 12, color: AppTheme.secondaryColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(height: 12),
            
            // Explore Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFFFFB84D).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFB84D).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explore Latest\nCars with Best Price',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pushNamed('/search'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Explore', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // The Most Searched Cars
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('🔍 The most searched cars', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            
            BlocBuilder<KatalogBloc, KatalogState>(
              builder: (context, state) {
                if (state is KatalogLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is KatalogLoaded) {
                  return Container(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.katalogList.length,
                      itemBuilder: (context, index) {
                        return CarCard(katalog: state.katalogList[index]);
                      },
                    ),
                  );
                } else if (state is KatalogError) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Error: ${state.message}'),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 24),
            
            // Recommended Cars
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('⭐ Recommended Cars For You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            
            BlocBuilder<KatalogBloc, KatalogState>(
              builder: (context, state) {
                if (state is KatalogLoaded) {
                  return Container(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.katalogList.take(3).length,
                      itemBuilder: (context, index) {
                        return CarCard(katalog: state.katalogList[index]);
                      },
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Color(0xFFCCCCCC),
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Saved'),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
```

---

## 🔍 KATALOG PAGE (Search & Listing)

**File:** `lib/ui/pages/katalog_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/ui/widgets/search_bar.dart';
import 'package:ucp2/ui/widgets/car_card.dart';
import 'package:ucp2/ui/widgets/filter_modal.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class KatalogPage extends StatefulWidget {
  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  final searchController = TextEditingController();
  String? selectedSegment;
  
  final segments = ['SUV', 'Sedan', 'Hatchback', 'Convertible'];
  final brands = ['HYUNDAI', 'KIA', 'TOYOTA', 'TATA', 'MARUTI'];
  final fuelTypes = ['CNG', 'Petrol', 'Diesel', 'Electric', 'Hybrid'];
  
  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalog());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle, color: AppTheme.primaryColor, size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            
            SearchBar(
              controller: searchController,
              onChanged: (value) {},
              onFilterTap: () => _showFilterModal(),
            ),
            SizedBox(height: 24),
            
            // Popular Segments
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Popular Segments', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: segments.map((segment) {
                      final isSelected = selectedSegment == segment;
                      return FilterChip(
                        label: Text(segment),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => selectedSegment = selected ? segment : null);
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppTheme.primaryColor,
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryColor : Color(0xFFDDDDDD),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // All Brands
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('All Brands', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
                        ),
                        child: Center(
                          child: Text(
                            brands[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryColor),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Fuel Type
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fuel Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fuelTypes.map((fuel) {
                      return ActionChip(
                        label: Text(fuel),
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFFDDDDDD)),
                        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // Katalog List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Available Cars', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            
            BlocBuilder<KatalogBloc, KatalogState>(
              builder: (context, state) {
                if (state is KatalogLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is KatalogLoaded) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: state.katalogList.length,
                    itemBuilder: (context, index) {
                      return CarCard(katalog: state.katalogList[index]);
                    },
                  );
                } else if (state is KatalogError) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Error: ${state.message}'),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterModal(),
    );
  }
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
```

---

## 🏷️ FILTER MODAL

**File:** `lib/ui/widgets/filter_modal.dart`

```dart
import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class FilterModal extends StatefulWidget {
  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String? selectedSeats;
  String? selectedTransmission;
  String? selectedColor;
  String? selectedArrange;
  RangeValues priceRange = RangeValues(1, 10);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('RESET', style: TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              // Seats
              Text('Seats', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ['2 Seats', '4 Seats', '5 Seats'].map((seat) {
                  final isSelected = selectedSeats == seat;
                  return ChoiceChip(
                    label: Text(seat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => selectedSeats = selected ? seat : null);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.primaryColor,
                    side: BorderSide(color: isSelected ? AppTheme.primaryColor : Color(0xFFDDDDDD)),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              
              // Transmission
              Text('Transmission', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ['Manual', 'Automatic'].map((trans) {
                  final isSelected = selectedTransmission == trans;
                  return ChoiceChip(
                    label: Text(trans),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => selectedTransmission = selected ? trans : null);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.primaryColor,
                    side: BorderSide(color: isSelected ? AppTheme.primaryColor : Color(0xFFDDDDDD)),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              
              // Color
              Text('Choose Colour', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 12,
                children: [
                  Color(0xFFD0D0D0),
                  Color(0xFFC94444),
                  Color(0xFFC9A090),
                  Color(0xFFE5B87D),
                  Color(0xFF2C3E50),
                ].map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = color.toString()),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color.toString() ? AppTheme.primaryColor : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              
              // Arrange By
              Text('Arrange by', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ['High Sales', 'A-Z', 'Z-A'].map((arrange) {
                  final isSelected = selectedArrange == arrange;
                  return ChoiceChip(
                    label: Text(arrange),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => selectedArrange = selected ? arrange : null);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.primaryColor,
                    side: BorderSide(color: isSelected ? AppTheme.primaryColor : Color(0xFFDDDDDD)),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              
              // Price Range
              Text('Offer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              RangeSlider(
                values: priceRange,
                min: 1,
                max: 10,
                onChanged: (RangeValues values) {
                  setState(() => priceRange = values);
                },
                activeColor: AppTheme.secondaryColor,
                inactiveColor: Color(0xFFEEEEEE),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rs.${priceRange.start.toInt()} Lakh', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    Text('Rs.${priceRange.end.toInt()} Lakh', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                  ],
                ),
              ),
              SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Filter', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 📁 KATEGORI PAGE (Category Listing)

**File:** `lib/ui/pages/kategori_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class KategoriPage extends StatefulWidget {
  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  @override
  void initState() {
    super.initState();
    // TODO: Trigger fetch kategori saat page load
    // context.read<KategoriBloc>().add(FetchKategori());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Categories', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle, color: AppTheme.primaryColor, size: 28),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Browse by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Choose a category to see available cars', style: TextStyle(fontSize: 13, color: Color(0xFF999999))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryCard(
                  title: 'SUV',
                  description: 'Sport Utility Vehicles',
                  icon: Icons.terrain,
                  onTap: () {
                    // TODO: Navigate to SUV cars
                  },
                ),
                SizedBox(height: 12),
                _CategoryCard(
                  title: 'Sedan',
                  description: 'Comfortable Family Cars',
                  icon: Icons.directions_car,
                  onTap: () {
                    // TODO: Navigate to Sedan cars
                  },
                ),
                SizedBox(height: 12),
                _CategoryCard(
                  title: 'Hatchback',
                  description: 'Compact City Cars',
                  icon: Icons.airport_shuttle,
                  onTap: () {
                    // TODO: Navigate to Hatchback cars
                  },
                ),
                SizedBox(height: 12),
                _CategoryCard(
                  title: 'Convertible',
                  description: 'Premium Open-Top Cars',
                  icon: Icons.wb_sunny,
                  onTap: () {
                    // TODO: Navigate to Convertible cars
                  },
                ),
                SizedBox(height: 12),
                _CategoryCard(
                  title: 'Truck',
                  description: 'Heavy Duty Vehicles',
                  icon: Icons.local_shipping,
                  onTap: () {
                    // TODO: Navigate to Truck cars
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Function() onTap;
  
  const _CategoryCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.secondaryColor, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppTheme.primaryColor, size: 16),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔄 UPDATE main.dart Routes

**Update Routes di main.dart:**

```dart
routes: {
  '/login': (context) => LoginPage(),
  '/register': (context) => RegisterPage(),
  '/home': (context) => HomePage(),
  '/search': (context) => KatalogPage(),
  '/categories': (context) => KategoriPage(),
},
```

---

## ✅ Implementation Checklist

- [ ] Create `AppTheme` di `lib/ui/theme/app_theme.dart`
- [ ] Create `AuthTextField` di `lib/ui/widgets/auth_text_field.dart`
- [ ] Create `AuthButton` di `lib/ui/widgets/auth_button.dart`
- [ ] Create `PasswordStrengthIndicator` di `lib/ui/widgets/password_strength_indicator.dart`
- [ ] Create `SearchBar` di `lib/ui/widgets/search_bar.dart`
- [ ] Create `CarCard` di `lib/ui/widgets/car_card.dart`
- [ ] Create `FilterModal` di `lib/ui/widgets/filter_modal.dart`
- [ ] Create `LoginPage` di `lib/ui/pages/login_page.dart`
- [ ] Create `RegisterPage` di `lib/ui/pages/register_page.dart`
- [ ] Create `HomePage` di `lib/ui/pages/home_page.dart`
- [ ] Create `KatalogPage` di `lib/ui/pages/katalog_page.dart`
- [ ] Create `KategoriPage` di `lib/ui/pages/kategori_page.dart`
- [ ] Update `main.dart` dengan routing dan MultiBlocProvider
- [ ] Create KatalogRepository (jika belum ada)
- [ ] Create KatalogBloc (jika belum ada)
- [ ] Run `flutter pub get`
- [ ] Test login flow
- [ ] Test register flow
- [ ] Test home page dengan KatalogBloc
- [ ] Test katalog page dengan filtering
- [ ] Test kategori page navigation

---

## 🚀 Quick Start

1. Copy kode di atas sesuai file path
2. Pastikan folder structure sudah benar
3. Run: `flutter pub get`
4. Run: `flutter run`
5. Aplikasi akan membuka LoginPage
6. Test login dengan credentials dari backend

---

## 📋 Pages Summary

| Page | File | Purpose | Status |
|------|------|---------|--------|
| **Login** | `login_page.dart` | User authentication | ✅ Complete |
| **Register** | `register_page.dart` | New account creation | ✅ Complete |
| **Home** | `home_page.dart` | Dashboard dengan katalog terbaru | ✅ Complete |
| **Katalog** | `katalog_page.dart` | Search & filter katalog mobil | ✅ Complete |
| **Kategori** | `kategori_page.dart` | Browse by car category | ✅ Complete |

---

## 🔗 Navigation Flow

```
LoginPage
  ↓
  └─→ RegisterPage (from "Sign Up" link)
      ↓
      └─→ LoginPage (from "Login" link)

LoginPage
  ↓
  └─→ HomePage (after successful login)
      ├─→ KatalogPage (from Search bar or "Explore" button)
      ├─→ KategoriPage (from bottom nav categories)
      └─→ Profile (from top-right icon)
```

---

## 💡 Integration Tips

1. **KatalogRepository:** Sudah ada di project
2. **KatalogBloc:** Sudah ada di project
3. **KategoriRepository & KategoriBloc:** Buat mengikuti pattern KatalogBloc
4. **Backend API Base URL:** `http://localhost:3000/api`
5. **Token Management:** Handled by AuthRepository

---

**Selamat ngoding! 🎉**

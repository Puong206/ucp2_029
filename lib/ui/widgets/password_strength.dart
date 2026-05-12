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
            color: Color(0xFFEEEEEE),
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
            color: _getStrengthColor(strength),
            fontWeight: FontWeight.w500,
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
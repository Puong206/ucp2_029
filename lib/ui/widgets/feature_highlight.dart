import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class FeatureHighlight extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const FeatureHighlight({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.surfaceColor,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Mont',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Mont',
            fontSize: 11,
            color: AppTheme.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
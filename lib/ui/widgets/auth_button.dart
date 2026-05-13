import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final double? width;
  final double height;

  const AuthButton({
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
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
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Mont',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.surfaceColor,
                        ),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Mont',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
    );
  }
}
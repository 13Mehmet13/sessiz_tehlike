import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.semanticsLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final Future<void> Function()? onPressed;
  final String semanticsLabel;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: ElevatedButton.icon(
        onPressed: onPressed == null || isLoading ? null : () => onPressed!(),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
        label: Text(isLoading ? 'İşleniyor...' : label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}

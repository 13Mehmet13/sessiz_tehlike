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
  });

  final String label;
  final IconData icon;
  final Future<void> Function()? onPressed;
  final String semanticsLabel;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: ElevatedButton.icon(
        onPressed: onPressed == null ? null : () => onPressed!.call(),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}

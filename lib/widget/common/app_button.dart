import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function() onClick;
  final String label;
  final bool isLoading;
  final Color? backgroundColor;
  const AppButton({
    super.key,
    required this.onClick,
    this.isLoading = false,
    required this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onClick,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor == null
                    ? Theme.of(context).primaryColor
                    : backgroundColor,
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

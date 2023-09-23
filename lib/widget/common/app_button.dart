import 'package:flutter/material.dart';
import 'package:agotaxi/enums/ButtonTypes.dart';

class AppButton extends StatelessWidget {
  final Function() onClick;
  final String label;
  final ButtonTypes type;
  final bool isLoading;
  final Color? backgroundColor;
  const AppButton({
    super.key,
    required this.onClick,
    this.type = ButtonTypes.filled,
    this.isLoading = false,
    required this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor == null
              ? type == ButtonTypes.filled
                  ? Theme.of(context).primaryColor
                  : Colors.white
              : backgroundColor,
          borderRadius: BorderRadius.circular(
            8,
          ),
          border: type == ButtonTypes.filled
              ? null
              : Border.all(color: Colors.grey.shade600),
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
                style: TextStyle(
                  letterSpacing: 0.5,
                  color:
                      type == ButtonTypes.filled ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

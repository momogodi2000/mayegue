import 'package:flutter/material.dart';
import '../../themes/colors.dart';

/// Loading Widget - Reusable loading indicator component
class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool showMessage;

  const LoadingWidget({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
              strokeWidth: 3,
            ),
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.onSurface.withValues(alpha: 178),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading Overlay - Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withValues(alpha: 127),
            child: LoadingWidget(
              color: indicatorColor ?? Colors.white,
              message: message,
            ),
          ),
      ],
    );
  }
}

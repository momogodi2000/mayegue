import 'package:flutter/material.dart';

/// Custom button widget with consistent styling across the app
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final bool isCompact;
  final IconData? icon;
  final Widget? child;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.isCompact = false,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default colors
    final defaultBackgroundColor = backgroundColor ?? theme.primaryColor;
    final defaultTextColor = textColor ??
        (backgroundColor == Colors.white ? theme.primaryColor : Colors.white);

    return SizedBox(
      width: isCompact ? null : (width ?? double.infinity),
      height: height ?? (isCompact ? 36 : 50),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBackgroundColor,
          foregroundColor: defaultTextColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
          elevation: backgroundColor == Colors.white ? 0 : 2,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                ),
              )
            : child ??
                (icon != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: defaultTextColor,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      )),
      ),
    );
  }
}

/// Custom outlined button
class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final IconData? icon;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderColor = borderColor ?? theme.primaryColor;
    final defaultTextColor = textColor ?? theme.primaryColor;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: defaultTextColor,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          side: BorderSide(color: defaultBorderColor, width: 1.5),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultTextColor),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: defaultTextColor,
                        ),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: defaultTextColor,
                    ),
                  ),
      ),
    );
  }
}

/// Custom text button
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final IconData? icon;
  final TextStyle? textStyle;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.icon,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextColor = textColor ?? theme.primaryColor;

    return TextButton(
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: defaultTextColor),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: defaultTextColor,
                      ),
                ),
              ],
            )
          : Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: defaultTextColor,
                  ),
            ),
    );
  }
}
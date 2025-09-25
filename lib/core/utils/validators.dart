import 'package:intl/intl.dart';

/// Validation utilities
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    // Sanitize input
    final sanitized = value.trim().toLowerCase();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(sanitized)) {
      return 'Format d\'email invalide';
    }
    // Check for suspicious patterns
    if (sanitized.contains('..') || sanitized.startsWith('.') || sanitized.endsWith('.')) {
      return 'Format d\'email invalide';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    // Check for at least one uppercase, one lowercase, one digit
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    
    if (!hasUpper || !hasLower || !hasDigit) {
      return 'Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    // Sanitize input - remove potentially dangerous characters
    final sanitized = value.trim().replaceAll(RegExp(r'[<>"/\\|?*\x00-\x1f]'), '');
    if (sanitized.length < 2) {
      return 'Doit contenir au moins 2 caractères';
    }
    if (sanitized.length > 50) {
      return 'Ne doit pas dépasser 50 caractères';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    // Sanitize input - only allow numbers, spaces, hyphens, plus
    final sanitized = value.replaceAll(RegExp(r'[^\d\s\-\+]'), '');
    final phoneRegex = RegExp(r'^\+?[0-9\s\-]{8,15}$');
    if (!phoneRegex.hasMatch(sanitized)) {
      return 'Format de numéro invalide';
    }
    return null;
  }

  static String? validateTextInput(String? value, {int minLength = 1, int maxLength = 1000, String fieldName = 'Ce champ'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    // Sanitize input - basic XSS prevention
    final sanitized = value.trim().replaceAll(RegExp(r'<[^>]*>'), '');
    if (sanitized.length < minLength) {
      return '$fieldName doit contenir au moins $minLength caractères';
    }
    if (sanitized.length > maxLength) {
      return '$fieldName ne doit pas dépasser $maxLength caractères';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    final urlRegex = RegExp(r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
    if (!urlRegex.hasMatch(value)) {
      return 'Format d\'URL invalide';
    }
    return null;
  }
}

/// Formatting utilities
class Formatters {
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatCurrency(double amount, {String currency = 'FCFA'}) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: currency,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

/// Extension utilities
extension StringExtensions on String {
  String capitalize() {
    return Formatters.capitalize(this);
  }

  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegex.hasMatch(this);
  }
}

extension DateTimeExtensions on DateTime {
  String format({String format = 'dd/MM/yyyy'}) {
    return Formatters.formatDate(this, format: format);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

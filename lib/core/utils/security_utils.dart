import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Security utilities for encryption, hashing, and data protection
class SecurityUtils {
  /// Hash a password using SHA-256 (for client-side operations)
  /// Note: In production, use proper password hashing like bcrypt on server
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Generate a simple salt for password hashing
  static String generateSalt() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(random);
    final hash = sha256.convert(bytes);
    return hash.toString().substring(0, 16);
  }

  /// Sanitize user input to prevent XSS attacks
  static String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll('\'', '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Validate input against SQL injection patterns
  static bool isSqlInjectionSafe(String input) {
    final dangerousPatterns = [
      RegExp(r';\s*--'),
      RegExp(r';\s*/\*'),
      RegExp(r'union\s+select', caseSensitive: false),
      RegExp(r'drop\s+table', caseSensitive: false),
      RegExp(r'exec\s*\(', caseSensitive: false),
      RegExp(r'xp_cmdshell', caseSensitive: false),
    ];

    return !dangerousPatterns.any((pattern) => pattern.hasMatch(input));
  }

  /// Check if string contains suspicious patterns
  static bool containsSuspiciousPatterns(String input) {
    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'eval\s*\(', caseSensitive: false),
      RegExp(r'document\.cookie', caseSensitive: false),
    ];

    return suspiciousPatterns.any((pattern) => pattern.hasMatch(input));
  }

  /// Generate a secure random token
  static String generateSecureToken({int length = 32}) {
    final random = DateTime.now().millisecondsSinceEpoch.toString() +
                   DateTime.now().microsecondsSinceEpoch.toString();
    final bytes = utf8.encode(random);
    final hash = sha256.convert(bytes);
    return hash.toString().substring(0, length);
  }

  /// Mask sensitive data for logging
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars * 2) {
      return '*' * data.length;
    }
    final start = data.substring(0, visibleChars);
    final end = data.substring(data.length - visibleChars);
    final masked = '*' * (data.length - visibleChars * 2);
    return '$start$masked$end';
  }

  /// Validate API key format
  static bool isValidApiKey(String apiKey) {
    // Basic validation - should be alphanumeric with specific length
    final apiKeyRegex = RegExp(r'^[A-Za-z0-9]{32,64}$');
    return apiKeyRegex.hasMatch(apiKey);
  }

  /// Rate limiting helper - check if request should be allowed
  static bool shouldAllowRequest(
    Map<String, dynamic> requestLog,
    String identifier,
    int maxRequests,
    Duration window,
  ) {
    final now = DateTime.now();
    final windowStart = now.subtract(window);

    // Clean old entries
    requestLog.removeWhere((key, value) {
      if (value is List) {
        value.removeWhere((timestamp) => timestamp.isBefore(windowStart));
        return value.isEmpty;
      }
      return true;
    });

    // Check current requests
    final requests = requestLog[identifier] as List<DateTime>? ?? [];
    return requests.length < maxRequests;
  }

  /// Log security event
  static void logSecurityEvent(String event, String details) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] SECURITY: $event - $details');
    // TODO: Send to security monitoring service
  }
}

/// Extension for secure string operations
extension SecureString on String {
  /// Check if string is safe from common attacks
  bool get isSecure {
    return SecurityUtils.isSqlInjectionSafe(this) &&
           !SecurityUtils.containsSuspiciousPatterns(this);
  }

  /// Sanitize the string
  String get sanitized => SecurityUtils.sanitizeInput(this);

  /// Mask the string for logging
  String get masked => SecurityUtils.maskSensitiveData(this);
}

/// Utility class for input validation
class Validators {
  /// Validate email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    if (password.isEmpty || password.length < 8) return false;

    // Must contain at least one letter and one number
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    return hasLetter && hasNumber;
  }

  /// Validate phone number (Cameroon format)
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;

    // Remove all non-digit characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Check for Cameroon phone number formats
    // +237XXXXXXXXX, 237XXXXXXXXX, 6XXXXXXXX, 2XXXXXXXX, 9XXXXXXXX
    if (cleanPhone.startsWith('237') && cleanPhone.length == 12) {
      return true;
    } else if (cleanPhone.length == 9 &&
        (cleanPhone.startsWith('6') || cleanPhone.startsWith('2') || cleanPhone.startsWith('9'))) {
      return true;
    }

    return false;
  }

  /// Validate name (letters, spaces, hyphens only)
  static bool isValidName(String name) {
    if (name.isEmpty || name.trim().length < 2) return false;

    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$");
    return nameRegex.hasMatch(name.trim());
  }

  /// Validate required field (not empty)
  static bool isRequired(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validate minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  /// Validate maximum length
  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }

  /// Validate numeric string
  static bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  /// Validate amount (positive number with max 2 decimal places)
  static bool isValidAmount(String amount) {
    if (amount.isEmpty) return false;

    final amountRegex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!amountRegex.hasMatch(amount)) return false;

    final numericValue = double.tryParse(amount);
    return numericValue != null && numericValue > 0;
  }

  /// Get email validation error message
  static String? getEmailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!isValidEmail(email)) return 'Invalid email format';
    return null;
  }

  /// Get password validation error message
  static String? getPasswordError(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) return 'Password must contain at least one letter';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Password must contain at least one number';
    return null;
  }

  /// Get phone number validation error message
  static String? getPhoneError(String phone) {
    if (phone.isEmpty) return 'Phone number is required';
    if (!isValidPhoneNumber(phone)) return 'Invalid phone number format';
    return null;
  }

  /// Get name validation error message
  static String? getNameError(String name) {
    if (name.trim().isEmpty) return 'Name is required';
    if (name.trim().length < 2) return 'Name must be at least 2 characters';
    if (!isValidName(name)) return 'Name can only contain letters, spaces, and hyphens';
    return null;
  }
}
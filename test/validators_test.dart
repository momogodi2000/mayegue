import 'package:flutter_test/flutter_test.dart';
import 'package:mayegue/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), null);
        expect(Validators.validateEmail('user.name+tag@example.co.uk'), null);
      });

      test('should return error for invalid email', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail('invalid-email'), isNotNull);
        expect(Validators.validateEmail('test@'), isNotNull);
        expect(Validators.validateEmail('@example.com'), isNotNull);
      });

      test('should return error for suspicious email patterns', () {
        expect(Validators.validateEmail('test..double@example.com'), isNotNull);
        expect(Validators.validateEmail('.test@example.com'), isNotNull);
        expect(Validators.validateEmail('test.@example.com'), isNotNull);
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        expect(Validators.validatePassword('Password123'), null);
        expect(Validators.validatePassword('MySecurePass1'), null);
      });

      test('should return error for invalid password', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword('123'), isNotNull);
        expect(Validators.validatePassword('password'), isNotNull); // no uppercase
        expect(Validators.validatePassword('PASSWORD'), isNotNull); // no lowercase
        expect(Validators.validatePassword('Password'), isNotNull); // no digit
      });
    });

    group('validateName', () {
      test('should return null for valid name', () {
        expect(Validators.validateName('John'), null);
        expect(Validators.validateName('Marie-Claire'), null);
      });

      test('should return error for invalid name', () {
        expect(Validators.validateName(''), isNotNull);
        expect(Validators.validateName('A'), isNotNull);
        expect(Validators.validateName('A' * 51), isNotNull); // too long
      });

      test('should sanitize dangerous characters', () {
        expect(Validators.validateName('John<script>'), null); // should be sanitized
      });
    });

    group('validatePhone', () {
      test('should return null for valid phone', () {
        expect(Validators.validatePhone('+237123456789'), null);
        expect(Validators.validatePhone('123456789'), null);
      });

      test('should return error for invalid phone', () {
        expect(Validators.validatePhone(''), isNotNull);
        expect(Validators.validatePhone('abc'), isNotNull);
        expect(Validators.validatePhone('123'), isNotNull);
      });
    });

    group('validateTextInput', () {
      test('should return null for valid input', () {
        expect(Validators.validateTextInput('Valid input'), null);
      });

      test('should return error for invalid input', () {
        expect(Validators.validateTextInput(''), isNotNull);
        expect(Validators.validateTextInput('A', minLength: 2), isNotNull);
        expect(Validators.validateTextInput('A' * 1001, maxLength: 1000), isNotNull);
      });
    });
  });
}

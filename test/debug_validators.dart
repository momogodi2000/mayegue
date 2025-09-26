import 'package:mayegue/core/utils/validators.dart';

void main() {
  // Test email
  print('Email test..double@example.com: ${Validators.getEmailError('test..double@example.com')}');

  // Test name
  print('Name A: ${Validators.getNameError('A')}');

  // Test phone
  print('Phone +237123456789: ${Validators.getPhoneError('+237123456789')}');
  print('Phone isValidPhoneNumber: ${Validators.isValidPhoneNumber('+237123456789')}');

  // Test text input
  print('Text input A*1001: ${Validators.validateTextInput('A' * 1001, maxLength: 1000)}');
  print('Length of A*1001: ${('A' * 1001).length}');
}
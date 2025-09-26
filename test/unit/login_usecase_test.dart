import 'package:flutter_test/flutter_test.dart';
import 'package:mayegue/features/authentication/domain/usecases/login_usecase.dart';

// Simple mock repository for testing
class TestAuthRepository {
  Future<Map<String, dynamic>> signInWithEmailAndPassword(String email, String password) async {
    if (email == 'valid@example.com' && password == 'validpass') {
      return {
        'user': {'id': 'user123', 'email': email, 'createdAt': DateTime.now().toIso8601String()},
        'success': true,
        'message': 'Login successful'
      };
    } else {
      throw Exception('Invalid credentials');
    }
  }
}

void main() {
  late LoginUsecase usecase;

  setUp(() {
    final mockRepository = TestAuthRepository();
    usecase = LoginUsecase(mockRepository as dynamic);
  });

  test('should be instantiated correctly', () {
    expect(usecase, isNotNull);
  });

  test('should have call method', () {
    expect(usecase.call, isNotNull);
  });
}
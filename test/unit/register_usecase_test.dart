import 'package:flutter_test/flutter_test.dart';
import 'package:mayegue/features/authentication/domain/usecases/register_usecase.dart';
import 'package:mayegue/features/authentication/domain/repositories/auth_repository.dart';
import 'package:mockito/mockito.dart';

// Mock repository for testing
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(mockRepository);
  });

  test('should be instantiated correctly', () {
    expect(usecase, isNotNull);
  });

  test('should have call method', () {
    expect(usecase.call, isNotNull);
  });
}
import '../repositories/auth_repository.dart';
import '../entities/auth_response_entity.dart';

class AppleSignInUsecase {
  final AuthRepository repository;
  AppleSignInUsecase(this.repository);

  Future<AuthResponseEntity> call() async {
    return await repository.signInWithApple();
  }
}

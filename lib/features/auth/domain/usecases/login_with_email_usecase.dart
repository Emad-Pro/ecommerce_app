import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmailUsecase {
  final AuthRepository repository;

  LoginWithEmailUsecase(this.repository);

  Future<void> call(String email, String password) async {
    return await repository.loginWithEmail(email, password);
  }
}

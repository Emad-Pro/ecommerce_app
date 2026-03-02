import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> call(String otpCode) async {
    return await repository.verifyPhoneOtp(otpCode);
  }
}

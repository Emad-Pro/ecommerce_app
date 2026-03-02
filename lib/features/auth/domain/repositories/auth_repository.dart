abstract class AuthRepository {
  Future<void> loginWithEmail(String email, String password);
  Future<void> verifyPhoneOtp(String otpCode);
  bool checkAuthStatus();
}

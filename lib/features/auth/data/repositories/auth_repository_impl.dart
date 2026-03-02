import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<void> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    await localDataSource.saveLoginState(true);
  }

  @override
  Future<void> verifyPhoneOtp(String otpCode) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otpCode == '0000') {
      await localDataSource.saveLoginState(true);
    } else {
      throw Exception('كود التحقق غير صحيح');
    }
  }

  @override
  bool checkAuthStatus() {
    return localDataSource.isUserLoggedIn();
  }
}

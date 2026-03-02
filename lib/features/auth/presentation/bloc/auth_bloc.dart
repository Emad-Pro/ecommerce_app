import 'package:ecommerce_app/features/auth/domain/usecases/login_with_email_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/verfiy_otp_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailUsecase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({required this.loginUseCase, required this.verifyOtpUseCase, required this.checkAuthStatusUseCase})
    : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) {
      final isLoggedIn = checkAuthStatusUseCase();
      if (isLoggedIn) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthInitial());
      }
    });

    on<LoginRequestedEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await loginUseCase(event.email, event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: 'حدث خطأ أثناء تسجيل الدخول'));
      }
    });

    on<VerifyOtpRequestedEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await verifyOtpUseCase(event.otpCode);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: 'كود التحقق غير صحيح، يرجى إدخال 0000'));
      }
    });
  }
}

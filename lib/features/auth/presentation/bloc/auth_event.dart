abstract class AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  LoginRequestedEvent({required this.email, required this.password});
}

class VerifyOtpRequestedEvent extends AuthEvent {
  final String otpCode;
  VerifyOtpRequestedEvent({required this.otpCode});
}

class CheckAuthStatusEvent extends AuthEvent {}

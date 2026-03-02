import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginUiState extends Equatable {
  final bool isEmailLogin;
  final bool showOtpField;
  final String email;
  final String password;
  final String phone;
  final String otp;

  LoginUiState({
    this.isEmailLogin = true,
    this.showOtpField = false,
    this.email = '',
    this.password = '',
    this.phone = '',
    this.otp = '',
  });

  LoginUiState copyWith({
    bool? isEmailLogin,
    bool? showOtpField,
    String? email,
    String? password,
    String? phone,
    String? otp,
  }) {
    return LoginUiState(
      isEmailLogin: isEmailLogin ?? this.isEmailLogin,
      showOtpField: showOtpField ?? this.showOtpField,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isEmailLogin, showOtpField, email, password, phone, otp];
}

class LoginUiCubit extends Cubit<LoginUiState> {
  LoginUiCubit() : super(LoginUiState());
  init() {
    emit(state.copyWith(email: '', password: '', phone: '', otp: '', showOtpField: false));
  }

  void toggleLoginMethod(bool isEmail) {
    emit(state.copyWith(isEmailLogin: isEmail, showOtpField: false));
  }

  void showOtp() {
    if (state.phone.isNotEmpty) {
      emit(state.copyWith(showOtpField: true));
    }
  }

  void updateEmail(String val) => emit(state.copyWith(email: val));
  void updatePassword(String val) => emit(state.copyWith(password: val));
  void updatePhone(String val) => emit(state.copyWith(phone: val));
  void updateOtp(String val) => emit(state.copyWith(otp: val));
}

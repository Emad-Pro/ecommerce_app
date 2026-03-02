import 'package:ecommerce_app/core/constants/cached_key.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/ui/login_ui_cubit.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_tabbar.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:ecommerce_app/features/product/presentation/screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/depandcy_injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  String _confirmedIdentifier = '';
  String _confirmedLoginType = '';
  @override
  void initState() {
    sl<LoginUiCubit>().toggleLoginMethod(true);
    sl<LoginUiCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.surface, colorScheme.primaryContainer.withOpacity(0.3)],
            ),
          ),
          child: SafeArea(
            child: BlocConsumer<AuthBloc, AuthState>(
              bloc: sl<AuthBloc>(),
              listener: (context, authState) async {
                final uiState = sl<LoginUiCubit>().state;
                final prefs = sl<SharedPreferences>();
                if (authState is AuthError) {
                  _showSnackBar(context, authState.message, isError: true);
                } else if (authState is AuthAuthenticated) {
                  if (uiState.isEmailLogin) {
                    if (uiState.email.trim().isNotEmpty) {
                      await prefs.setString(userIdentifierKey, uiState.email);
                      await prefs.setString(loginTypeKey, 'email');
                    }
                  } else {
                    if (uiState.phone.trim().isNotEmpty) {
                      await prefs.setString(userIdentifierKey, uiState.phone);
                      await prefs.setString(loginTypeKey, 'phone');
                    }
                  }
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                  _showSnackBar(context, 'تم تسجيل الدخول بنجاح!', isError: false);
                }
              },
              builder: (context, authState) {
                final isLoading = authState is AuthLoading;

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                    child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 600),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(offset: Offset(0, 40 * (1 - value)), child: child),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.bolt_rounded, size: 48, color: colorScheme.primary),
                            const SizedBox(height: 24),
                            Text(
                              'مرحباً بك 👋',
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: colorScheme.onSurface),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'سجل دخولك لاستكشاف المنتجات',
                              style: TextStyle(fontSize: 15, color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 32),

                            BlocBuilder<LoginUiCubit, LoginUiState>(
                              bloc: sl<LoginUiCubit>(),
                              builder: (context, uiState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    AuthTabBar(
                                      isEmail: uiState.isEmailLogin,
                                      onTabChanged: (isEmail) => sl<LoginUiCubit>().toggleLoginMethod(isEmail),
                                    ),
                                    const SizedBox(height: 32),
                                    AnimatedCrossFade(
                                      duration: const Duration(milliseconds: 300),
                                      crossFadeState: uiState.isEmailLogin
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                      firstChild: _buildEmailForm(context, uiState, isLoading),
                                      secondChild: _buildPhoneForm(context, uiState, isLoading),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(BuildContext context, LoginUiState uiState, bool isLoading) {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            label: 'البريد الإلكتروني',
            hint: 'example@domain.com',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) => sl<LoginUiCubit>().updateEmail(val),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }

              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'صيغة البريد الإلكتروني غير صحيحة';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AuthTextField(
            label: 'كلمة المرور',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            onChanged: (val) => sl<LoginUiCubit>().updatePassword(val),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال كلمة المرور';
              }
              if (value.length < 6) {
                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          AuthButton(
            text: 'تسجيل الدخول',
            isLoading: isLoading,
            onPressed: () {
              if (_emailFormKey.currentState!.validate()) {
                _confirmedIdentifier = uiState.email;
                _confirmedLoginType = 'email';
                sl<AuthBloc>().add(LoginRequestedEvent(email: uiState.email, password: uiState.password));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneForm(BuildContext context, LoginUiState uiState, bool isLoading) {
    final colorScheme = Theme.of(context).colorScheme;
    final fillColor = colorScheme.surfaceContainerHighest;

    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: uiState.showOtpField ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الجوال',
                  style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 8),

                Directionality(
                  textDirection: TextDirection.ltr,
                  child: IntlPhoneField(
                    languageCode: "ar",
                    searchText: "البحث عن الدولة",
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                    decoration: InputDecoration(
                      hintText: '5X XXX XXXX',
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
                      filled: true,
                      fillColor: fillColor.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
                      ),
                    ),
                    initialCountryCode: 'SA',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w500),
                    dropdownTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                    dropdownIcon: Icon(Icons.arrow_drop_down_rounded, color: colorScheme.onSurfaceVariant),
                    invalidNumberMessage: 'رقم الجوال غير صحيح',

                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return 'يرجى إدخال رقم الجوال';
                      }
                      if (phone.number.length < 9) {
                        return 'رقم الجوال قصير جداً (يجب أن يكون 9 أرقام)';
                      }
                      if (phone.number.length > 9) {
                        return 'رقم الجوال أطول من اللازم';
                      }
                      if (!phone.number.startsWith('5')) {
                        return 'رقم الجوال السعودي يجب أن يبدأ بـ 5';
                      }
                      return null;
                    },

                    onChanged: (phone) {
                      _confirmedIdentifier = phone.completeNumber;
                      sl<LoginUiCubit>().updatePhone(phone.completeNumber);
                    },
                  ),
                ),
              ],
            ),

            secondChild: AuthTextField(
              label: 'كود التحقق',
              hint: '0000',
              icon: Icons.message_rounded,
              keyboardType: TextInputType.number,
              onChanged: (val) => sl<LoginUiCubit>().updateOtp(val),
              validator: (value) {
                if (!uiState.showOtpField) return null;

                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال كود التحقق';
                }
                if (value.length < 4) {
                  return 'الكود غير مكتمل';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 32),
          AuthButton(
            text: uiState.showOtpField ? 'تأكيد الدخول' : 'إرسال الكود',
            isLoading: isLoading,
            onPressed: () {
              if (!uiState.showOtpField) {
                if (_phoneFormKey.currentState!.validate()) {
                  sl<LoginUiCubit>().showOtp();
                }
              } else {
                if (_phoneFormKey.currentState!.validate()) {
                  _confirmedIdentifier = uiState.phone;
                  _confirmedLoginType = 'phone';
                  sl<AuthBloc>().add(VerifyOtpRequestedEvent(otpCode: uiState.otp));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {required bool isError}) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w600, color: isError ? colorScheme.onError : colorScheme.onPrimary),
        ),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}

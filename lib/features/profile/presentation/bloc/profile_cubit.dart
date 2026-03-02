import 'package:ecommerce_app/features/profile/domain/usecases/profile_usecases.dart';
import 'package:ecommerce_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/cached_key.dart';
import '../../../../core/di/depandcy_injection.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileDataUseCase getProfileDataUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileCubit({required this.getProfileDataUseCase, required this.logoutUseCase}) : super(ProfileInitial());

  Future<void> loadUserData() async {
    emit(ProfileLoading());
    final result = await getProfileDataUseCase();

    result.fold(
      (failure) => emit(ProfileError(failure.message ?? "فشل جلب بيانات المستخدم")),
      (profile) => emit(ProfileLoaded(userIdentifier: profile.identifier, isEmailLogin: profile.isEmail)),
    );
  }

  Future<void> logout() async {
    emit(ProfileLoading());
    final result = await logoutUseCase();

    result.fold((failure) => emit(ProfileError(failure.message ?? "فشل تسجيل الخروج")), (_) {
      sl<CartBloc>().add(ClearCartEvent()); // تفريغ السلة
      emit(ProfileLoggedOut());
    });
  }
}

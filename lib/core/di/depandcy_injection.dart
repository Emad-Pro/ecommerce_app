import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce_app/core/network/api_client.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_with_email_usecase.dart';
import '../../features/auth/domain/usecases/verfiy_otp_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/ui/login_ui_cubit.dart';

import '../../features/profile/data/data_sources/profile_local_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/presentation/bloc/profile_cubit.dart';

import '../../features/product/data/data_sources/product_remote_data_source.dart';
import '../../features/product/data/repositories/product_repostiory_impl.dart';
import '../../features/product/domain/repositories/product_repository_impl.dart';
import '../../features/product/domain/use_cases/get_products_usecase.dart';
import '../../features/product/presentation/bloc/products_bloc.dart';

import '../../features/cart/data/data_source/cart_local_data_source.dart';
import '../../features/cart/data/repository/cart_repostory_impl.dart';
import '../../features/cart/domain/repository/cart_repository.dart';
import '../../features/cart/domain/use_case/add_cart_usecase.dart';
import '../../features/cart/domain/use_case/clear_cart_item_usecase.dart';
import '../../features/cart/domain/use_case/decrement_cart_item_usecase.dart';
import '../../features/cart/domain/use_case/get_cart_usecase.dart';
import '../../features/cart/domain/use_case/remove_from_cart_usecase.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';

final sl = GetIt.instance;

class DepandcyInjection {
  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    sl.registerLazySingleton(() => DioService());

    sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sharedPreferences: sl()));

    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(localDataSource: sl()));

    sl.registerLazySingleton(() => LoginWithEmailUsecase(sl()));
    sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
    sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

    sl.registerLazySingleton(() => AuthBloc(loginUseCase: sl(), verifyOtpUseCase: sl(), checkAuthStatusUseCase: sl()));
    sl.registerLazySingleton(() => LoginUiCubit());

    sl.registerLazySingleton<ProfileLocalDataSource>(() => ProfileLocalDataSourceImpl(prefs: sl()));

    sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(localDataSource: sl()));

    sl.registerLazySingleton(() => GetProfileDataUseCase(sl()));
    sl.registerLazySingleton(() => LogoutUseCase(sl()));

    sl.registerLazySingleton(() => ProfileCubit(getProfileDataUseCase: sl(), logoutUseCase: sl()));

    sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio: sl()));

    sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));

    sl.registerLazySingleton(() => GetProductsUseCase(sl()));

    sl.registerLazySingleton(() => ProductsBloc(getProductsUseCase: sl()));

    sl.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(sharedPreferences: sl()));

    sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(localDataSource: sl()));

    sl.registerLazySingleton(() => GetCartItemsUseCase(sl()));
    sl.registerLazySingleton(() => AddToCartUseCase(sl()));
    sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
    sl.registerLazySingleton(() => DecrementCartItemUseCase(sl()));
    sl.registerLazySingleton(() => ClearCartItemUseCase(sl()));

    sl.registerLazySingleton(
      () => CartBloc(
        getCartItemsUseCase: sl(),
        addToCartUseCase: sl(),
        removeFromCartUseCase: sl(),
        decrementCartItemUseCase: sl(),
        clearCartItemUseCase: sl(),
      ),
    );
  }
}

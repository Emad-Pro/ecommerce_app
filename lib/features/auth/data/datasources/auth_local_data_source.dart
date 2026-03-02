import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/cached_key.dart';

abstract class AuthLocalDataSource {
  Future<void> saveLoginState(bool isLoggedIn);
  bool isUserLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveLoginState(bool isLoggedIn) async {
    await sharedPreferences.setBool(authKey, isLoggedIn);
  }

  @override
  bool isUserLoggedIn() {
    return sharedPreferences.getBool(authKey) ?? false;
  }
}

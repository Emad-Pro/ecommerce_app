// lib/features/profile/data/data_sources/profile_local_data_source.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/cached_key.dart';

abstract class ProfileLocalDataSource {
  Future<Map<String, dynamic>> getUserData();
  Future<void> clearUserData();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences prefs;

  ProfileLocalDataSourceImpl({required this.prefs});

  @override
  Future<Map<String, dynamic>> getUserData() async {
    final identifier = prefs.getString(userIdentifierKey) ?? 'غير مسجل';
    final isEmail = prefs.getString(loginTypeKey) == 'email';
    return {'identifier': identifier, 'isEmail': isEmail};
  }

  @override
  Future<void> clearUserData() async {
    await prefs.clear();
  }
}

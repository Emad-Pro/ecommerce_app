// lib/features/profile/data/repositories/profile_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/error_handler.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/errors/server_failure.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getUserData() async {
    try {
      final data = await localDataSource.getUserData();
      return Right(ProfileEntity(identifier: data['identifier'], isEmail: data['isEmail']));
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle('فشل في جلب بيانات المستخدم')));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await localDataSource.clearUserData();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(error: ErrorHandler.handle('فشل في تسجيل الخروج')));
    }
  }
}

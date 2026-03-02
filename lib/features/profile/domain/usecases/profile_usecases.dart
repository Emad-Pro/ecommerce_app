// lib/features/profile/domain/usecases/profile_usecases.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileDataUseCase {
  final ProfileRepository repository;
  GetProfileDataUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call() async {
    return await repository.getUserData();
  }
}

class LogoutUseCase {
  final ProfileRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.logout();
  }
}

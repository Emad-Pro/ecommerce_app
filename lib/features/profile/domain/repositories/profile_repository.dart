// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';

import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getUserData();
  Future<Either<Failure, Unit>> logout();
}

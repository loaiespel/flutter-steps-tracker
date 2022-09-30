import 'package:dartz/dartz.dart';
import 'package:foot_steps/core/data/error/failures/application_failure.dart';
import 'package:foot_steps/utilities/constants/enums.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signInAnonymously(String name);
  Future<AuthStatus> hasAnAccount();
}

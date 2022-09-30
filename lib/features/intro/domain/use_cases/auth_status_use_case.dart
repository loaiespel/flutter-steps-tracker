import 'package:foot_steps/core/domain/use_cases/use_case.dart';
import 'package:foot_steps/features/intro/domain/repositories/auth_repository.dart';
import 'package:foot_steps/utilities/constants/enums.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthStatusUseCase extends UseCase<Future<AuthStatus>, NoParams> {
  final AuthRepository _authRepository;

  AuthStatusUseCase(this._authRepository);

  @override
  Future<AuthStatus> call(NoParams params) async =>
      await _authRepository.hasAnAccount();
}

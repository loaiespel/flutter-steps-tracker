import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foot_steps/core/data/error/failures/firebase_auth_failure.dart';
import 'package:foot_steps/features/intro/domain/use_cases/sign_in_anonymously_use_case.dart';
import 'package:foot_steps/features/intro/presentation/manager/auth_actions/auth_state.dart';
import 'package:foot_steps/generated/l10n.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  final SignInAnonymouslyUseCase _signInAnonymouslyUseCase;

  AuthCubit(
    this._signInAnonymouslyUseCase,
  ) : super(const AuthState.initial());

  Future<void> signInAnonymously({required String name}) async {
    emit(const AuthState.loading());
    final result = await _signInAnonymouslyUseCase(name);
    emit(
      result.fold(
        (failure) {
          if (failure is FirebaseAuthFailure) {
            failure.maybeWhen(
                orElse: () =>
                    AuthState.error(message: S.current.somethingWentWrong),
                operationNotAllowed: (message) =>
                    AuthState.error(message: message));
          }
          return AuthState.error(message: S.current.somethingWentWrong);
        },
        (_) => const AuthState.loggedIn(),
      ),
    );
  }
}

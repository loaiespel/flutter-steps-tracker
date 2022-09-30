import 'package:dartz/dartz.dart';
import 'package:foot_steps/core/data/error/failures/application_failure.dart';
import 'package:foot_steps/core/domain/use_cases/use_case.dart';
import 'package:foot_steps/features/bottom_navbar/data/models/exchange_history_model.dart';
import 'package:foot_steps/features/bottom_navbar/domain/repositories/bottom_navbar_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHistoryExchangesUseCase extends UseCase<
    Future<Either<Failure, Stream<List<ExchangeHistoryModel>>>>, NoParams> {
  final BottomNavbarRepository _bottomNavbarRepository;

  GetHistoryExchangesUseCase(this._bottomNavbarRepository);

  @override
  Future<Either<Failure, Stream<List<ExchangeHistoryModel>>>> call(
          NoParams params) async =>
      await _bottomNavbarRepository.exchangesHistoryStream();
}

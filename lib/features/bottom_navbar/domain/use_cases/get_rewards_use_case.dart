import 'package:foot_steps/core/domain/use_cases/use_case.dart';
import 'package:foot_steps/features/bottom_navbar/data/models/reward_model.dart';
import 'package:foot_steps/features/bottom_navbar/domain/repositories/bottom_navbar_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRewardsUseCase extends UseCase<Stream<List<RewardModel>>, NoParams> {
  final BottomNavbarRepository _bottomNavbarRepository;

  GetRewardsUseCase(this._bottomNavbarRepository);

  @override
  Stream<List<RewardModel>> call(NoParams params) =>
      _bottomNavbarRepository.rewardsStream();
}

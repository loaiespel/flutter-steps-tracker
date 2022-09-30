import 'package:foot_steps/core/data/models/user_model.dart';
import 'package:foot_steps/features/bottom_navbar/domain/entities/leaderboard_item_entity.dart';

extension UserModelToMapper on List<UserModel> {
  List<LeaderboardItemEntity> toEntity() => map((e) => LeaderboardItemEntity(
        uid: e.uid ??'1',
        name: e.name??'loai',
        stepsNumber: e.totalSteps,
        order: 0,
        healthPoints: e.healthPoints,
      )).toList();
}

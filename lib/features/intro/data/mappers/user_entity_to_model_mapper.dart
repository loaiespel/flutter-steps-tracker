import 'package:foot_steps/core/data/data_sources/database.dart';
import 'package:foot_steps/core/data/models/user_model.dart';
import 'package:foot_steps/features/intro/domain/entities/user_entity.dart';

extension UserEntityToModelMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      uid: uid ?? documentIdFromLocalGenerator(),
      name: name,
    );
  }
}

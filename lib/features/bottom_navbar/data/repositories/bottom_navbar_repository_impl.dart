import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:foot_steps/core/data/data_sources/database.dart';
import 'package:foot_steps/core/data/error/exceptions/application_exception.dart';
import 'package:foot_steps/core/data/error/failures/application_failure.dart';
import 'package:foot_steps/core/data/models/steps_and_points_model.dart';
import 'package:foot_steps/core/data/models/user_model.dart';
import 'package:foot_steps/features/bottom_navbar/data/models/exchange_history_model.dart';
import 'package:foot_steps/features/bottom_navbar/data/models/reward_model.dart';
import 'package:foot_steps/features/bottom_navbar/domain/repositories/bottom_navbar_repository.dart';
import 'package:foot_steps/features/intro/data/data_sources/auth_local_data_source.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: BottomNavbarRepository)
class BottomNavbarRepositoryImpl implements BottomNavbarRepository {
  final Database _database;
  final AuthLocalDataSource _authLocalDataSource;

  BottomNavbarRepositoryImpl(
    this._database,
    this._authLocalDataSource,
  );

  @override
  Stream<List<RewardModel>> rewardsStream() {
    return _database.rewardsStream();
  }

  @override
  Future<Either<Failure, bool>> setExchangeHistory(
      ExchangeHistoryModel exchangeHistory) async {
    try {
      final user = await _authLocalDataSource.currentUser();
      await _database.setExchangeHistory(
        exchangeHistory,
        user!.uid??'1',
      );
      return const Right(true);
    } on ApplicationException catch (e) {
      return Left(
        firebaseExceptionsDecoder(e),
      );
    }
  }

  @override
  Future<Either<Failure, Stream<List<ExchangeHistoryModel>>>>
      exchangesHistoryStream() async {
    try {
      final user = await _authLocalDataSource.currentUser();
      return Right(_database.exchangeHistoryStream(user!.uid??'1'));
    } on ApplicationException catch (e) {
      return Left(
        firebaseExceptionsDecoder(e),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> setStepsAndPoints(int steps) async {
    try {
      final user = await _authLocalDataSource.currentUser();
      var totalHealthPoints = 0;
      int healthPoints = (steps ~/ 100) * 5;
      await _database.setDailySteps(
        StepsAndPointsModel(
          id: documentIdForDailyUse(),
          steps: steps,
          points: healthPoints,
        ),
        user!.uid??'1',
      );
      var myRewardsList = await _database.myRewardsStream(user.uid??'1').first;
      int deletedPoints = 0;
      for (var reward in myRewardsList) {
        deletedPoints += reward.points;
      }
      totalHealthPoints = healthPoints - deletedPoints;
      final newUser = UserModel(
        uid: user.uid,
        name: user.name,
        totalSteps: steps,
        healthPoints: totalHealthPoints,
      );
      await _database.setUserData(newUser);
      await _authLocalDataSource.persistAuth(newUser);
      return const Right(true);
    } on ApplicationException catch (e) {
      return Left(
        firebaseExceptionsDecoder(e),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      final user = await _authLocalDataSource.currentUser();
      return Right(user!);
    } on ApplicationException catch (e) {
      return Left(
        firebaseExceptionsDecoder(e),
      );
    }
  }

  @override
  Future<Either<Failure, Stream<UserModel>>> getRealTimeUserData() async {
    try {
      final user = await _authLocalDataSource.currentUser();
      return Right(_database.getUserStream(user!.uid??'1'));
    } on ApplicationException catch (e) {
      return Left(
        firebaseExceptionsDecoder(e),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> earnAReward(RewardModel reward) async {
    try {
      final user = await _authLocalDataSource.currentUser();
      await _database.setRewardOrder(
        reward.copyWith(
          id: documentIdFromLocalGenerator(),
        ),
        user!.uid??'1',
      );
      var realUserData = await _database.getUserStream(user.uid??'1').first;
      await _database.setUserData(
        realUserData.copyWith(
            healthPoints: realUserData.healthPoints - reward.points),
      );
      return const Right(true);
    } on ApplicationException catch (e) {
      return Left(
        firebaseExceptionsDecoder(e),
      );
    }
  }

  @override
  Future<Either<Failure, Stream<List<UserModel>>>> usersStream() async {
    try {
      return Right(_database.usersStream());
    } on ApplicationException catch (e) {
      return Left(
        firebaseExceptionsDecoder(e),
      );
    }
  }
}

import 'package:flutter_application_trek_e/features/home/data/data_source/home_datasource.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_trek_e/features/home/data/model/trek_hive_model.dart';
import 'package:flutter_application_trek_e/features/home/data/model/review_hive_model.dart';
import 'package:flutter_application_trek_e/app/constant/hive_table_constant.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

class HomeLocalDataSource implements IHomeLocalDataSource {
  late Box<TrekHiveModel> _trekBox;
  late Box<ReviewHiveModel> _reviewBox;

  /// Initialize Hive boxes and register adapters if not registered yet
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(HiveTableConstant.trekTableId)) {
      Hive.registerAdapter(TrekHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.reviewTableId)) {
      Hive.registerAdapter(ReviewHiveModelAdapter());
    }

    _trekBox = await Hive.openBox<TrekHiveModel>(HiveTableConstant.trekBox);
    _reviewBox = await Hive.openBox<ReviewHiveModel>(HiveTableConstant.reviewBox);
  }

  @override
  Future<void> cacheTreks(List<TrekEntity> treks) async {
    await _trekBox.clear(); // Clear old cached data
    for (var trek in treks) {
      final hiveModel = TrekHiveModel.fromEntity(trek);
      await _trekBox.put(hiveModel.id, hiveModel);
    }
  }

  @override
  Future<List<TrekEntity>> getCachedTreks() async {
    final hiveModels = _trekBox.values.toList();
    return hiveModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> clearCache() async {
    await _trekBox.clear();
  }

  @override
  Future<List<ReviewEntity>> getReviews(String trekId) async {
    final reviews = _reviewBox.values
        .where((review) => review.trekId == trekId)
        .map((reviewHive) => reviewHive.toEntity())
        .toList();
    return reviews;
  }

  @override
  Future<List<ReviewEntity>> getAllReviewsFromAllTreks() async {
    return _reviewBox.values.map((reviewHive) => reviewHive.toEntity()).toList();
  }

  Future<void> close() async {
    await _trekBox.close();
    await _reviewBox.close();
  }
}

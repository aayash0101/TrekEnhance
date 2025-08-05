import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/add_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/favorite_journal_params.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/is_journal_favorite_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/remove_favorite_journal_usecase.dart';

class ToggleFavoriteJournalUseCase {
  final FavoriteJournalUseCase favoriteJournalUseCase;
  final UnfavoriteJournalUseCase unfavoriteJournalUseCase;
  final IsJournalFavoritedUseCase isJournalFavoritedUseCase;

  ToggleFavoriteJournalUseCase({
    required this.favoriteJournalUseCase,
    required this.unfavoriteJournalUseCase,
    required this.isJournalFavoritedUseCase,
  });

  Future<Either<Failure, bool>> call(FavoriteJournalParams params) async {
    // First check if journal is already favorited
    final isAlreadyFavorited = await isJournalFavoritedUseCase(params);
    
    return isAlreadyFavorited.fold(
      (failure) => Left(failure),
      (isFavorited) async {
        if (isFavorited) {
          // If already favorited, unfavorite it
          return await unfavoriteJournalUseCase(params);
        } else {
          // If not favorited, favorite it
          return await favoriteJournalUseCase(params);
        }
      },
    );
  }
}
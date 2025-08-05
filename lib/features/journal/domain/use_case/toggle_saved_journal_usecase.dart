import 'package:dartz/dartz.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/add_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/is_journal_saved_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/remove_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/saved_journal_params.dart';

class ToggleSaveJournalUseCase {
  final SaveJournalUseCase saveJournalUseCase;
  final UnsaveJournalUseCase unsaveJournalUseCase;
  final IsJournalSavedUseCase isJournalSavedUseCase;

  ToggleSaveJournalUseCase({
    required this.saveJournalUseCase,
    required this.unsaveJournalUseCase,
    required this.isJournalSavedUseCase,
  });

  Future<Either<Failure, bool>> call(SaveJournalParams params) async {
    // First check if journal is already saved
    final isAlreadySaved = await isJournalSavedUseCase(params);
    
    return isAlreadySaved.fold(
      (failure) => Left(failure),
      (isSaved) async {
        if (isSaved) {
          // If already saved, unsave it
          return await unsaveJournalUseCase(params);
        } else {
          // If not saved, save it
          return await saveJournalUseCase(params);
        }
      },
    );
  }
}
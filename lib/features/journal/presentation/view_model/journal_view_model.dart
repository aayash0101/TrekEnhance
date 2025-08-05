import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/create_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/delete_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_all_journals_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journal_with_status_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journals_by_trek_and_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journals_by_user_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/toggle_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/update_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/add_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/remove_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/add_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/remove_saved_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/is_journal_favorite_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/is_journal_saved_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/toggle_favorite_journal_usecase.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/favorite_journal_params.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/saved_journal_params.dart';
import 'package:flutter_application_trek_e/features/journal/domain/use_case/get_journal_with_status_params.dart';

import 'journal_event.dart';
import 'journal_state.dart';

class JournalViewModel extends Bloc<JournalEvent, JournalState> {
  final CreateJournalUsecase createJournalUsecase;
  final GetAllJournalsUsecase getAllJournalsUsecase;
  final GetJournalsByTrekAndUserUsecase getJournalsByTrekAndUserUsecase;
  final GetJournalsByUserUsecase getJournalsByUserUsecase;
  final UpdateJournalUsecase updateJournalUsecase;
  final DeleteJournalUsecase deleteJournalUsecase;
  final GetSavedJournalsUseCase getSavedJournalsUseCase;
  final GetFavoriteJournalsUseCase getFavoriteJournalsUseCase;
  final FavoriteJournalUseCase favoriteJournalUseCase;
  final UnfavoriteJournalUseCase unfavoriteJournalUseCase;
  final SaveJournalUseCase saveJournalUseCase;
  final UnsaveJournalUseCase unsaveJournalUseCase;
  final IsJournalFavoritedUseCase isJournalFavoritedUseCase;
  final IsJournalSavedUseCase isJournalSavedUseCase;
  final ToggleFavoriteJournalUseCase toggleFavoriteJournalUseCase;
  final ToggleSaveJournalUseCase toggleSaveJournalUseCase;
  final GetJournalsWithStatusUseCase getJournalsWithStatusUseCase;

  final Set<String> _savingJournals = {};
  final Set<String> _favoritingJournals = {};

  JournalViewModel({
    required this.createJournalUsecase,
    required this.getAllJournalsUsecase,
    required this.getJournalsByTrekAndUserUsecase,
    required this.getJournalsByUserUsecase,
    required this.updateJournalUsecase,
    required this.deleteJournalUsecase,
    required this.getSavedJournalsUseCase,
    required this.getFavoriteJournalsUseCase,
    required this.favoriteJournalUseCase,
    required this.unfavoriteJournalUseCase,
    required this.saveJournalUseCase,
    required this.unsaveJournalUseCase,
    required this.isJournalFavoritedUseCase,
    required this.isJournalSavedUseCase,
    required this.toggleFavoriteJournalUseCase,
    required this.toggleSaveJournalUseCase,
    required this.getJournalsWithStatusUseCase,
  }) : super(JournalInitial()) {
    on<FetchAllJournals>(_fetchAllJournals);
    on<FetchJournalsByUser>(_fetchJournalsByUser);
    on<FetchJournalsByTrekAndUser>(_fetchJournalsByTrekAndUser);
    on<CreateJournal>(_createJournal);
    on<UpdateJournal>(_updateJournal);
    on<DeleteJournal>(_deleteJournal);
    on<ToggleSaveJournal>(_toggleSaveJournal);
    on<ToggleFavoriteJournal>(_toggleFavoriteJournal);
    on<FilterJournals>(_filterJournals);
    on<ClearError>(_clearError);
  }

  Future<void> _fetchAllJournals(FetchAllJournals event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    final result = await getAllJournalsUsecase();

    await result.fold(
      (failure) async => emit(JournalError(message: failure.message)),
      (journals) async {
        final statusResult = await getJournalsWithStatusUseCase(
          GetJournalsWithStatusParams(journals: journals, userId: event.userId),
        );

        statusResult.fold(
          (failure) => emit(JournalError(message: failure.message)),
          (journalsWithStatus) => emit(JournalLoaded(
            journals: journalsWithStatus,
            filteredJournals: List.from(journalsWithStatus),
            savedJournals: [],
            favoriteJournals: [],
          )),
        );
      },
    );
  }

  Future<void> _fetchJournalsByUser(FetchJournalsByUser event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    final result = await getJournalsByUserUsecase(event.userId);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (journals) => _handleJournalsWithStatus(journals, event.userId, emit),
    );
  }

  Future<void> _fetchJournalsByTrekAndUser(FetchJournalsByTrekAndUser event, Emitter<JournalState> emit) async {
    emit(JournalLoading());
    final result = await getJournalsByTrekAndUserUsecase(
      trekId: event.trekId,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (journals) => _handleJournalsWithStatus(journals, event.userId, emit),
    );
  }

  Future<void> _handleJournalsWithStatus(List<JournalEntity> journals, String userId, Emitter<JournalState> emit) async {
    final statusResult = await getJournalsWithStatusUseCase(
      GetJournalsWithStatusParams(journals: journals, userId: userId),
    );

    statusResult.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (journalsWithStatus) => emit(JournalLoaded(
        journals: journalsWithStatus,
        filteredJournals: List.from(journalsWithStatus),
        savedJournals: [],
        favoriteJournals: [],
      )),
    );
  }

  Future<void> _createJournal(CreateJournal event, Emitter<JournalState> emit) async {
    final currentState = state;
    emit(JournalLoading());

    final result = await createJournalUsecase(
      userId: event.userId,
      trekId: event.trekId,
      date: event.date,
      text: event.text,
      photos: event.photos,
    );

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (newJournal) {
        if (currentState is JournalLoaded) {
          final updatedJournals = List<JournalEntity>.from(currentState.journals)..add(newJournal);
          emit(currentState.copyWith(
            journals: updatedJournals,
            filteredJournals: List.from(updatedJournals),
          ));
        } else {
          emit(JournalLoaded(
            journals: [newJournal],
            filteredJournals: [newJournal],
            savedJournals: [],
            favoriteJournals: [],
          ));
        }
      },
    );
  }

  Future<void> _updateJournal(UpdateJournal event, Emitter<JournalState> emit) async {
    final currentState = state;
    emit(JournalLoading());

    final result = await updateJournalUsecase(
      id: event.id,
      date: event.date,
      text: event.text,
      photos: event.photos,
    );

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (updatedJournal) {
        if (currentState is JournalLoaded) {
          final updatedJournals = currentState.journals.map((j) {
            return j.id == event.id ? updatedJournal : j;
          }).toList();

          final updatedFiltered = currentState.filteredJournals.map((j) {
            return j.id == event.id ? updatedJournal : j;
          }).toList();

          emit(currentState.copyWith(
            journals: updatedJournals,
            filteredJournals: updatedFiltered,
          ));
        }
      },
    );
  }

  Future<void> _deleteJournal(DeleteJournal event, Emitter<JournalState> emit) async {
    final currentState = state;
    emit(JournalLoading());

    final result = await deleteJournalUsecase(event.id);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (_) {
        if (currentState is JournalLoaded) {
          final updatedJournals = currentState.journals.where((j) => j.id != event.id).toList();
          final updatedFiltered = currentState.filteredJournals.where((j) => j.id != event.id).toList();
          final updatedSaved = currentState.savedJournals.where((j) => j.id != event.id).toList();
          final updatedFavorite = currentState.favoriteJournals.where((j) => j.id != event.id).toList();

          emit(currentState.copyWith(
            journals: updatedJournals,
            filteredJournals: updatedFiltered,
            savedJournals: updatedSaved,
            favoriteJournals: updatedFavorite,
          ));
        }
      },
    );
  }

  Future<void> _toggleSaveJournal(ToggleSaveJournal event, Emitter<JournalState> emit) async {
    final currentState = state;
    if (_savingJournals.contains(event.journalId)) return;
    _savingJournals.add(event.journalId);

    emit(JournalSavingSavingState(
      journalId: event.journalId,
      previousState: currentState,
    ));

    final params = SaveJournalParams(journalId: event.journalId, userId: event.userId);
    final result = await toggleSaveJournalUseCase(params);

    _savingJournals.remove(event.journalId);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (isSaved) {
        if (currentState is JournalLoaded) {
          final updatedJournals = currentState.journals.map((j) {
            return j.id == event.journalId ? j.copyWith(isSaved: isSaved) : j;
          }).toList();

          final updatedFiltered = currentState.filteredJournals.map((j) {
            return j.id == event.journalId ? j.copyWith(isSaved: isSaved) : j;
          }).toList();

          final updatedSaved = List<JournalEntity>.from(currentState.savedJournals);
          if (isSaved) {
            final journal = updatedJournals.firstWhere((j) => j.id == event.journalId);
            if (!updatedSaved.any((j) => j.id == event.journalId)) updatedSaved.add(journal);
          } else {
            updatedSaved.removeWhere((j) => j.id == event.journalId);
          }

          emit(currentState.copyWith(
            journals: updatedJournals,
            filteredJournals: updatedFiltered,
            savedJournals: updatedSaved,
          ));
        }
      },
    );
  }

  Future<void> _toggleFavoriteJournal(ToggleFavoriteJournal event, Emitter<JournalState> emit) async {
    final currentState = state;
    if (_favoritingJournals.contains(event.journalId)) return;
    _favoritingJournals.add(event.journalId);

    emit(JournalFavoritingState(
      journalId: event.journalId,
      previousState: currentState,
    ));

    final params = FavoriteJournalParams(journalId: event.journalId, userId: event.userId);
    final result = await toggleFavoriteJournalUseCase(params);

    _favoritingJournals.remove(event.journalId);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (isFavorited) {
        if (currentState is JournalLoaded) {
          final updatedJournals = currentState.journals.map((j) {
            return j.id == event.journalId ? j.copyWith(isFavorite: isFavorited) : j;
          }).toList();

          final updatedFiltered = currentState.filteredJournals.map((j) {
            return j.id == event.journalId ? j.copyWith(isFavorite: isFavorited) : j;
          }).toList();

          final updatedFavorite = List<JournalEntity>.from(currentState.favoriteJournals);
          if (isFavorited) {
            final journal = updatedJournals.firstWhere((j) => j.id == event.journalId);
            if (!updatedFavorite.any((j) => j.id == event.journalId)) updatedFavorite.add(journal);
          } else {
            updatedFavorite.removeWhere((j) => j.id == event.journalId);
          }

          emit(currentState.copyWith(
            journals: updatedJournals,
            filteredJournals: updatedFiltered,
            favoriteJournals: updatedFavorite,
          ));
        }
      },
    );
  }

  void _filterJournals(FilterJournals event, Emitter<JournalState> emit) {
    final currentState = state;
    if (currentState is! JournalLoaded) return;

    if (event.query.isEmpty) {
      emit(currentState.copyWith(filteredJournals: List.from(currentState.journals)));
      return;
    }

    final lowerQuery = event.query.toLowerCase();

   final filtered = currentState.journals.where((j) {
  final textMatch = j.text.toLowerCase().contains(lowerQuery);
  final usernameMatch = j.user?.username.toLowerCase().contains(lowerQuery) ?? false;
  final trekMatch = j.trek?.name.toLowerCase().contains(lowerQuery) ?? false;
  return textMatch || usernameMatch || trekMatch;
}).toList();


    emit(currentState.copyWith(filteredJournals: filtered));
  }

  void _clearError(ClearError event, Emitter<JournalState> emit) {
    final currentState = state;
    if (currentState is JournalError) {
      emit(JournalInitial());
    }
  }
}

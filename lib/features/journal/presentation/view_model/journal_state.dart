import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

abstract class JournalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JournalInitial extends JournalState {}

class JournalLoading extends JournalState {}

class JournalLoaded extends JournalState {
  final List<JournalEntity> journals;
  final List<JournalEntity> filteredJournals;
  final List<JournalEntity> savedJournals;
  final List<JournalEntity> favoriteJournals;

  JournalLoaded({
    required this.journals,
    required this.filteredJournals,
    required this.savedJournals,
    required this.favoriteJournals,
  });

  JournalLoaded copyWith({
    List<JournalEntity>? journals,
    List<JournalEntity>? filteredJournals,
    List<JournalEntity>? savedJournals,
    List<JournalEntity>? favoriteJournals,
  }) {
    return JournalLoaded(
      journals: journals ?? this.journals,
      filteredJournals: filteredJournals ?? this.filteredJournals,
      savedJournals: savedJournals ?? this.savedJournals,
      favoriteJournals: favoriteJournals ?? this.favoriteJournals,
    );
  }

  @override
  List<Object?> get props => [journals, filteredJournals, savedJournals, favoriteJournals];
}

class JournalError extends JournalState {
  final String message;

  JournalError({required this.message});

  @override
  List<Object?> get props => [message];
}

class JournalSavingSavingState extends JournalState {
  final String journalId;
  final JournalState previousState;

  JournalSavingSavingState({
    required this.journalId,
    required this.previousState,
  });

  @override
  List<Object?> get props => [journalId];
}

class JournalFavoritingState extends JournalState {
  final String journalId;
  final JournalState previousState;

  JournalFavoritingState({
    required this.journalId,
    required this.previousState,
  });

  @override
  List<Object?> get props => [journalId];
}

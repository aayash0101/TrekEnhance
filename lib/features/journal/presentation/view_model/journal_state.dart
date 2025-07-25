import 'package:equatable/equatable.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

abstract class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object?> get props => [];
}

class JournalInitialState extends JournalState {}

class JournalLoadingState extends JournalState {}

class JournalLoadedState extends JournalState {
  final List<JournalEntity> journals;

  const JournalLoadedState({required this.journals});

  @override
  List<Object?> get props => [journals];
}

class JournalErrorState extends JournalState {
  final String message;

  const JournalErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

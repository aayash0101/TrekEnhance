import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllJournals extends JournalEvent {
  final String userId;
  FetchAllJournals(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchJournalsByUser extends JournalEvent {
  final String userId;
  FetchJournalsByUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchJournalsByTrekAndUser extends JournalEvent {
  final String trekId;
  final String userId;
  FetchJournalsByTrekAndUser({required this.trekId, required this.userId});

  @override
  List<Object?> get props => [trekId, userId];
}

class CreateJournal extends JournalEvent {
  final String userId, trekId, date, text;
  final List<String> photos;

  CreateJournal({
    required this.userId,
    required this.trekId,
    required this.date,
    required this.text,
    required this.photos,
  });

  @override
  List<Object?> get props => [userId, trekId, date, text, photos];
}

class UpdateJournal extends JournalEvent {
  final String id, date, text;
  final List<String> photos;

  UpdateJournal({
    required this.id,
    required this.date,
    required this.text,
    required this.photos,
  });

  @override
  List<Object?> get props => [id, date, text, photos];
}

class DeleteJournal extends JournalEvent {
  final String id;

  DeleteJournal(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleSaveJournal extends JournalEvent {
  final String journalId;
  final String userId;

  ToggleSaveJournal({required this.journalId, required this.userId});

  @override
  List<Object?> get props => [journalId, userId];
}

class ToggleFavoriteJournal extends JournalEvent {
  final String journalId;
  final String userId;

  ToggleFavoriteJournal({required this.journalId, required this.userId});

  @override
  List<Object?> get props => [journalId, userId];
}

class FilterJournals extends JournalEvent {
  final String query;

  FilterJournals(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearError extends JournalEvent {}

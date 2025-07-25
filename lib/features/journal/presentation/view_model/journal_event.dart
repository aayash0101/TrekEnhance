import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch all journals (public feed)
class FetchAllJournalsEvent extends JournalEvent {}

/// Fetch journals by trekId & userId
class FetchJournalsByTrekAndUserEvent extends JournalEvent {
  final String trekId;
  final String userId;

  const FetchJournalsByTrekAndUserEvent({
    required this.trekId,
    required this.userId,
  });

  @override
  List<Object?> get props => [trekId, userId];
}

/// Fetch journals by userId only
class FetchJournalsByUserEvent extends JournalEvent {
  final String userId;

  const FetchJournalsByUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Create new journal
class CreateJournalEvent extends JournalEvent {
  final String userId;
  final String trekId;
  final String date;
  final String text;
  final List<String> photos;

  const CreateJournalEvent({
    required this.userId,
    required this.trekId,
    required this.date,
    required this.text,
    required this.photos,
  });

  @override
  List<Object?> get props => [userId, trekId, date, text, photos];
}

/// Update existing journal
class UpdateJournalEvent extends JournalEvent {
  final String id;
  final String date;
  final String text;
  final List<String> photos;

  const UpdateJournalEvent({
    required this.id,
    required this.date,
    required this.text,
    required this.photos,
  });

  @override
  List<Object?> get props => [id, date, text, photos];
}

/// Delete journal
class DeleteJournalEvent extends JournalEvent {
  final String id;

  const DeleteJournalEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

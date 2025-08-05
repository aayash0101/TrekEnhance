
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';

class GetJournalsWithStatusParams {
  final List<JournalEntity> journals;
  final String userId;

  GetJournalsWithStatusParams({
    required this.journals,
    required this.userId,
  });
}
class HiveTableConstant {
  HiveTableConstant._();

  // Users
  static const int userTableId = 0;
  static const String userBox = 'userBox';

  // Treks
  static const int trekTableId = 1;
  static const String trekBox = 'trekBox';

  // Journals
  static const int journalTableId = 2;
  static const String journalBox = 'journalBox';

  // Reviews (optional, if you cache them separately)
  static const int reviewTableId = 3;
  static const String reviewBox = 'reviewBox';

  // Saved and Favorite Journals
  static const String savedJournalBox = 'saved_journals';
  static const String favoriteJournalBox = 'favorite_journals';
}

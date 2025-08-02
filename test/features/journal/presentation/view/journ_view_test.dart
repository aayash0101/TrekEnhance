import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_trek_e/features/journal/domain/entity/journal_entity.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view/journal_view.dart';
import 'package:flutter_application_trek_e/features/journal/presentation/view_model/journal_view_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';

// Mock ViewModel
class MockJournalViewModel extends Mock implements JournalViewModel {}

void main() {
  late MockJournalViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockJournalViewModel();

    // Always stub these methods to avoid Null -> Future<void> errors
    when(() => mockViewModel.fetchAllJournals()).thenAnswer((_) async {});
    when(() => mockViewModel.filterJournals(any())).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<JournalViewModel>.value(
        value: mockViewModel,
        child: const JournalView(),
      ),
    );
  }

  testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
    when(() => mockViewModel.isLoading).thenReturn(true);
    when(() => mockViewModel.error).thenReturn(null);
    when(() => mockViewModel.filteredJournals).thenReturn([]);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading journal entries...'), findsOneWidget);
  });

  testWidgets('shows error UI when error is set', (WidgetTester tester) async {
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.error).thenReturn('Something went wrong');
    when(() => mockViewModel.filteredJournals).thenReturn([]);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Oops! Something went wrong'), findsOneWidget);
    expect(find.text('Error: Something went wrong'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('shows empty state when filteredJournals is empty', (WidgetTester tester) async {
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.error).thenReturn(null);
    when(() => mockViewModel.filteredJournals).thenReturn([]);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No Journal Entries Found'), findsOneWidget);
    expect(find.byIcon(Icons.book_outlined), findsOneWidget);
  });

  testWidgets('shows list of journals when filteredJournals has data', (WidgetTester tester) async {
    final testUser = UserEntity(
      userId: 'u1',
      username: 'testuser',
      email: 'test@example.com',
      password: 'password',
    );

    final testTrek = TrekEntity(
      id: 't1',
      name: 'Test Trek',
      location: 'Test Location',
      description: 'Description',
      imageUrl: '/image.jpg',
      distance: 10,
      difficulty: 'Easy',
    );

    final testJournal = JournalEntity(
      id: 'j1',
      userId: 'u1',
      trekId: 't1',
      date: DateTime.now().toIso8601String(),
      text: 'This is a test journal entry.',
      photos: ['/photos/photo1.jpg', '/photos/photo2.jpg'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: testUser,
      trek: testTrek,
    );

    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.error).thenReturn(null);
    when(() => mockViewModel.filteredJournals).thenReturn([testJournal]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('This is a test journal entry.'), findsOneWidget);
    expect(find.text('testuser'), findsOneWidget);
    expect(find.text('Test Trek'), findsOneWidget);
  });
}

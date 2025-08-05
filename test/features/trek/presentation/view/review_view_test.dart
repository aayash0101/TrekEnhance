import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view/review_view.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_view_model.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_state.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/review_entity.dart';

// Mock ReviewViewModel
class MockReviewViewModel extends Mock implements ReviewViewModel {}

void main() {
  late MockReviewViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockReviewViewModel();
  });

  testWidgets('shows loading indicator when state is ReviewLoading', (
    tester,
  ) async {
    when(mockViewModel.state).thenReturn(ReviewLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ReviewViewModel>(
          create: (_) => mockViewModel,
          child: const ReviewView(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error UI when state is ReviewError', (tester) async {
    when(mockViewModel.state).thenReturn(const ReviewError('Failed to load'));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ReviewViewModel>(
          create: (_) => mockViewModel,
          child: const ReviewView(),
        ),
      ),
    );

    expect(find.textContaining('Oops! Something went wrong'), findsOneWidget);
    expect(find.textContaining('Failed to load'), findsOneWidget);
  });

  testWidgets('shows list of treks with reviews when state is ReviewLoaded', (
    tester,
  ) async {
    final mockReview = ReviewEntity(
      userId: 'u1', // <-- add required userId
      username: 'TestUser',
      review: 'Amazing trek!',
      date: DateTime.now(),
    );

    final mockTrek = TrekEntity(
      id: 't1',
      name: 'Everest Base Camp',
      imageUrl: '',
      reviews: [mockReview],
    );

    // FIX: pass list as positional argument
    when(mockViewModel.state).thenReturn(ReviewLoaded([mockTrek]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ReviewViewModel>(
          create: (_) => mockViewModel,
          child: const ReviewView(),
        ),
      ),
    );

    expect(find.text('Everest Base Camp'), findsOneWidget);
    expect(find.text('Amazing trek!'), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
  });
}

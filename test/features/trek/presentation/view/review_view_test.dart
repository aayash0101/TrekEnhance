import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

// Import your app files below - adjust paths as needed
import 'package:flutter_application_trek_e/features/trek/presentation/view/review_view.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_view_model.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_event.dart';
import 'package:flutter_application_trek_e/features/trek/presentation/view_model/review_state.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';

// Mock class
class MockReviewViewModel extends Mock implements ReviewViewModel {}

void main() {
  final getIt = GetIt.instance;
  late MockReviewViewModel mockBloc;

  setUp(() {
    mockBloc = MockReviewViewModel();

    if (getIt.isRegistered<ReviewViewModel>()) {
      getIt.unregister<ReviewViewModel>();
    }
    getIt.registerSingleton<ReviewViewModel>(mockBloc);

    // Default state & stream
    when(() => mockBloc.state).thenReturn(ReviewInitial());
    whenListen(mockBloc, Stream<ReviewState>.fromIterable([ReviewInitial()]));

    // Fix for close() method returning null error
    when(() => mockBloc.close()).thenAnswer((_) => Future.value());
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ReviewViewModel>.value(
        value: mockBloc,
        child: const ReviewView(),
      ),
    );
  }

  testWidgets('shows loading indicator when state is ReviewLoading', (tester) async {
    when(() => mockBloc.state).thenReturn(ReviewLoading());
    whenListen(mockBloc, Stream<ReviewState>.fromIterable([ReviewLoading()]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading trek reviews...'), findsOneWidget);
  });

  testWidgets('shows error message when state is ReviewError', (tester) async {
    const errorMsg = 'Failed to load';
    when(() => mockBloc.state).thenReturn(const ReviewError(errorMsg));
    whenListen(mockBloc, Stream<ReviewState>.fromIterable([ReviewError(errorMsg)]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Oops! Something went wrong'), findsOneWidget);
    expect(find.textContaining(errorMsg), findsOneWidget);
  });

  testWidgets('shows empty message when treks list is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(const ReviewLoaded([]));
    whenListen(mockBloc, Stream<ReviewState>.fromIterable([const ReviewLoaded([])]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('No Trek Reviews Yet'), findsOneWidget);
    expect(find.text('Be the first to share your trekking experience!'), findsOneWidget);
  });

  testWidgets('shows list of treks when state is ReviewLoaded with data', (tester) async {
    final treks = [
      TrekEntity(id: '1', name: 'Trek A', location: 'Mountain', description: 'Beautiful trek'),
      TrekEntity(id: '2', name: 'Trek B', location: 'Valley', description: 'Scenic trek'),
    ];
    when(() => mockBloc.state).thenReturn(ReviewLoaded(treks));
    whenListen(mockBloc, Stream<ReviewState>.fromIterable([ReviewLoaded(treks)]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Trek A'), findsOneWidget);
    expect(find.text('Trek B'), findsOneWidget);
  });
}

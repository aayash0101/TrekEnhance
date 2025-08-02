import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_application_trek_e/core/error/failure.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/home_view.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';

// Concrete TestFailure class for tests (since Failure is abstract)
class TestFailure extends Failure {
  const TestFailure(String message) : super(message: message);
}


// Mock classes
class MockHomeViewModel extends Mock implements HomeViewModel {}
class MockHomeRepository extends Mock implements IHomeRepository {}

class FakeHomeState extends Fake implements HomeState {}

void main() {
  final getIt = GetIt.instance;
  late MockHomeViewModel mockViewModel;
  late MockHomeRepository mockRepository;

  final mockTreks = [
    TrekEntity(
      id: '1',
      name: 'Everest Base Camp',
      location: 'Nepal',
      imageUrl: '/images/everest.jpg',
    ),
    TrekEntity(
      id: '2',
      name: 'Annapurna Circuit',
      location: 'Nepal',
      imageUrl: '/images/annapurna.jpg',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeHomeState());
  });

  setUp(() {
    // Register fake repository for GetIt if not already
    if (getIt.isRegistered<IHomeRepository>()) {
      getIt.unregister<IHomeRepository>();
    }
    mockRepository = MockHomeRepository();
    getIt.registerSingleton<IHomeRepository>(mockRepository);

    mockViewModel = MockHomeViewModel();

    // Stub close() so no errors if called
    when(() => mockViewModel.close()).thenAnswer((_) async {});

    // Default stub for stream & state
    when(() => mockViewModel.stream).thenAnswer((_) => Stream<HomeState>.empty());
    when(() => mockViewModel.state).thenReturn(HomeInitial());
  });

  tearDown(() {
    if (getIt.isRegistered<IHomeRepository>()) {
      getIt.unregister<IHomeRepository>();
    }
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<HomeViewModel>.value(
        value: mockViewModel,
        child: const HomeView(),
      ),
    );
  }

  testWidgets('shows loading indicator when state is HomeLoading',
      (WidgetTester tester) async {
    when(() => mockViewModel.state).thenReturn(HomeLoading());
    whenListen(
      mockViewModel,
      Stream<HomeState>.fromIterable([HomeLoading()]),
      initialState: HomeLoading(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading amazing treks...'), findsOneWidget);
  });

  testWidgets('shows list of treks when state is HomeLoaded',
      (WidgetTester tester) async {
    when(() => mockViewModel.state).thenReturn(HomeLoaded(mockTreks));
    whenListen(
      mockViewModel,
      Stream<HomeState>.fromIterable([HomeLoaded(mockTreks)]),
      initialState: HomeLoaded(mockTreks),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Everest Base Camp'), findsOneWidget);
    expect(find.text('Annapurna Circuit'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows error UI when state is HomeError',
      (WidgetTester tester) async {
    const errorMsg = 'Failed to load treks';

    // Stub repository method to return failure wrapped in Left
    when(() => mockRepository.getAllTreks())
        .thenAnswer((_) async => Left(TestFailure(errorMsg)));

    when(() => mockViewModel.state).thenReturn(HomeError(errorMsg));
    whenListen(
      mockViewModel,
      Stream<HomeState>.fromIterable([HomeError(errorMsg)]),
      initialState: HomeError(errorMsg),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Oops! Something went wrong'), findsOneWidget);
    expect(find.text(errorMsg), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('shows welcome text on HomeInitial state',
      (WidgetTester tester) async {
    when(() => mockViewModel.state).thenReturn(HomeInitial());
    whenListen(
      mockViewModel,
      Stream<HomeState>.fromIterable([HomeInitial()]),
      initialState: HomeInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to TrekEnhance'), findsOneWidget);
  });
}

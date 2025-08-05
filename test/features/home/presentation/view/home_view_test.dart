import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/home_view.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';

// Mock classes
class MockHomeRepository extends Mock implements IHomeRepository {}

void main() {
  late MockHomeRepository mockRepository;

  setUp(() async {
    // Make sure service locator is reset or unregister old repo if already registered
    if (serviceLocator.isRegistered<IHomeRepository>()) {
      serviceLocator.unregister<IHomeRepository>();
    }

    mockRepository = MockHomeRepository();

    // Register mocked repository in the service locator,
    // so HomeViewModel created inside HomeView uses this mock
    serviceLocator.registerLazySingleton<IHomeRepository>(() => mockRepository);
  });

 testWidgets('HomeView shows loading state with progress indicator and text', (tester) async {
  // Mock getAllTreks to return a Future that never completes immediately,
  // so bloc stays in loading state during the first frame(s).
  when(() => mockRepository.getAllTreks()).thenAnswer(
    (_) => Future.delayed(const Duration(seconds: 5), () => Right(<TrekEntity>[])),
  );

  await tester.pumpWidget(const MaterialApp(home: HomeView()));

  // Immediately after pump, it should show loading UI
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Loading amazing treks...'), findsOneWidget);
});

  testWidgets('HomeView shows empty state when no treks are available', (tester) async {
    // Return empty list wrapped in your Either type
    when(() => mockRepository.getAllTreks()).thenAnswer(
      (_) async => Right(<TrekEntity>[]), // Adjust Right() constructor if needed
    );

    await tester.pumpWidget(const MaterialApp(home: HomeView()));
    await tester.pumpAndSettle();

    expect(find.text('No treks found.'), findsOneWidget);
  });




}

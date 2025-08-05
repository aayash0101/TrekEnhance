import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_trek_e/features/home/domain/entity/trek_entity.dart';
import 'package:flutter_application_trek_e/features/home/domain/repository/home_repository.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view/home_view.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter_application_trek_e/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/core/error/failure.dart';

class MockHomeRepository extends Mock implements IHomeRepository {}

void main() {
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();

    if (serviceLocator.isRegistered<IHomeRepository>()) {
      serviceLocator.unregister<IHomeRepository>();
    }
    serviceLocator.registerSingleton<IHomeRepository>(mockHomeRepository);

    // Stub getAllTreks to return empty list (simulate no treks)
    when(() => mockHomeRepository.getAllTreks())
        .thenAnswer((_) async => Right(<TrekEntity>[]));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: HomeView(),
    );
  }

  testWidgets('shows empty message when treks list is empty', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // BLoC emits loading -> loaded with empty list, so need to pump twice
    await tester.pump(); // Start build + initial BLoC loading state
    await tester.pump(const Duration(seconds: 1)); // Let BLoC finish fetching

    expect(find.text('No treks found.'), findsOneWidget);
  });
}

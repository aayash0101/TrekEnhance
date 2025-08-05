import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view/user_profile_view.dart'; // Adjust import
import 'package:flutter_application_trek_e/features/profile/presentation/view_model/user_profile_view_model.dart'; // Adjust import

// Mock IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  final sl = GetIt.instance;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();

    if (sl.isRegistered<IUserRepository>()) {
      sl.unregister<IUserRepository>();
    }
    sl.registerSingleton<IUserRepository>(mockUserRepository);
  });

  tearDown(() {
    sl.reset();
  });
  testWidgets('shows user data when loaded', (tester) async {
    // Arrange: mock getCurrentUser to immediately return user data
    when(() => mockUserRepository.getCurrentUser())
      .thenAnswer((_) async => Right(UserEntity(
        userId: '123',
        username: 'testuser',
        email: 'test@example.com',
        password: '',
      )));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfileView(userId: '123',),
      ),
    );

    // Allow UI to rebuild after future completes
    await tester.pumpAndSettle();

    // Assert user data is shown on screen (e.g., username text)
    expect(find.text('testuser'), findsOneWidget);
  });
}

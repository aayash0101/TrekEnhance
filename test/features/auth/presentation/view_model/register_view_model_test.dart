import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/domain/use_case/user_image_upload_usecase.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter_application_trek_e/features/auth/domain/entity/user_entity.dart';


// Mock and Fake classes
class MockRegisterUserUseCase extends Mock implements UserRegisterUsecase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

class FakeRegisterUserParams extends Fake implements RegisterUserParams {}

class FakeUploadImageParams extends Fake implements UploadImageParams {}

void main() {
  late MockRegisterUserUseCase mockRegisterUserUsecase;
  late MockUploadImageUsecase mockUploadImageUsecase;

  setUpAll(() {
    registerFallbackValue(FakeRegisterUserParams());
    registerFallbackValue(FakeUploadImageParams());
  });

  setUp(() {
    mockRegisterUserUsecase = MockRegisterUserUseCase();
    mockUploadImageUsecase = MockUploadImageUsecase();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('emits success state after successful registration', (tester) async {
    final viewModel = RegisterViewModel(mockRegisterUserUsecase, mockUploadImageUsecase);

    // Stub your user registration use case
    when(() => mockRegisterUserUsecase.call(any())).thenAnswer(
      (_) async => Right(UserEntity(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123', // required!
      )),
    );

    // Stub image upload to not interfere (or mock success if you want)
    when(() => mockUploadImageUsecase.call(any())).thenAnswer(
      (_) async => Right('mocked_image_name.jpg'),
    );

    await tester.pumpWidget(
      buildTestableWidget(
        BlocProvider.value(
          value: viewModel,
          child: Builder(
            builder: (context) {
              viewModel.add(RegisterUserEvent(
                context: context,
                username: 'testuser',
                email: 'test@example.com',
                password: 'password123',
              ));
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // wait for bloc to finish processing

    expect(viewModel.state.isSuccess, true);
  });
}

import 'dart:io';

import 'package:flutter/material.dart';


@immutable
sealed class RegisterEvent {}

class UploadImageEvent extends RegisterEvent {
  final File file;

  UploadImageEvent({required this.file});
}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final String phone;
  final String username;
  final String password;
  final String? image;

  RegisterUserEvent({
    required this.context,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.username,
    required this.password,
    this.image,
  });
}
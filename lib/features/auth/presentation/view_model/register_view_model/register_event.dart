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
  final String email;
  final String username;
  final String password;
  final String? image;

  RegisterUserEvent({
    required this.context,
    required this.email,
    required this.username,
    required this.password,
    this.image,
  });
}
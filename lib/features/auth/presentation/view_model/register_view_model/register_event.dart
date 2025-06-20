import 'dart:io';

import 'package:flutter/material.dart';


@immutable
sealed class RegisterEvent {}

class LoadCoursesAndBatchesEvent extends RegisterEvent {}

class UploadImageEvent extends RegisterEvent {
  final File file;

  UploadImageEvent({required this.file});
}

class RegisterStudentEvent extends RegisterEvent {
  final BuildContext context;
  final String fName;
  final String lName;
  final String phone;
  final String username;
  final String password;
  final String? image;

  RegisterStudentEvent({
    required this.context,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.username,
    required this.password,
    this.image,
  });
}
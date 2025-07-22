import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Failure for local Hive database (user)
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({required String message}) : super(message: message);
}

/// Failure for remote API / server calls (user)
class RemoteDatabaseFailure extends Failure {
  final int? statusCode;

  const RemoteDatabaseFailure({this.statusCode, required String message})
      : super(message: message);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure for shared preferences / storage
class SharedPreferencesFailure extends Failure {
  const SharedPreferencesFailure({required String message}) : super(message: message);
}

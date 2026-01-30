import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure(super.message);
}

class DataConflictFailure extends Failure {
  const DataConflictFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

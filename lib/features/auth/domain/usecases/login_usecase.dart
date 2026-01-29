import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/failure/failure.dart';

import '../entities/employee_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, EmployeeEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}

import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/failure/failure.dart';

import '../entities/employee_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, EmployeeEntity>> call({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? jobTitle,
  }) {
    return repository.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      jobTitle: jobTitle,
    );
  }
}

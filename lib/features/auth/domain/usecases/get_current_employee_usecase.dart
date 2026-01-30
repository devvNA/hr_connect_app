import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';

import '../entities/employee_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current logged-in employee
class GetCurrentEmployeeUseCase {
  final AuthRepository repository;

  GetCurrentEmployeeUseCase(this.repository);

  Future<Either<Failure, EmployeeEntity>> call() {
    return repository.getCurrentUser();
  }
}

import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/failure/failure.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, EmployeeEntity>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, EmployeeEntity>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? jobTitle,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, EmployeeEntity>> getCurrentUser();
}

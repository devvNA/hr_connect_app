import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, EmployeeEntity>> login({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<Either<Failure, EmployeeEntity>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? jobTitle,
  }) async {
    return await remoteDataSource.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      jobTitle: jobTitle,
    );
  }

  @override
  Future<Either<Failure, EmployeeEntity>> getCurrentUser() async {
    final result = await remoteDataSource.getCurrentEmployee();
    return result.fold((failure) => Left(failure), (employee) {
      if (employee == null) {
        return Left(AuthenticationFailure('Session expired'));
      }
      return Right(employee);
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return await remoteDataSource.logout();
  }
}

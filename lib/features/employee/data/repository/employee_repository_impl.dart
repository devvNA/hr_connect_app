import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/employee/data/datasources/employee_remote_datasource.dart';
import 'package:hr_connect/features/employee/domain/entities/department_entity.dart';
import 'package:hr_connect/features/employee/domain/entities/employee_list_entity.dart';
import 'package:hr_connect/features/employee/domain/repositories/employee_repository.dart';

/// Implementation of [EmployeeRepository]
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource _remoteDataSource;

  EmployeeRepositoryImpl({required EmployeeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments() async {
    try {
      final departments = await _remoteDataSource.getDepartments();
      return Right(departments);
    } catch (e) {
      return Left(
        ServerFailure('Failed to fetch departments: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<EmployeeListEntity>>> getEmployees({
    String? departmentId,
    String? searchQuery,
  }) async {
    try {
      final employees = await _remoteDataSource.getEmployees(
        departmentId: departmentId,
        searchQuery: searchQuery,
      );
      return Right(employees);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch employees: ${e.toString()}'));
    }
  }
}

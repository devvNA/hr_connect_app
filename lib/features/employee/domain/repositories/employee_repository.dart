import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/employee/domain/entities/department_entity.dart';
import 'package:hr_connect/features/employee/domain/entities/employee_list_entity.dart';

/// Repository interface for Employee feature
abstract class EmployeeRepository {
  /// Get all departments for filter chips
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments();

  /// Get employees list with optional department filter
  /// [departmentId] - filter by department, null means all employees
  /// [searchQuery] - search by name or email
  Future<Either<Failure, List<EmployeeListEntity>>> getEmployees({
    String? departmentId,
    String? searchQuery,
  });
}

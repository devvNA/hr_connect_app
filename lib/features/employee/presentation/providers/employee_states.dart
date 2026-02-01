import 'package:hr_connect/features/employee/domain/entities/department_entity.dart';
import 'package:hr_connect/features/employee/domain/entities/employee_list_entity.dart';

/// State for department list (filter chips)
sealed class DepartmentListState {
  const DepartmentListState();
}

class DepartmentListInitial extends DepartmentListState {}

class DepartmentListLoading extends DepartmentListState {}

class DepartmentListLoaded extends DepartmentListState {
  final List<DepartmentEntity> departments;
  final String? selectedDepartmentId;

  const DepartmentListLoaded({
    required this.departments,
    this.selectedDepartmentId,
  });
}

class DepartmentListError extends DepartmentListState {
  final String message;
  const DepartmentListError(this.message);
}

/// State for employee list
sealed class EmployeeListState {
  const EmployeeListState();
}

class EmployeeListInitial extends EmployeeListState {}

class EmployeeListLoading extends EmployeeListState {}

class EmployeeListLoaded extends EmployeeListState {
  final List<EmployeeListEntity> employees;
  final String? searchQuery;

  const EmployeeListLoaded({required this.employees, this.searchQuery});
}

class EmployeeListError extends EmployeeListState {
  final String message;
  const EmployeeListError(this.message);
}

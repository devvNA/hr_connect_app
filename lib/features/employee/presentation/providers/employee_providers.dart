import 'package:hr_connect/features/employee/data/datasources/employee_remote_datasource.dart';
import 'package:hr_connect/features/employee/data/repository/employee_repository_impl.dart';
import 'package:hr_connect/features/employee/domain/entities/department_entity.dart';
import 'package:hr_connect/features/employee/domain/entities/employee_list_entity.dart';
import 'package:hr_connect/features/employee/domain/repositories/employee_repository.dart';
import 'package:hr_connect/features/employee/presentation/providers/employee_states.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'employee_providers.g.dart';

/// Remote data source provider
@riverpod
EmployeeRemoteDataSource employeeRemoteDataSource(Ref ref) {
  return EmployeeRemoteDataSourceImpl(supabase: Supabase.instance.client);
}

/// Repository provider
@riverpod
EmployeeRepository employeeRepository(Ref ref) {
  return EmployeeRepositoryImpl(
    remoteDataSource: ref.watch(employeeRemoteDataSourceProvider),
  );
}

/// Department list notifier for filter chips
@riverpod
class DepartmentListNotifier extends _$DepartmentListNotifier {
  @override
  DepartmentListState build() {
    // Auto-load departments on initialization
    loadDepartments();
    return DepartmentListLoading();
  }

  Future<void> loadDepartments() async {
    state = DepartmentListLoading();

    final result = await ref.read(employeeRepositoryProvider).getDepartments();

    result.fold(
      (failure) => state = DepartmentListError(failure.message),
      (departments) => state = DepartmentListLoaded(
        departments: departments,
        selectedDepartmentId: null, // null = "All"
      ),
    );
  }

  void selectDepartment(String? departmentId) {
    final currentState = state;
    if (currentState is DepartmentListLoaded) {
      state = DepartmentListLoaded(
        departments: currentState.departments,
        selectedDepartmentId: departmentId,
      );
      // Trigger employee list reload with new filter
      ref
          .read(employeeListProvider.notifier)
          .loadEmployees(departmentId: departmentId);
    }
  }
}

/// Employee list notifier
@riverpod
class EmployeeListNotifier extends _$EmployeeListNotifier {
  @override
  EmployeeListState build() {
    // Auto-load employees on initialization
    loadEmployees();
    return EmployeeListLoading();
  }

  Future<void> loadEmployees({
    String? departmentId,
    String? searchQuery,
  }) async {
    state = EmployeeListLoading();

    final result = await ref
        .read(employeeRepositoryProvider)
        .getEmployees(departmentId: departmentId, searchQuery: searchQuery);

    result.fold(
      (failure) => state = EmployeeListError(failure.message),
      (employees) => state = EmployeeListLoaded(
        employees: employees,
        searchQuery: searchQuery,
      ),
    );
  }

  void search(String query) {
    // Get current department filter
    final deptState = ref.read(departmentListProvider);
    String? deptId;
    if (deptState is DepartmentListLoaded) {
      deptId = deptState.selectedDepartmentId;
    }

    loadEmployees(
      departmentId: deptId,
      searchQuery: query.isEmpty ? null : query,
    );
  }

  Future<void> refresh() async {
    final deptState = ref.read(departmentListProvider);
    String? deptId;
    if (deptState is DepartmentListLoaded) {
      deptId = deptState.selectedDepartmentId;
    }

    final currentState = state;
    String? searchQuery;
    if (currentState is EmployeeListLoaded) {
      searchQuery = currentState.searchQuery;
    }

    await loadEmployees(departmentId: deptId, searchQuery: searchQuery);
  }
}

/// Helper provider: departments as list
@riverpod
List<DepartmentEntity> departmentsData(Ref ref) {
  final state = ref.watch(departmentListProvider);
  return switch (state) {
    DepartmentListLoaded(departments: final deps) => deps,
    _ => [],
  };
}

/// Helper provider: selected department ID
@riverpod
String? currentDepartmentId(Ref ref) {
  final state = ref.watch(departmentListProvider);
  return switch (state) {
    DepartmentListLoaded(selectedDepartmentId: final id) => id,
    _ => null,
  };
}

/// Helper provider: employees as list
@riverpod
List<EmployeeListEntity> employeesData(Ref ref) {
  final state = ref.watch(employeeListProvider);
  return switch (state) {
    EmployeeListLoaded(employees: final emps) => emps,
    _ => [],
  };
}

/// Helper provider: employee count
@riverpod
int employeeCount(Ref ref) {
  return ref.watch(employeesDataProvider).length;
}

import 'package:hr_connect/features/employee/data/models/department_model.dart';
import 'package:hr_connect/features/employee/data/models/employee_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source interface for Employee feature
abstract class EmployeeRemoteDataSource {
  /// Fetch all departments
  Future<List<DepartmentModel>> getDepartments();

  /// Fetch employees with optional filters
  Future<List<EmployeeListModel>> getEmployees({
    String? departmentId,
    String? searchQuery,
  });
}

/// Implementation using Supabase
class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final SupabaseClient _supabase;

  EmployeeRemoteDataSourceImpl({required SupabaseClient supabase})
    : _supabase = supabase;

  @override
  Future<List<DepartmentModel>> getDepartments() async {
    final response = await _supabase
        .from('departments')
        .select('*')
        .order('name', ascending: true);

    return (response as List)
        .map((json) => DepartmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<EmployeeListModel>> getEmployees({
    String? departmentId,
    String? searchQuery,
  }) async {
    // Call RPC function with parameters
    final response = await _supabase.rpc(
      'get_employee_list',
      params: {
        'search_query': searchQuery,
        'filter_department_id': departmentId,
      },
    );

    return (response as List)
        .map((json) => EmployeeListModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

import '../../domain/entities/employee_list_entity.dart';

/// Simplified data model for Employee list from RPC
class EmployeeListModel extends EmployeeListEntity {
  EmployeeListModel({
    required super.id,
    required super.fullName,
    required super.jobTitle,
    required super.departmentName,
    super.avatarUrl,
    required super.status,
  });

  /// Create model from RPC JSON response
  factory EmployeeListModel.fromJson(Map<String, dynamic> json) {
    return EmployeeListModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      jobTitle: json['job_title'] as String,
      departmentName: json['department_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      status: json['status'] as String,
    );
  }
}

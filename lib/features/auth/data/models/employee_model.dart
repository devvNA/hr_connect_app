import '../../domain/entities/employee_entity.dart';

/// Data model for Employee with JSON serialization
class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phone,
    super.departmentId,
    super.jobTitle,
    super.status = EmployeeStatus.active,
    required super.joinDate,
    super.role = EmployeeRole.employee,
    super.avatarUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Parse status string from database to enum
  static EmployeeStatus _parseStatus(String? status) {
    return switch (status) {
      'Active' => EmployeeStatus.active,
      'Inactive' => EmployeeStatus.inactive,
      'On Leave' => EmployeeStatus.onLeave,
      'Probation' => EmployeeStatus.probation,
      _ => EmployeeStatus.active,
    };
  }

  /// Parse role string from database to enum
  static EmployeeRole _parseRole(String? role) {
    return switch (role) {
      'Admin' => EmployeeRole.admin,
      'Manager' => EmployeeRole.manager,
      'Employee' => EmployeeRole.employee,
      _ => EmployeeRole.employee,
    };
  }

  /// Convert status enum to database string
  static String _statusToString(EmployeeStatus status) {
    return switch (status) {
      EmployeeStatus.active => 'Active',
      EmployeeStatus.inactive => 'Inactive',
      EmployeeStatus.onLeave => 'On Leave',
      EmployeeStatus.probation => 'Probation',
    };
  }

  /// Convert role enum to database string
  static String _roleToString(EmployeeRole role) {
    return switch (role) {
      EmployeeRole.admin => 'Admin',
      EmployeeRole.manager => 'Manager',
      EmployeeRole.employee => 'Employee',
    };
  }

  /// Create model from Supabase JSON response
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      departmentId: json['department_id'] as String?,
      jobTitle: json['job_title'] as String?,
      status: _parseStatus(json['status'] as String?),
      joinDate: DateTime.parse(json['join_date'] as String),
      role: _parseRole(json['role'] as String?),
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert model to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'department_id': departmentId,
      'job_title': jobTitle,
      'status': _statusToString(status),
      'join_date': joinDate.toIso8601String().split('T').first,
      'role': _roleToString(role),
      'avatar_url': avatarUrl,
    };
  }

  /// Create JSON for new employee registration (without id, timestamps)
  Map<String, dynamic> toInsertJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'job_title': jobTitle,
      'status': _statusToString(status),
      'join_date': joinDate.toIso8601String().split('T').first,
      'role': _roleToString(role),
    };
  }
}

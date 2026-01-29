/// Employee status enum
enum EmployeeStatus { active, inactive, onLeave, probation }

/// Employee role enum for RBAC
enum EmployeeRole { admin, manager, employee }

/// Domain entity representing an Employee
class EmployeeEntity {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? departmentId;
  final String? jobTitle;
  final EmployeeStatus status;
  final DateTime joinDate;
  final EmployeeRole role;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmployeeEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.departmentId,
    this.jobTitle,
    this.status = EmployeeStatus.active,
    required this.joinDate,
    this.role = EmployeeRole.employee,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == EmployeeRole.admin;
  bool get isManager =>
      role == EmployeeRole.manager || role == EmployeeRole.admin;
}

/// Simplified employee entity for list display
class EmployeeListEntity {
  final String id;
  final String fullName;
  final String jobTitle;
  final String departmentName;
  final String? avatarUrl;
  final String status;

  const EmployeeListEntity({
    required this.id,
    required this.fullName,
    required this.jobTitle,
    required this.departmentName,
    this.avatarUrl,
    required this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeListEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

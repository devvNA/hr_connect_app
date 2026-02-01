/// Domain entity representing a Department
class DepartmentEntity {
  final String id;
  final String name;
  final String? managerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DepartmentEntity({
    required this.id,
    required this.name,
    this.managerId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

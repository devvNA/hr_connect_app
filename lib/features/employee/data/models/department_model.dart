import '../../domain/entities/department_entity.dart';

/// Data model for Department with JSON serialization
class DepartmentModel extends DepartmentEntity {
  DepartmentModel({
    required super.id,
    required super.name,
    super.managerId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from Supabase JSON response
  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      managerId: json['manager_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert model to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'manager_id': managerId};
  }
}

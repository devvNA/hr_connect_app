import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final EmployeeEntity employee;
  const AuthLoaded(this.employee);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? source;
  const AuthError(this.message, {this.source});
}

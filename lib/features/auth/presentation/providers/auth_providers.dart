import 'package:hr_connect/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hr_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:hr_connect/features/auth/domain/usecases/get_current_employee_usecase.dart';
import 'package:hr_connect/features/auth/domain/usecases/login_usecase.dart';
import 'package:hr_connect/features/auth/domain/usecases/logout_usecase.dart';
import 'package:hr_connect/features/auth/domain/usecases/register_usecase.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_states.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

part 'auth_providers.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(supabase: Supabase.instance.client);
}

/// Get current employee use case provider
@riverpod
GetCurrentEmployeeUseCase getCurrentEmployeeUseCase(Ref ref) {
  return GetCurrentEmployeeUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
}

/// Login use case provider
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

/// Logout use case provider
@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

/// Register use case provider
@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Check if user already has an active session
    _checkCurrentSession();
    return AuthLoading();
  }

  /// Check for existing Supabase session on app start
  Future<void> _checkCurrentSession() async {
    final result = await ref.read(getCurrentEmployeeUseCaseProvider).call();
    result.fold(
      // No session or error → show login
      (failure) => state = AuthUnauthenticated(),
      // Has valid session → load employee
      (employee) => state = AuthLoaded(employee),
    );
  }

  /// Sign in with email and password
  Future<void> login({required String email, required String password}) async {
    final result = await ref
        .read(loginUseCaseProvider)
        .call(email: email, password: password);
    result.fold(
      (failure) => state = AuthError(failure.message, source: 'login'),
      (employee) => state = AuthLoaded(employee),
    );
  }

  /// Sign out the current user
  Future<void> logout() async {
    state = AuthLoading();
    final result = await ref.read(logoutUseCaseProvider).call();
    result.fold(
      (failure) => state = AuthError(failure.message, source: 'login'),
      (_) => state = AuthUnauthenticated(),
    );
  }

  /// Register a new user
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final result = await ref
        .read(registerUseCaseProvider)
        .call(email: email, password: password, fullName: fullName);
    result.fold(
      (failure) => state = AuthError(failure.message, source: 'register'),
      (employee) => state = AuthLoaded(employee),
    );
  }

  /// Get current authenticated employee
  Future<void> getCurrentEmployee() async {
    state = AuthLoading();
    final result = await ref.read(getCurrentEmployeeUseCaseProvider).call();
    result.fold(
      (failure) => state = AuthError(failure.message, source: 'login'),
      (employee) => state = AuthLoaded(employee),
    );
  }

  /// Clear error state - resets to initial
  void clearError() {
    if (state is AuthError) {
      state = AuthUnauthenticated();
    }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/core/utils/logger.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_constants.dart';
import '../models/employee_model.dart';

/// Remote data source for authentication operations
abstract class AuthRemoteDataSource {
  Future<Either<Failure, EmployeeModel>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, EmployeeModel>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? jobTitle,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, EmployeeModel?>> getCurrentEmployee();
}

/// Implementation of AuthRemoteDataSource using Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;

  AuthRemoteDataSourceImpl({required this.supabase});

  @override
  Future<Either<Failure, EmployeeModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left(AuthenticationFailure('User not found'));
      }

      // Fetch employee data
      final employee = await _getEmployeeByAuthId(response.user!.id);
      return Right(employee);
    } on AuthException catch (e) {
      return Left(_handleAuthException(e));
    } on PostgrestException catch (e) {
      return Left(_handlePostgrestException(e));
    } on SocketException catch (_) {
      return Left(NetworkFailure('Tidak ada koneksi internet'));
    } on TimeoutException catch (_) {
      return Left(NetworkFailure('Koneksi timeout. Silakan coba lagi'));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? jobTitle,
  }) async {
    try {
      // 1. Create auth user
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left(AuthenticationFailure('User not found'));
      }

      // 2. Create employee record
      final now = DateTime.now();
      final employeeModel = EmployeeModel(
        id: response.user!.id,
        fullName: fullName,
        email: email,
        phone: phone,
        jobTitle: jobTitle,
        status: EmployeeStatus.probation,
        joinDate: now,
        role: EmployeeRole.employee,
        createdAt: now,
        updatedAt: now,
      );

      await supabase
          .from(SupabaseConstants.employeesTable)
          .insert(employeeModel.toInsertJson());

      return Right(employeeModel);
    } on AuthException catch (e) {
      Logger.error(e.message);
      return Left(_handleAuthException(e));
    } on PostgrestException catch (e) {
      Logger.error(e.message);
      return Left(_handlePostgrestException(e));
    } on SocketException catch (_) {
      Logger.error('Tidak ada koneksi internet');
      return Left(NetworkFailure('Tidak ada koneksi internet'));
    } on TimeoutException catch (_) {
      return Left(NetworkFailure('Koneksi timeout. Silakan coba lagi'));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await supabase.auth.signOut();
      return const Right(());
    } on AuthException catch (e) {
      return Left(_handleAuthException(e));
    } on PostgrestException catch (e) {
      return Left(_handlePostgrestException(e));
    } on SocketException catch (_) {
      return Left(NetworkFailure('Tidak ada koneksi internet'));
    } on TimeoutException catch (_) {
      return Left(NetworkFailure('Koneksi timeout. Silakan coba lagi'));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel?>> getCurrentEmployee() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return const Right(null);

      // Query directly to 'employees' table
      final response = await supabase
          .from(SupabaseConstants.employeesTable)
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) return const Right(null);

      return Right(EmployeeModel.fromJson(response));
    } on AuthException catch (e) {
      return Left(_handleAuthException(e));
    } on PostgrestException catch (e) {
      return Left(_handlePostgrestException(e));
    } on SocketException catch (_) {
      return Left(NetworkFailure('Tidak ada koneksi internet'));
    } on TimeoutException catch (_) {
      return Left(NetworkFailure('Koneksi timeout. Silakan coba lagi'));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  /// Get employee data by auth user ID
  Future<EmployeeModel> _getEmployeeByAuthId(String authId) async {
    try {
      final response = await supabase
          .from(SupabaseConstants.employeesTable)
          .select()
          .eq('id', authId)
          .single();

      return EmployeeModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }
}

/// Handle Supabase Auth specific exceptions
Failure _handleAuthException(AuthException exception) {
  switch (exception.statusCode) {
    case '400':
      if (exception.message.toLowerCase().contains(
        'invalid login credentials',
      )) {
        return AuthenticationFailure('Email atau password salah');
      }
      return AuthenticationFailure('Permintaan tidak valid');

    case '401':
      return AuthenticationFailure('Email atau password salah');

    case '422':
      return ValidationFailure('User sudah terdaftar');

    case '429':
      return AuthenticationFailure(
        'Terlalu banyak percobaan login. Silakan coba lagi nanti',
      );

    default:
      return AuthenticationFailure(exception.message);
  }
}

/// Handle Supabase Postgrest specific exceptions
Failure _handlePostgrestException(PostgrestException exception) {
  switch (exception.code) {
    case 'PGRST116':
      return DataNotFoundFailure('Data tidak ditemukan');

    case '42P01':
      return ServerFailure('Tabel database tidak ditemukan');

    case '23505':
      return DataConflictFailure('Data sudah ada');

    default:
      return ServerFailure(exception.message);
  }
}

import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/constants/supabase_constants.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance_map/data/models/attendance_map_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AttendanceMapRemoteDatasource {
  Future<Either<Failure, AttendanceMapModel>> getActiveOffice();
}

class AttendanceMapRemoteDatasourceImpl
    implements AttendanceMapRemoteDatasource {
  final SupabaseClient supabase;

  AttendanceMapRemoteDatasourceImpl(this.supabase);

  @override
  Future<Either<Failure, AttendanceMapModel>> getActiveOffice() async {
    try {
      final response = await supabase
          .from(SupabaseConstants.officeLocationsTable)
          .select()
          .eq('is_active', true)
          .limit(1)
          .single();

      return Right(AttendanceMapModel.fromJson(response));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return const Left(
          DataNotFoundFailure('No active office location configured'),
        );
      }
      return Left(ServerFailure(e.message));
    } on SocketException catch (_) {
      return const Left(NetworkFailure('No internet connection'));
    } on TimeoutException catch (_) {
      return const Left(NetworkFailure('Connection timeout'));
    } catch (e) {
      return Left(ServerFailure('Failed to load office location: $e'));
    }
  }
}
